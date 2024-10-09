package com.example.u_meng;

import io.flutter.embedding.android.FlutterActivity;

import android.os.Bundle;

import com.umeng.analytics.MobclickAgent;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        android.util.Log.i("UMLog", "onCreate@MainActivity");
    }
}

