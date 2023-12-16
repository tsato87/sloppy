import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sloppy/const/strings.dart';
import 'package:sloppy/services/routing/route_navigator.dart';

Future<bool?> showAlertDialog({
  required BuildContext context,
  String? title,
  required String content,
  required RouteNavigator navigator,
  String defaultActionText = Strings.ok,
  String? cancelActionText,
}) async {
  if (kIsWeb || !Platform.isIOS) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: title != null ? Text(title) : null,
        content: Text(content),
        actions: <Widget>[
          if (cancelActionText != null)
            TextButton(
              child: Text(cancelActionText),
              onPressed: () => navigator.pop(false),
            ),
          TextButton(
            child: Text(defaultActionText),
            onPressed: () => navigator.pop(true),
          ),
        ],
      ),
    );
  }
  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: title != null ? Text(title) : null,
      content: Text(content),
      actions: <Widget>[
        if (cancelActionText != null)
          CupertinoDialogAction(
            child: Text(cancelActionText),
            onPressed: () => navigator.pop(false),
          ),
        CupertinoDialogAction(
          child: Text(defaultActionText),
          onPressed: () => navigator.pop(true),
        ),
      ],
    ),
  );
}
