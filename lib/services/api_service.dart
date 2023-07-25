import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mh_core/utils/global.dart';
import 'package:mh_core/widgets/button/custom_button.dart';

enum HttpMethod { get, post, put, patch, del, multipartFilePost }

enum HttpPurpose { restAPI, webScraping }

String stringifyCookies(Map<String, String> cookies) => cookies.entries.map((e) => '${e.key}=${e.value}').join('; ');

class ServiceAPI {
  static domain(String path) => _url = path;
  static get url => _url;
  static extraSlag(String? path) => _apiUrl = _url + (path ?? '');
  static get apiUrl => _apiUrl;
  static get getCookie => _setCookie;
  static setCookie(String cookie) => _setCookie = cookie;
  static setAuthToken(String token) => _authToken = token;
  static setAuthTokenPrefix(String prefix) => _authTokenPrefix = prefix;
  static delAuthToken(_) => _authToken = '';
  static String _url = '';
  static String _apiUrl = '';
  static String _authToken = '';
  static String _setCookie = '';
  static String _authTokenPrefix = 'Bearer';
  static GlobalKey<NavigatorState>? _navigatorKey;
  static setNavigatorKey(GlobalKey<NavigatorState> key) => _navigatorKey = key;

  // static const String apiUrl = "http://pos.wiztecbd.online/api/";

