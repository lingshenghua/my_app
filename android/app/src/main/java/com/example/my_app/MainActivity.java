package com.example.my_app;

import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.my_app/plugin";
    private DlnaPlugin dlnaPlugin;
    private PipPlugin pipPlugin;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // 初始化 DLNA 插件
        dlnaPlugin = new DlnaPlugin();
        dlnaPlugin.initialize(this);

        // 初始化画中画插件
        pipPlugin = new PipPlugin(this);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (dlnaPlugin != null) {
            dlnaPlugin.destroy(this);
        }
    }


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);


        // 设置通道方法处理
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    switch (call.method) {
                        case "castToDevice":
                            handleCastToDevice(call, result);
                            break;
                        case "enterPipMode":
                            handleEnterPipMode(result);
                            break;
                        default:
                            result.notImplemented();
                            break;
                    }
                });
    }


    private void handleCastToDevice(MethodCall call, MethodChannel.Result result) {
        String deviceUrl = call.argument("deviceUrl");
        String mediaUrl = call.argument("mediaUrl");
        try {
            dlnaPlugin.castToDevice(deviceUrl, mediaUrl);
            result.success(null);
        } catch (Exception e) {
            Log.e("DLNA", "Casting error: " + e.getMessage());
            result.error("CAST_ERROR", "Error occurred during casting", null);
        }
    }

    private void handleEnterPipMode(MethodChannel.Result result) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            pipPlugin.enterPipMode();
            result.success(null);
        } else {
            result.error("PIP_UNSUPPORTED", "Picture-in-Picture mode is not supported on this device", null);
        }
    }


    @Override
    public void onUserLeaveHint() {
        super.onUserLeaveHint();
    }

}

