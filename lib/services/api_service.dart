import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:lara_g_admin/config/app_config.dart';
import 'package:lara_g_admin/enum/enum.dart';
import 'package:lara_g_admin/util/exception.dart';
import 'package:lara_g_admin/util/global.dart';
import 'package:lara_g_admin/widgets/warnings.dart';

import 'package:shared_preferences/shared_preferences.dart';

class _Basic {
  const _Basic();
}

class APIService {
  // ignore: library_private_types_in_public_api
  static const _Basic basic = _Basic();
  APIService();
  static const _defaultToken = '';
  static Future<APIResp> post(
    String path, {
    required Object? data,
    bool console = true,
    bool auth = true,
    bool showNoInternet = true,
    Duration? timeout,
    Map<String, String>? params,
    bool forceLogout = true,
  }) async {
    return await _callAPI(path,
        data: data,
        params: params,
        isPost: true,
        console: console,
        auth: auth,
        showNoInternet: showNoInternet,
        timeout: timeout,
        forceLogout: forceLogout);
  }

  static Future<APIResp> get(String path,
      {bool console = true,
      Map<String, String>? params,
      bool auth = true,
      bool showNoInternet = true,
      Duration? timeout,
      bool forceLogout = true,
      Object? data,
      CancelToken? cancelToken}) async {
    return await _callAPI(path,
        data: data,
        isPost: false,
        cancelToken: cancelToken,
        console: console,
        auth: auth,
        params: params,
        showNoInternet: showNoInternet,
        timeout: timeout,
        forceLogout: forceLogout);
  }

  static Future<APIResp> noInternetDialogue(
    String path, {
    bool isPost = false,
    Object? data,
    bool console = true,
    bool auth = true,
    bool showNoInternet = true,
    Duration? timeout,
    Map<String, String>? params,
    bool forceLogout = true,
  }) async {
    return await NoInternetScreen.show(
      AppGlobal.context,
    ).then((value) async {
      // if(value==true){
      if (isPost) {
        return await post(path,
            data: data,
            console: console,
            auth: auth,
            showNoInternet: showNoInternet,
            params: params,
            timeout: timeout,
            forceLogout: forceLogout);
      } else {
        return await get(path,
            console: console,
            auth: auth,
            showNoInternet: showNoInternet,
            params: params,
            timeout: timeout,
            forceLogout: forceLogout);
      }

      // }
    });
  }

