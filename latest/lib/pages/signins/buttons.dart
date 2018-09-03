import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomPositionedButton extends StatelessWidget {
  final Color backgroundColor, textColor;
  final String buttonText;
  final Function onTap;
  final bool isLoading;

  const BottomPositionedButton(
      {Key key,
      this.backgroundColor = CupertinoColors.activeBlue,
      this.textColor = CupertinoColors.white,
      @required this.buttonText,
      @required this.onTap,
      this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      left: 0.0,
      bottom: 0.0,
      width: MediaQuery.of(context).size.width,
      child: new FlatButton(
        onPressed: onTap,
        color: backgroundColor,
        textColor: textColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? new CupertinoActivityIndicator()
              : new Text(buttonText, style: new TextStyle(fontSize: 16.0)),
        ),
      ),
    );
  }
}
