import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tlm/src/utils/constants/color_constants.dart';
import 'package:tlm/src/utils/dialog_utils.dart';
import 'package:tlm/src/utils/sharedpreference/shared_preferences_keys.dart';
import 'res_base_model.dart';

Map<String, dynamic> optHeader = {'content-type': 'application/json'};

HttpUtils httpUtils = HttpUtils();

String apiBaseUrl = "https://api.tlm.northstar.edu.in/api";

//Base api call get, put, delete, post.
class HttpUtils {
  static final HttpUtils _singleton = HttpUtils._internal();

  factory HttpUtils() => _singleton;


  bool is401Error = false;
  bool isPoorNetworkDialogShown = false;
  late Dio _dio;

  HttpUtils._internal() {
    // if (null == _dio) {
      final baseOption = BaseOptions(
        connectTimeout: 10 * 1000,
        receiveTimeout: 10 * 1000,
        baseUrl: apiBaseUrl,
        contentType: 'application/json',
        headers: {
          'authorization': '${getUserToken()}',
        },
      );

      _dio = Dio(baseOption);
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };
      final mInterceptorsWrapper = InterceptorsWrapper(
        onRequest: (options, handler) async {
          print("HEADERS: ${options.headers.toString()}");
          debugPrint("BASE_URL: ${options.baseUrl.toString() + options.path}",
              wrapWidth: 1024);
          debugPrint("BODY: ${options.data.toString()}", wrapWidth: 1024);
          return handler.next(options);
        },
        onResponse: (response, handler) async {
          debugPrint(
              "RESPONSE: ${response.requestOptions.path} ${response.toString()}",
              wrapWidth: 1024);

          return handler.next(response);
        },
        onError: (e, handler) async {
          debugPrint("ERROR: ${e.requestOptions.baseUrl} ${e.error.toString()}",
              wrapWidth: 1024);
          debugPrint("ERROR: ${e.response.toString()}", wrapWidth: 1024);
          return handler.next(e);
        },
      );
      _dio.interceptors.add(mInterceptorsWrapper);
    // }
  }

  Future get(String url,
      {Map<String, dynamic>? params,
      bool isAddLoading = false,
      required BuildContext context,
      String token = "",
      }) async {
    Response response;
    final baseOption = BaseOptions(
      connectTimeout: 30 * 1000,
      receiveTimeout: 30 * 1000,
      baseUrl: apiBaseUrl,
      contentType: 'application/json',
      headers: {
        'authorization':
            token != "" ? '$token' : '${getUserToken()}',
      },
    );


    _dio.options = baseOption;

    var documentsDir = await getApplicationDocumentsDirectory();
    var documentsPath = documentsDir.path;
    var dir = Directory("$documentsPath/cookies");
    await dir.create();

    // loading
    if (isAddLoading) {
      showLoading(context);
    }

    try {
      if (params != null) {
        response = await _dio.get(url, queryParameters: params);
      } else {
        response = await _dio.get(url);
      }
      disMissLoadingDialog(isAddLoading, context);
      debugPrint("RL>>>>>>>>>>>>> : $url");
      return response;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      disMissLoadingDialog(isAddLoading, context);

      if (e.response != null) {
        debugPrint("ERROR: ${e.response} $url");
        if ((e.response?.statusCode == 401 || e.response?.statusCode == 403) &&
            getUserToken() != null &&
            getUserToken() != "") {
          is401Error = true;
          var resBaseModel =
              ResBaseModel.fromJson(jsonDecode(e.response.toString()));
          apiFailTokenExpireCase(context, resBaseModel);
        } else {
          return e.response;
        }
      } else {
        if (!isPoorNetworkDialogShown) {
          isPoorNetworkDialogShown = true;
          DialogUtils.showAlertDialogCustom(
            context,
            "Poor internet connection.\nThis may take a moment to load.",
            onPressedCallBack: () {
              isPoorNetworkDialogShown = false;
            },
          );
        }
      }
      return null;
    }
  }

  Future put(String url,
      {Map<String, dynamic>? params,
      Map<String, dynamic>? data,
      bool isAddLoading = false,
      required BuildContext context,
      }) async {
    Response response;
    final baseOption = BaseOptions(
      connectTimeout: 10 * 1000,
      receiveTimeout: 10 * 1000,
      baseUrl: apiBaseUrl,
      contentType: 'application/json',
      headers: {
        'authorization': '${getUserToken()}',
      },
    );

    _dio.options = baseOption;

    var documentsDir = await getApplicationDocumentsDirectory();
    var documentsPath = documentsDir.path;
    var dir = Directory("$documentsPath/cookies");
    await dir.create();

    // loading
    if (isAddLoading) {
      showLoading(context);
    }

    try {
      if (params != null || data != null) {
        // response = await _dio.put(url, queryParameters: params);
        response = await _dio.put(url, data: data, queryParameters: params);
      } else {
        response = await _dio.put(url);
      }
      disMissLoadingDialog(isAddLoading, context);
      debugPrint("RL : $url");
      return response;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      disMissLoadingDialog(isAddLoading, context);

      if (e.response != null) {
        debugPrint("ERROR: ${e.response}");
        if ((e.response?.statusCode == 401 || e.response?.statusCode == 403) &&
            getUserToken() != null &&
            getUserToken() != "") {
          is401Error = true;
          var resBaseModel =
              ResBaseModel.fromJson(jsonDecode(e.response.toString()));
          apiFailTokenExpireCase(context, resBaseModel);
        } else {
          return e.response;
        }
      } else {
        if (!isPoorNetworkDialogShown) {
          isPoorNetworkDialogShown = true;
          DialogUtils.showAlertDialogCustom(
            context,
            "Poor internet connection.\nThis may take a moment to load.",
            onPressedCallBack: () {
              isPoorNetworkDialogShown = false;
            },
          );
        }
      }
      return null;
    }
  }

  // url ：
  // formData :
  // post
  Future post(String url,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParam,
      bool isAddLoading = false,
      String stationToken = "",
      int timeOut = 10,
      required BuildContext context,
      CancelToken? cancelToken}) async {
    if (cancelToken == null) {
      cancelToken = CancelToken();
    }
    Response response;
    var documentsDir = await getApplicationDocumentsDirectory();
    var documentsPath = documentsDir.path;
    var dir = Directory("$documentsPath/cookies");
    await dir.create();
    debugPrint("RL : $url");
    // loading
    if (isAddLoading) {
      showLoading(context);
    }

    final baseOption = BaseOptions(
      connectTimeout: timeOut * 1000,
      receiveTimeout: timeOut * 1000,
      baseUrl: apiBaseUrl,
      contentType: 'application/json',
      headers: {
        'authorization': stationToken != ""
            ? '$stationToken'
            : '${getUserToken()}',
      },
    );

    _dio.options = baseOption;

    try {
      if (queryParam != null || data != null) {
        response = await _dio.post(url,
            data: data, queryParameters: queryParam, cancelToken: cancelToken);
      } else {
        response = await _dio.post(url, cancelToken: cancelToken);
      }

      disMissLoadingDialog(isAddLoading, context);
      return response;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      disMissLoadingDialog(isAddLoading, context);

      if (e.response != null) {
        debugPrint("ERROR: ${e.response}");
        if ((e.response?.statusCode == 401 || e.response?.statusCode == 403) &&
            getUserToken() != null &&
            getUserToken() != "") {
          is401Error = true;
          var resBaseModel =
              ResBaseModel.fromJson(jsonDecode(e.response.toString()));
          apiFailTokenExpireCase(context, resBaseModel);
        } else {
          return e.response;
        }
      } else {
        if (e.error.toString() != "cancelledAPICall") {
          if (!isPoorNetworkDialogShown) {
            isPoorNetworkDialogShown = true;
            DialogUtils.showAlertDialogCustom(
              context,
              "Poor internet connection.\nThis may take a moment to load.",
              onPressedCallBack: () {
                isPoorNetworkDialogShown = false;
              },
            );
          }
        }
      }
      return null;
    }
  }

  void disMissLoadingDialog(bool isAddLoading, BuildContext context) {
    if (isAddLoading) {
      Navigator.of(context).pop();
    }
  }

  void apiFailTokenExpireCase(BuildContext context, ResBaseModel resBaseModel) {
    if (is401Error) {
      print("Dialog try to open ==== ${resBaseModel.statusCode}");

      DialogUtils.showAlertDialogCustom(
          context,
          (resBaseModel.message != null && resBaseModel.message != "")
              ? "${resBaseModel.message}"
              : "Something went wrong, please try again!", onPressedCallBack: () {
        if (resBaseModel.statusCode == 403) {

        } else {
          print("inside else  part ===== ");
          is401Error = false;
          clearAllLogoutPreferences();

        }
      });
    }
  }

  /// Loading
  void showLoading(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return const Center(child: CircularProgressIndicator(color: primaryButtonColor));
        });
  }

  Future postFormDataMultipart(String url,
      {FormData? data,
      bool isAddLoading = false,
      required BuildContext context,
      }) async {
    Response response;
    var documentsDir = await getApplicationDocumentsDirectory();
    var documentsPath = documentsDir.path;
    var dir = Directory("$documentsPath/cookies");
    await dir.create();
    debugPrint("RL : $url");
    // loading
    if (isAddLoading) {
      showLoading(context);
    }

    final baseOption = BaseOptions(
      connectTimeout: 10 * 1000,
      receiveTimeout: 10 * 1000,
      baseUrl: apiBaseUrl,
      contentType: 'application/json',
      headers: {
        'authorization': '${getUserToken()}',
      },
    );

    _dio.options = baseOption;

    try {
      if (data != null) {
        response = await _dio.post(url, data: data);
      } else {
        response = await _dio.post(url);
      }

      disMissLoadingDialog(isAddLoading, context);
      return response;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      disMissLoadingDialog(isAddLoading, context);

      if (e.response != null) {
        debugPrint("ERROR: ${e.response}");
        return e.response;
      } else {
        if (!isPoorNetworkDialogShown) {
          isPoorNetworkDialogShown = true;
          DialogUtils.showAlertDialogCustom(
            context,
            "Poor internet connection.\nThis may take a moment to load.",
            onPressedCallBack: () {
              isPoorNetworkDialogShown = false;
            },
          );
        }
      }
      return null;
    }
  }

  Future delete(String url,
      {Map<String, dynamic>? params,
      bool isAddLoading = false,
      required BuildContext context,
      }) async {
    Response response;
    final baseOption = BaseOptions(
      connectTimeout: 10 * 1000,
      receiveTimeout: 10 * 1000,
      baseUrl: apiBaseUrl,
      contentType: 'application/json',
      headers: {
        'authorization': '${getUserToken()}',
      },
    );

    _dio.options = baseOption;

    var documentsDir = await getApplicationDocumentsDirectory();
    var documentsPath = documentsDir.path;
    var dir = Directory("$documentsPath/cookies");
    await dir.create();

    // loading
    if (isAddLoading) {
      showLoading(context);
    }

    try {
      if (params != null) {
        response = await _dio.delete(url, queryParameters: params);
      } else {
        response = await _dio.delete(url);
      }
      disMissLoadingDialog(isAddLoading, context);
      debugPrint("RL : $url");
      return response;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      disMissLoadingDialog(isAddLoading, context);

      if (e.response != null) {
        debugPrint("ERROR: ${e.response}");
        if ((e.response?.statusCode == 401 || e.response?.statusCode == 403) &&
            getUserToken() != null &&
            getUserToken() != "") {
          is401Error = true;
          var resBaseModel =
              ResBaseModel.fromJson(jsonDecode(e.response.toString()));
          apiFailTokenExpireCase(context, resBaseModel);
        } else {
          return e.response;
        }
      } else {
        if (!isPoorNetworkDialogShown) {
          isPoorNetworkDialogShown = true;
          DialogUtils.showAlertDialogCustom(
            context,
            "Poor internet connection.\nThis may take a moment to load.",
            onPressedCallBack: () {
              isPoorNetworkDialogShown = false;
            },
          );
        }
      }
      return null;
    }
  }
}