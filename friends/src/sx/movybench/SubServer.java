package sx.movybench;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.charset.StandardCharsets;

/**
 * Tiny HTTP server on the phone that hands the current WebVTT file to the
 * Chromecast. The Cast receiver loads text tracks with XHR, so every answer
 * carries CORS headers, and OPTIONS preflights are answered too.
 *
 * Only one document is served: /subs/<version>.vtt. The version number in the
 * path changes whenever the text changes, so the receiver never shows a stale
 * cached copy. Pure java.net, so it is tested on a plain JDK.
 */
public final class SubServer {

    private static final String CORS =
            "Access-Control-Allow-Origin: *\r\n"
                    + "Access-Control-Allow-Methods: GET, HEAD, OPTIONS\r\n"
                    + "Access-Control-Allow-Headers: *\r\n";

    private static SubServer instance;

    private final ServerSocket socket;
    private volatile byte[] body = new byte[0];
    private volatile int version = 0;
    private volatile boolean running = true;

    private SubServer(ServerSocket socket) {
        this.socket = socket;
    }

    /** Starts (once) and returns the shared server, or null if binding fails. */
    public static synchronized SubServer get() {
        if (instance != null && instance.running && !instance.socket.isClosed()) {
            return instance;
        }
        try {
            ServerSocket ss = new ServerSocket();
            ss.setReuseAddress(true);
            ss.bind(new InetSocketAddress(0), 16);
            SubServer s = new SubServer(ss);
            Thread t = new Thread(new Acceptor(s), "friends-subserver");
            t.setDaemon(true);
            t.start();
            instance = s;
            return s;
        } catch (IOException e) {
            return null;
        }
    }

    public int port() {
        return socket.getLocalPort();
    }

    /** Publishes new VTT text. Returns the path to hand to the receiver. */
    public synchronized String publish(String vtt) {
        byte[] next = vtt == null ? new byte[0] : vtt.getBytes(StandardCharsets.UTF_8);
        if (!java.util.Arrays.equals(next, body) || version == 0) {
            body = next;
            version++;
        }
        return "/subs/" + version + ".vtt";
    }

    public String currentText() {
        return new String(body, StandardCharsets.UTF_8);
    }

    public void close() {
        running = false;
        try {
            socket.close();
        } catch (IOException ignored) {
            // already closed
        }
    }

    void handle(Socket s) {
        try {
            s.setSoTimeout(8000);
            InputStream in = s.getInputStream();
            String requestLine = readLine(in);
            if (requestLine == null) {
                return;
            }
            // drain headers
            String h;
            do {
                h = readLine(in);
            } while (h != null && !h.isEmpty());

            String[] parts = requestLine.split(" ");
            String method = parts.length > 0 ? parts[0] : "";
            String path = parts.length > 1 ? parts[1] : "/";
            int q = path.indexOf('?');
            if (q >= 0) {
                path = path.substring(0, q);
            }
            OutputStream out = s.getOutputStream();
            if ("OPTIONS".equals(method)) {
                write(out, "204 No Content", "text/plain", new byte[0], false);
            } else if (!"GET".equals(method) && !"HEAD".equals(method)) {
                write(out, "405 Method Not Allowed", "text/plain", new byte[0], false);
            } else if (path.startsWith("/subs/") && path.endsWith(".vtt") && body.length > 0) {
                write(out, "200 OK", "text/vtt; charset=utf-8", body, "HEAD".equals(method));
            } else {
                write(out, "404 Not Found", "text/plain", new byte[0], false);
            }
            out.flush();
        } catch (IOException ignored) {
            // client went away; nothing to do
        } finally {
            try {
                s.close();
            } catch (IOException ignored) {
                // ignore
            }
        }
    }

    private static void write(OutputStream out, String status, String type, byte[] data,
                              boolean headOnly) throws IOException {
        String head = "HTTP/1.1 " + status + "\r\n"
                + "Content-Type: " + type + "\r\n"
                + "Content-Length: " + data.length + "\r\n"
                + "Cache-Control: no-cache\r\n"
                + CORS
                + "Connection: close\r\n\r\n";
        out.write(head.getBytes(StandardCharsets.US_ASCII));
        if (!headOnly && data.length > 0) {
            out.write(data);
        }
    }

    private static String readLine(InputStream in) throws IOException {
        StringBuilder sb = new StringBuilder();
        int c;
        while ((c = in.read()) != -1) {
            if (c == '\n') {
                break;
            }
            if (c != '\r') {
                sb.append((char) c);
            }
            if (sb.length() > 8192) {
                break;
            }
        }
        if (c == -1 && sb.length() == 0) {
            return null;
        }
        return sb.toString();
    }

    static final class Acceptor implements Runnable {
        private final SubServer server;

        Acceptor(SubServer server) {
            this.server = server;
        }

        @Override
        public void run() {
            while (server.running) {
                try {
                    Socket c = server.socket.accept();
                    Thread t = new Thread(new Conn(server, c), "friends-subserver-conn");
                    t.setDaemon(true);
                    t.start();
                } catch (IOException e) {
                    if (server.socket.isClosed()) {
                        server.running = false;
                    }
                }
            }
        }
    }

    static final class Conn implements Runnable {
        private final SubServer server;
        private final Socket socket;

        Conn(SubServer server, Socket socket) {
            this.server = server;
            this.socket = socket;
        }

        @Override
        public void run() {
            server.handle(socket);
        }
    }
}
