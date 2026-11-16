package com.google.android.gms.common.api;
public interface ResultCallback<T extends Result> {
  void onResult(T r);
}