  static Future<bool> checkConnectivity() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (!(connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi))) {
      return false;
    } else {
      bool result = await InternetConnection().hasInternetAccess;
      if (result == true) {
        return true;
      } else {
        return false;
      }
    }
  }

  static Future<bool> checkInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi))) {
      throw InternetException(type: InternetAvailabilityType.TurnOnInternet);
    }

    bool result = await InternetConnection().hasInternetAccess;
    if (result == true) {
      return true;
    } else {
      throw InternetException(type: InternetAvailabilityType.NoInternet);
    }
  }

  static Future<APIResp> _callAPI(
    String path, {
    isPost = false,
    Map<String, String>? params,
    Object? data,
    bool console = true,
    bool auth = true,
    bool showNoInternet = true,
    Duration? timeout,
    bool forceLogout = true,
    CancelToken? cancelToken,
  }) async {
    String? token;
    params ??= {};
    console = kDebugMode && console;
    if (auth == true) {
      // params[AppConstants.imei] = AppGlobal.deviceInfo?.imei ?? '';
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String? value = prefs.getString(AppConstants.token);
      // token = value;
    }
    final String urls = "${AppConfig.instance.baseUrl}$path";
    Map<String, String> urlParameters =
        Map<String, String>.from(Uri.parse(urls).queryParameters);
    urlParameters.addAll(params);
    Uri uri = Uri.parse(urls).replace(queryParameters: urlParameters);

    if (console) {
      print(urls);
      print('object--------------->');
      print(data);
      log("$uri", name: "${isPost ? "POST" : "GET"}-URL");
      log(token ?? _defaultToken,
          name: token == null ? "DEFAULT TOKEN" : "TOKEN");
      if (data != null) {
        if (data is FormData) {
          final Map map = Map.fromEntries(data.fields);
          log(jsonEncode(map), name: "DATASET");
        } else {
          log(jsonEncode(data), name: "DATASET");
        }
      }
    }
    token ??= _defaultToken;

    /// checking internet is turn on or not. it will not check internet is available or not
    final connection = await checkConnectivity();
    if (!connection) {
      return await noInternetDialogue(path,
          console: console,
          auth: auth,
          showNoInternet: showNoInternet,
          isPost: isPost,
          data: data,
          timeout: timeout,
          params: params);
    }
    try {
      final respFun = isPost
          ? Dio().post(
              uri.toString(),
              cancelToken: cancelToken,
              data: data,
              options: Options(headers: {
                'Authorization':
                    'a0eebff1e902b14e165d1ccac414ae8f37c3b4717bceefeb4a745dc411327eea',
                'Content-type': 'application/json',
                'Accept': 'application/json',
              }),
            )
          : Dio().get(
              uri.toString(),
              data: data,
              options: Options(headers: {
                'Authorization': auth ? token : "",
                'Content-type': 'application/json',
                'Accept': 'application/json',
              }),
            );
      late Response resp;
      print("svscsdcvsdc");
      if (timeout != null) {
        resp = await respFun.timeout(timeout);
      } else {
        resp = await respFun;
      }
      print(resp.statusCode);

      if (resp.statusCode == 200) {
        final data = resp.data;
        if (console) {
          log(jsonEncode(data), name: 'RESPONSE');
          print(data);
        }

        if (data is String) {
          APIResp res = APIResp.fromJson(json.decode(data));
          res = APIResp(
              statusCode: resp.statusCode,
              status: res.status,
              fullBody: res.fullBody,
              data: res.data);
          return res; //APIResp.fromJson(json.decode(data));
        } else {
          // print("sdsf");
          APIResp res = APIResp.fromJson(data);
          res = APIResp(
              statusCode: resp.statusCode,
              status: res.status,
              fullBody: res.fullBody,
              data: res.data);
          return res; //APIResp.fromJson(data);
        }
      } else {
        throw APIException(type: APIErrorType.statusCode);
      }
    } on SocketException {
      // check internet is available or not.
      if (showNoInternet) {
        return await noInternetDialogue(path,
            console: console,
            auth: auth,
            params: params,
            timeout: timeout,
            data: data,
            isPost: isPost,
            showNoInternet: showNoInternet);
      }
      throw InternetException();

      // throw InternetException(type: InternetAvailabilityType.NoInternet);
    } on FormatException {
      throw APIException(type: APIErrorType.other);
    } on TimeoutException {
      rethrow;
    } on APIException catch (e) {
      if (forceLogout && e.type == APIErrorType.auth) {
        await ExceptionHandler.showMessage(AppGlobal.context, e);
      }
      rethrow;
    } on DioException catch (e) {
      print(e.response?.data);
      if (e.response?.statusCode == 401) {
        throw APIException(
            type: APIErrorType.auth,
            message: "Invalid Login.please try again!");
      }
      if (CancelToken.isCancel(e)) {
        rethrow;
      }
      if (e.type == DioExceptionType.connectionError) {
        if (showNoInternet) {
          final result = await APIService.checkInternet();
          if (!result) {
            return await noInternetDialogue(path,
                console: console,
                auth: auth,
                showNoInternet: showNoInternet,
                isPost: isPost,
                data: data,
                timeout: timeout,
                params: params);
          } else {
            throw APIException(
                type: APIErrorType.internalServerError,
                message: e.message ?? '');
          }
        }
        throw APIException(
            type: APIErrorType.internalServerError, message: e.message ?? '');
      }

      if (e.response?.statusCode == 404) {
        throw APIException(
            type: APIErrorType.urlNotFound, message: AppGlobal.urlNotExistMsg);
        // throw APIException(type: APIErrorType.other);
      } else if (e.response?.statusCode == 500) {
        log(
            (e.response?.data?.toString().length ?? 0) > 1000
                ? e.response!.data!.toString().substring(0, 1000)
                : (e.response?.data?.toString() ?? "Unknown"),
            name: "INTERNAL SERVER ERROR");
        print(e.response!.data);
        throw APIException(
            type: APIErrorType.internalServerError,
            message: e.response?.data ?? '');
      }
      log("DIO Exception==>${e.message} ${e.type} ${e.response?.statusCode} ");
      throw APIException(type: APIErrorType.other);
    } catch (e) {
      throw APIException(
        type: APIErrorType.other,
      );
    }
  }
}

class APIResp {
  final bool status;
  final int? statusCode;
  final dynamic data;
  final dynamic fullBody;

  factory APIResp.fromJson(dynamic json) {
    return APIResp(
      status: json['success'] ?? false, // Map 'success' to 'status'
      data: json['message'] ?? json['data'], // Handle message or data
      fullBody: json,
    );
  }

  APIResp({
    this.status = false,
    this.data,
    this.fullBody,
    this.statusCode,
  });
}