  /// Multiple data add on multiple fields
  /// [allInfoField] defile as
  /// allInfoField =
  ///   {
  ///     "name": "name",
  ///     "age": 20,
  ///   };
  ///
  /// Single Image Add in request
  /// Multiple Image file add on multiple fields
  /// [imageListWithKeyValue] defile as
  /// imageListWithKeyValue = [
  ///   {
  ///     "key": "product_image",
  ///     "value": "../../../product_image.png",
  ///   },
  ///   {
  ///     "key": "product_image2",
  ///     "value": "../../../product_image2.png",
  ///   }
  /// ];
  ///
  /// Multiple Image file add on sigle field
  /// [multipleImageListWithKeyValue] defile as
  /// multipleImageListWithKeyValue = [
  ///   {
  ///     "key": "product_image",
  ///     "value":[
  ///         "../../../product_image11.png",
  ///         "../../../product_image12.png",
  ///         "../../../product_image13.png",
  ///         "../../../product_image14.png",
  ///       ],
  ///   },
  ///   {
  ///     "key": "product_image2",
  ///     "value": [
  ///         "../../../product_image21.png",
  ///         "../../../product_image22.png",
  ///         "../../../product_image23.png",
  ///         "../../../product_image24.png",
  ///       ],
  ///   }
  /// ];
  static Future<dynamic> genericCall({
    required String url,
    required HttpMethod httpMethod,
    HttpPurpose httpPurpose = HttpPurpose.restAPI,
    Map<String, String>? headers,
    Map<String, String>? allInfoField,
    List<Map<String, dynamic>>? imageListWithKeyValue,
    List<Map<String, dynamic>>? multipleImageListWithKeyValue,
    Object? body,
    Encoding? encoding,
    bool noNeedAuthToken = false,
    bool isLoadingEnable = false,
    bool isFailedResponseNeed = false,
    bool defaultErrorMsgShow = true,
    bool isErrorHandleButtonExists = false,
    bool needCookie = false,
    bool needJsonContentType = true,
    bool needJsonAccept = true,
    String? errorButtonLabel,
    String? loadingMessage,
    Function()? errorButtonPressed,
    Function()? onInternetError,
  }) async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        globalLogger.d(result.map((e) => e.toString()).toList());
        // showSnackBar(msg: 'connected');
        if (is500Call) {
          is500Call = false;
          snackbarKey!.currentState?.clearSnackBars();
        }
        if (isLoadingEnable) {
          showProgressDialog(loadingMessage);
        }
        try {
          final authHeader = {
            if (needJsonContentType) 'Content-Type': 'application/json; charset=UTF-8',
            if (needJsonAccept) 'Accept': 'application/json',
            'Authorization': '$_authTokenPrefix $_authToken',
            if (needCookie) 'Cookie': _setCookie.replaceAll(";", "; "),
          };
          globalLogger.d('$_authTokenPrefix $_authToken');
          final urlL = Uri.parse(url);
          dynamic response;
          if (httpMethod == HttpMethod.multipartFilePost) {
            var request = http.MultipartRequest("POST", urlL);
            request.headers.addAll(noNeedAuthToken ? headers ?? {} : authHeader);
            if (allInfoField != null) {
              request.fields.addAll(allInfoField);
            }

            if (imageListWithKeyValue != null) {
              for (int i = 0; i < imageListWithKeyValue.length; i++) {
                request.files.add(await http.MultipartFile.fromPath(
                    imageListWithKeyValue[i]['key'], imageListWithKeyValue[i]['value']));
              }
            }

            if (multipleImageListWithKeyValue != null) {
              for (int i = 0; i < multipleImageListWithKeyValue.length; i++) {
                if (multipleImageListWithKeyValue[i]['key'] != null) {
                  List<http.MultipartFile> files = [];
                  for (String path in multipleImageListWithKeyValue[i]['key']) {
                    var f = await http.MultipartFile.fromPath(multipleImageListWithKeyValue[i]['key'], path);
                    files.add(f);
                  }
                  request.files.addAll(files);
                  globalLogger.d(multipleImageListWithKeyValue[i]['key']);
                }
              }
            }

            final res = await request.send();
            response = await http.Response.fromStream(res);
          } else {
            response = (httpMethod == HttpMethod.get
                ? await http
                    .get(urlL, headers: noNeedAuthToken ? headers : authHeader)
                    .timeout(const Duration(seconds: 20), onTimeout: () {
                    return http.Response('Token Error', 500);
                  }).catchError((e) {
                    globalLogger.e(e.toString());
                    return http.Response('Token Error', 500);
                  })
                : httpMethod == HttpMethod.post
                    ? await http
                        .post(urlL, headers: noNeedAuthToken ? headers : authHeader, body: body, encoding: encoding)
                        .timeout(const Duration(seconds: 20), onTimeout: () {
                        return http.Response('Token Error', 500);
                      }).catchError((e) {
                        globalLogger.e(e.toString());
                        return http.Response('Token Error', 500);
                      })
                    : httpMethod == HttpMethod.put
                        ? await http
                            .put(urlL, headers: noNeedAuthToken ? headers : authHeader, body: body, encoding: encoding)
                            .timeout(const Duration(seconds: 20), onTimeout: () {
                            return http.Response('Token Error', 500);
                          }).catchError((e) {
                            globalLogger.e(e.toString());
                            return http.Response('Token Error', 500);
                          })
                        : httpMethod == HttpMethod.patch
                            ? await http
                                .patch(urlL,
                                    headers: noNeedAuthToken ? headers : authHeader, body: body, encoding: encoding)
                                .timeout(const Duration(seconds: 20), onTimeout: () {
                                return http.Response('Token Error', 500);
                              }).catchError((e) {
                                globalLogger.e(e.toString());
                                return http.Response('Token Error', 500);
                              })
                            : await http.delete(urlL,
                                headers: noNeedAuthToken ? headers : authHeader, body: body, encoding: encoding));
          }
          globalLogger.d(response.body);
          if ((response as http.Response).headers['set-cookie'] != null) {
            _setCookie = (response as http.Response)
                .headers['set-cookie']!
                .toString()
                .split(";")
                .where((e) => e.contains('csrftoken') || e.contains('sessionid'))
                .toList()
                .map((e) => e.contains('csrftoken')
                    ? e + ";"
                    : e.contains("sessionid")
                        ? e.substring(e.indexOf("sessionid"))
                        : '')
                .toList()
                .toString()
                .replaceAll("[", "")
                .replaceAll("]", "")
                .replaceAll(", ", "");
            globalLogger.d(_setCookie, "_setCookie");
          }
          globalLogger.d(response.statusCode);
          if (isLoadingEnable) {
            navigatorKey!.currentState!.pop();
          }
          if (is401Call) {
            is401Call = false;
          }

          // Get.closeAllSnackbars();
          if (response.statusCode == 200 || response.statusCode == 201) {
            if (httpPurpose == HttpPurpose.webScraping) return response.body;
            return jsonDecode(response.body);
          } else if (defaultErrorMsgShow) {
            if (response.statusCode == 400) {
              showAlert("The request was invalid!");
            } else if (response.statusCode == 401) {
              if (!is401Call) {
                is401Call = true;
                showAlert("Invalid login credentials!",
                    errorHandleButton: isErrorHandleButtonExists
                        ? CustomButton(
                            primary: Colors.red,
                            label: errorButtonLabel!,
                            onPressed: errorButtonPressed,
                            marginVertical: 8,
                          )
                        : null);
              }
            } else if (response.statusCode == 403) {
              showAlert("You do not have enough permissions to perform this action!");
            } else if (response.statusCode == 404) {
              showAlert("The requested resource not found!");
            } else if (response.statusCode == 405) {
              showAlert("This request is not supported by the resource!");
            } else if (response.statusCode == 409) {
              showAlert("The request could not be completed due to a conflict!");
            } else if (response.statusCode == 429) {
              showAlert("Server is busy now!");
            } else if (response.statusCode == 500) {
              // isErrorHandleButtonExists
              //     ?
              showAlert("The request was not completed due to an internal error on the server side!",
                  errorHandleButton: isErrorHandleButtonExists
                      ? CustomButton(
                          primary: Colors.red,
                          label: errorButtonLabel!,
                          onPressed: errorButtonPressed,
                          marginVertical: 8,
                        )
                      : null);
            } else if (response.statusCode == 503) {
              showAlert("The server was unavailable!");
            } else {
              showAlert("Something went wrong!");
            }
          }
          return jsonDecode(response.body);
        } catch (e) {
          globalLogger.e(e);
          return {};
        }
      }
    } on SocketException catch (_) {
      if (!is500Call) {
        onInternet(onRetry: onInternetError);
        is500Call = true;
      }
      // showSnackBar(msg: 'not connected');
      // print('not connected');
    }
  }

  ///Alert Dialog
  static void showAlert(String message, {Widget? errorHandleButton}) {
    showDialog(
      context: navigatorKey!.currentContext!,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
        actions: [
          CustomButton(
            label: "OK",
            marginVertical: 8,
            onPressed: () {
              navigatorKey!.currentState!.pop();
            },
          ),
          if (errorHandleButton != null) errorHandleButton,
        ],
      ),
    );
  }

  ///Alert Dialog
  static void showProgressDialog(String? msg, {Widget? errorHandleButton}) {
    showDialog(
      context: navigatorKey!.currentContext!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 20, top: 16),
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text(
          msg ?? 'Please Wait',
          textAlign: TextAlign.center,
        ),
         titlePadding: EdgeInsets.only(top: 16),
         content: const SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
