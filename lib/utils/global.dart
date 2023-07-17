import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

Locale? locale;
final globalLogger = Logger();
GlobalKey<NavigatorState>? navigatorKey;
GlobalKey<ScaffoldMessengerState>? snackbarKey;
bool isNoNetworkProblem = false;
bool is401Call = false;
bool is500Call = false;
void onInternet({Function()? onRetry}) {
  snackbarKey!.currentState?.showSnackBar(
    SnackBar(
      dismissDirection: DismissDirection.down,
      duration: const Duration(minutes: 5),
      content: const Text('Your Device has no internet connection!', style: TextStyle(color:Colors.red),),
      backgroundColor:Colors.black,
      action: SnackBarAction(
        label: 'Retry',
        textColor: Colors.blue,
        onPressed: () {
          snackbarKey!.currentState?.removeCurrentSnackBar();
          is500Call = false;
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
  DismissDirection? dismissDirection,
  Duration? duration,
}) {
  globalLogger.d("jj");
  snackbarKey!.currentState?.showSnackBar(
    SnackBar(
      duration: duration?? const Duration(seconds: 4) ,

      dismissDirection:dismissDirection?? DismissDirection.down,
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
