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
