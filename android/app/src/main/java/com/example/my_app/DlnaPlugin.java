package com.example.my_app;

import android.content.Context;
import android.content.ServiceConnection;
import android.util.Log;
import android.content.ComponentName;
import android.content.Intent;
import android.os.IBinder;

import org.fourthline.cling.android.AndroidUpnpService;
import org.fourthline.cling.android.AndroidUpnpServiceImpl;
import org.fourthline.cling.model.action.ActionInvocation;
import org.fourthline.cling.model.message.UpnpResponse;
import org.fourthline.cling.model.meta.Device;
import org.fourthline.cling.model.types.UDAServiceType;
import org.fourthline.cling.support.avtransport.callback.Play;

public class DlnaPlugin {

    private AndroidUpnpService upnpService;
    private ServiceConnection serviceConnection;

    public void initialize(Context context) {
        // Bind to the UPnP service
        serviceConnection = new ServiceConnection() {
            @Override
            public void onServiceConnected(ComponentName className, IBinder service) {
                upnpService = (AndroidUpnpService) service;
            }

            @Override
            public void onServiceDisconnected(ComponentName className) {
                upnpService = null;
            }
        };

        context.bindService(new Intent(context, AndroidUpnpServiceImpl.class), serviceConnection, Context.BIND_AUTO_CREATE);
    }

    public void destroy(Context context) {
        if (serviceConnection != null) {
            context.unbindService(serviceConnection);
        }
    }

    public void castToDevice(String deviceUrl, String mediaUrl) {
        Device<?, ?, ?> device = findDeviceByUrl(deviceUrl);
        if (device != null) {
            playMedia(device, mediaUrl);
        } else {
            Log.e("DLNA", "Device not found: " + deviceUrl);
        }
    }

    private Device<?, ?, ?> findDeviceByUrl(String deviceUrl) {
        if (upnpService != null) {
            for (Device<?, ?, ?> dev : upnpService.getRegistry().getDevices()) {
                if (dev.getDetails().getFriendlyName().contains(deviceUrl)) {
                    return dev;
                }
            }
        }
        return null;
    }

    private void playMedia(Device<?, ?, ?> device, String mediaUrl) {
        if (device.findService(new UDAServiceType("AVTransport")) != null) {
            upnpService.getControlPoint().execute(new Play(device.findService(new UDAServiceType("AVTransport"))) {
                @Override
                public void success(ActionInvocation invocation) {
                    Log.i("DLNA", "Play success: " + mediaUrl);
                }

                @Override
                public void failure(ActionInvocation invocation, UpnpResponse operation, String defaultMsg) {
                    Log.e("DLNA", "Play failed: " + defaultMsg);
                }
            });
        } else {
            Log.e("DLNA", "Device has no AVTransport service");
        }
    }
}