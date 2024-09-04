package com.example.my_app;

import android.app.Activity;
import android.app.PictureInPictureParams;
import android.content.res.Configuration;
import android.os.Build;
import android.util.Rational;

import androidx.annotation.RequiresApi;

public class PipPlugin {

    private final Activity activity;

    public PipPlugin(Activity activity) {
        this.activity = activity;
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    public void enterPipMode() {
        Rational aspectRatio = new Rational(16, 9); // 根据视频宽高比设置
        PictureInPictureParams.Builder pipBuilder = new PictureInPictureParams.Builder();
        pipBuilder.setAspectRatio(aspectRatio);
        activity.enterPictureInPictureMode(pipBuilder.build());
    }

    public void onPictureInPictureModeChanged(boolean isInPictureInPictureMode, Configuration newConfig) {
        if (isInPictureInPictureMode) {
            // 画中画模式：隐藏UI控件
        } else {
            // 恢复正常模式：显示UI控件
        }
    }

    public void onUserLeaveHint() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            enterPipMode();
        }
    }
}