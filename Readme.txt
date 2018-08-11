0. Sheets user
1. export json
2. import in firebase

1. flutter create submeetup
2. buka folder di visual studio/android studio
3. Ganti judul
4. add tab bar
https://flutter.io/cookbook/design/tabs/
5. pastikan
        appBar: AppBar(
          title: new Text(widget.title),

6. change floating action button
7. add qr scanner
  barcode_scan: ^0.0.4
https://pub.dartlang.org/packages/barcode_scan#-readme-tab-
8. flutter packages get in terminal
9. import qr package
import 'package:barcode_scan/barcode_scan.dart';
10. make changes in android code
<uses-permission android:name="android.permission.CAMERA" />
<activity android:name="com.apptreesoftware.barcodescan.BarcodeScannerActivity"/>



Firebase UI Auth
1. 
https://pub.dartlang.org/packages/flutter_firebase_ui
2.
https://pub.dartlang.org/packages/firebase_auth
3. change package name
4. create android app in firebase
5. download json
6. create facebook app
https://developers.facebook.com/apps
import com.facebook.FacebookSdk;
import com.facebook.appevents.AppEventsLogger;
7. create strings.xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="facebook_app_id">xyz</string>
    <string name="fb_login_protocol_scheme">fbxyz</string>
</resources>



6. create list_attendees.dart
pake List
7.

6. create dashboard_page.dart
7. import in main.dart
8. add 
  charts_flutter: ^0.4.0
flutter packages get
https://pub.dartlang.org/packages/charts_flutter#-installing-tab-
9.
import 'package:charts_flutter/flutter.dart';
