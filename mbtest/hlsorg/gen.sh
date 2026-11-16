set -e
D=/home/claude/mbtest/hlsorg/files
mkdir -p $D && cd $D
for r in 720 540; do
  w=$((r*16/9/2*2))
  ffmpeg -v error -y -f lavfi -i testsrc=size=${w}x${r}:rate=25 -t 100 -c:v libx264 -pix_fmt yuv420p -g 50 -an \
   -f hls -hls_time 4 -hls_playlist_type vod -hls_segment_type fmp4 -hls_fmp4_init_filename video_${r}p_init.mp4 \
   -hls_segment_filename video_${r}p_%03d.m4s video_${r}p.m3u8
done
ffmpeg -v error -y -f lavfi -i sine=frequency=440:sample_rate=48000 -t 100 -c:a aac -b:a 96k \
  -f hls -hls_time 4 -hls_playlist_type vod -hls_segment_type fmp4 -hls_fmp4_init_filename audio_english_init.mp4 \
  -hls_segment_filename audio_english_%03d.m4s audio_english.m3u8
