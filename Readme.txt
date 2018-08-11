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
