import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

Locale? locale;
final globalLogger = Logger();
GlobalKey<NavigatorState>? navigatorKey;
GlobalKey<ScaffoldMessengerState>? snackbarKey;
bool isNoNetworkProblem = false;
bool is401Call = false;
void onInternet({Function()? onRetry}) {
  snackbarKey!.currentState?.showSnackBar(
    SnackBar(
      dismissDirection: DismissDirection.down,
      content: const Text('Your Device has no internet connection!'),
      backgroundColor: Colors.redAccent.shade200,
      action: SnackBarAction(
        label: 'Retry',
        onPressed: () {
          snackbarKey!.currentState?.removeCurrentSnackBar();

          if (onRetry != null) {
            onRetry;
          }
        },
      ),
    ),
  );
}

showSnackBar({
  required String msg,
  String? actionLabel,
  Function()? actionPressed,
  Color? bgColor,
  Color? msgColor,
  Color? actionLabelColor,
}) {
  globalLogger.d("jj");
  snackbarKey!.currentState?.showSnackBar(
    SnackBar(
      dismissDirection: DismissDirection.down,
      content: Text(
        msg,
        style: TextStyle(color: msgColor),
      ),
      backgroundColor: bgColor ?? Colors.black,
      action: SnackBarAction(
        label: actionLabel ?? 'CLOSE',
        textColor: actionLabelColor ?? Colors.blue,
        onPressed: () {
          snackbarKey!.currentState?.removeCurrentSnackBar();
          if (actionPressed != null) {
            actionPressed;
          }
        },
      ),
    ),
  );
}
