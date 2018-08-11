package com.example.gdgsbymeetup;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import com.facebook.FacebookSdk;
import com.facebook.appevents.AppEventsLogger;;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    FacebookSdk.sdkInitialize(getApplicationContext());
    AppEventsLogger.activateApp(this);    
    GeneratedPluginRegistrant.registerWith(this);
  }
}
