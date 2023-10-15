import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

Locale? locale;
final globalLogger = Logger();
GlobalKey<NavigatorState>? navigatorKey;
GlobalKey<ScaffoldMessengerState>? snackbarKey;
bool isNoNetworkProblem = false;
bool is401Call = false;
bool isNoInternetCall = false;
bool is500Call = false;
int snackBarDurationInSec = 4;
void onInternet({Function()? onRetry}) {
  snackbarKey!.currentState?.showSnackBar(
    SnackBar(
      dismissDirection: DismissDirection.down,
      duration: const Duration(seconds: 2),
      content: const Text(
        'Your Device has no internet connection!',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      action: SnackBarAction(
        label: 'Retry',
        textColor: Colors.blue,
        onPressed: () {
          snackbarKey!.currentState?.removeCurrentSnackBar();
          isNoInternetCall = false;
          if (onRetry != null) {
            onRetry;
          }
        },
      ),
    ),
  );
}

@Deprecated('Use [callBack401Func]')
Future<void> Function()? callBack404Func;
Future<void> Function()? callBack401Func;

showSnackBar({
  required String msg,
  String? actionLabel,
  Function()? actionPressed,
  Color? bgColor,
  Color? msgColor,
  Color? actionLabelColor,
  DismissDirection? dismissDirection,
  Duration? duration,
}) {
  snackbarKey!.currentState?.showSnackBar(
    SnackBar(
      duration: duration ?? Duration(seconds: snackBarDurationInSec),
      behavior: SnackBarBehavior.floating,
      dismissDirection: dismissDirection ?? DismissDirection.down,
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
