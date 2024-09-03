//package com.example.my_app;
//
//import android.app.PictureInPictureParams;
//import android.os.Build;
//import android.util.Rational;
//import android.widget.Toast;
//
//import androidx.annotation.NonNull;
//
//import io.flutter.embedding.android.FlutterActivity;
//import io.flutter.embedding.engine.FlutterEngine;
//import io.flutter.plugin.common.MethodChannel;
//
//
//public class MainActivity extends FlutterActivity {
//
//    // 定义与Flutter端一致的方法通道名称
//    private static final String CHANNEL = "com.example.my_app/pip";
//
//    @Override
//    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
//        super.configureFlutterEngine(flutterEngine);
//        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
//                .setMethodCallHandler(
//                        (call, result) -> {
//                            if (call.method.equals("enterPipMode")) {
//                                enterPipMode();
//                                result.success(null);
//                            } else {
//                                result.notImplemented();
//                            }
//                        }
//                );
//    }
//
//    private void enterPipMode() {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            Rational aspectRatio = new Rational(16, 9);  // 设置画中画模式的宽高比
//            PictureInPictureParams.Builder pipBuilder = new PictureInPictureParams.Builder();
//            pipBuilder.setAspectRatio(aspectRatio);
//            enterPictureInPictureMode(pipBuilder.build());
//
//        } else {
//            Toast.makeText(this, "PiP mode is not supported below Android 8.0", Toast.LENGTH_SHORT).show();
//        }
//    }
//
//
//}

package com.example.my_app;

import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import org.fourthline.cling.UpnpService;
import org.fourthline.cling.UpnpServiceImpl;
import org.fourthline.cling.model.message.header.STAllHeader;
import org.fourthline.cling.model.meta.Device;
import org.fourthline.cling.model.meta.Service;
import org.fourthline.cling.model.types.UDAServiceType;
import org.fourthline.cling.support.avtransport.callback.SetAVTransportURI;
import org.fourthline.cling.support.model.ProtocolInfo;
import org.fourthline.cling.support.model.Res;
import org.fourthline.cling.support.model.item.Item;
import org.fourthline.cling.support.model.item.VideoItem;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "com.example.my_app/dlna";
    private UpnpService upnpService;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                        if (call.method.equals("startDlnaCasting")) {
                            String url = call.argument("url");
                            startDlnaCasting(url);
                            result.success(null);
                        } else {
                            result.notImplemented();
                        }
                    }
                });
    }

    private void startDlnaCasting(String url) {
        if (upnpService == null) {
            upnpService = new UpnpServiceImpl();
        }

        // 设备搜索和选择
        upnpService.getControlPoint().search(new STAllHeader());

        // 需要实现服务监听器和设备选择逻辑
        // 假设已经选择了设备 device
        Device device = ...;

        Service avTransportService = device.findService(new UDAServiceType("AVTransport"));

        // 使用URL进行播放
        if (avTransportService != null) {
            upnpService.getControlPoint().execute(
                    new SetAVTransportURI(avTransportService, url) {
                        @Override
                        public void success(ActionInvocation invocation) {
                            Log.d("DLNA", "Started playing on device");
                        }

                        @Override
                        public void failure(ActionInvocation invocation, UpnpResponse operation, String defaultMsg) {
                            Log.e("DLNA", "Failed to start playing: " + defaultMsg);
                        }
                    }
            );
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (upnpService != null) {
            upnpService.shutdown();
        }
    }
}

