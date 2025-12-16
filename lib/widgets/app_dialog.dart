import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showCupertinoDialogBox({
  required BuildContext context,
  required String title,
  required String message,
  String? confirmText,
  String? cancelText,
  VoidCallback? onConfirm,
  VoidCallback? onCancel,
  bool barrierDismissible = true,
  bool showCancel = true,
}) async {
  return showCupertinoDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext ctx) {
      return CupertinoAlertDialog(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            message,
            style: TextStyle(fontSize: 15, color: Colors.black, height: 1.4),
          ),
        ),
        actions: [
          if (showCancel)
            CupertinoDialogAction(
              isDestructiveAction: false,
              onPressed: () {
                Navigator.pop(ctx);
                if (onCancel != null) onCancel();
              },
              child: Text(
                cancelText ?? 'إلغاء',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(ctx);
              if (onConfirm != null) onConfirm();
            },
            child: Text(
              confirmText ?? 'موافق',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}
