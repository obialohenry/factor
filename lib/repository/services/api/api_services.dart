import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:factor/src/config.dart';
import 'package:factor/src/repository.dart';

class ApiServices extends ApiConstants {
  final dio = Dio();

  /// Sends a `GET` request using [dio.get].
  ///
  /// Parameters:
  /// - [uri]: The request URL.
  /// - [header]: Optional request headers.
  ///
  /// A timeout of 30 seconds is applied.
  /// Catches and handles [DioException] and [TimeoutException].
  /// Returns the response as a Dart object or throws a custom exception on error.
  Future<dynamic> get({required Uri uri, Map<String, String>? header}) async {
    print('👀 Making request to $uri');
    final options = Options(headers: header, responseType: ResponseType.json);
    try {
      Response response;
      response = await dio.get(uri.toString(), options: options).timeout(Duration(seconds: 30));
      return _dioResponse(response);
    } on DioException catch (error, s) {
      if (error.response != null) {
        print('👀 ${error.response!.statusCode}');
        print('👀 ${error.response!.data}');
      } else {
        print('👀 ${FactorStrings.errNoResponseReceived}: $error');
      }
    } on TimeoutException {
      throw RequestTimeoutException(FactorStrings.errServerConnectionTimeOut.toUpperCase());
    } catch (e, s) {
      print('👀 $s');
      throw HttpException("${FactorStrings.errSomethingWentWrong}, $e");
    }
  }

  /// Sends a `POST` request using [dio.post].
  ///
  /// Parameters:
  /// - [uri]: The request URL.
  /// - [header]: Optional request headers.
  /// - [body]: The request payload as a JSON-Encoded map.
  ///
  /// A timeout of 30 seconds is applied.
  /// Catches and handles [DioException] and [TimeoutException].
  /// Returns the response as a Dart object or throws a custom exception on error.
  Future<dynamic> post({
    required Uri uri,
    Map<String, String>? header,
    required Map<String, dynamic> body,
  }) async {
    print('👀 Making request to $uri');
    print('👀 $body');
    final options = Options(headers: header, responseType: ResponseType.json);
    try {
      Response response;
      response = await dio
          .post(uri.toString(), data: jsonEncode(body), options: options)
          .timeout(Duration(seconds: 30));
      return _dioResponse(response);
    } on DioException catch (error, s) {
      if (error.response != null) {
        print('👀 ${error.response!.statusCode}');
        print('👀 ${error.response!.data}');
      } else {
        print('👀 ${FactorStrings.errNoResponseReceived}: $error');
      }
    } on TimeoutException {
      throw RequestTimeoutException(FactorStrings.errServerConnectionTimeOut.toUpperCase());
    } catch (e, s) {
      print('👀 $s');
      throw HttpException("${FactorStrings.errSomethingWentWrong}, $e");
    }
  }

  /// Logs the response status code and body to the console.
  void _logResponse(Response response) {
    print("🔥RESPONSE STATUS CODE: ${response.statusCode}");
    print("🔥RESPONSE DATA: ${response.data}");
  }

  /// Handles the API response returned from [dio].
  ///
  /// - Logs the status code and body using [_logResponse].
  /// - Returns the response data for success codes (200, 201).
  /// - Throws a specific exception based on the status code (e.g., [BadRequestException], [UnauthorisedException], [InternalServerException]).
  /// - Throws [UnknownApiException] for unhandled status codes.
  dynamic _dioResponse(Response response) async {
    switch (response.statusCode) {
      case 200:

        ///* This is a catch block for when the server returns a 200 ok status.
        _logResponse(response);
        return response.data;
      case 201:

        ///* This is a catch block for when the server returns a 201 created status.
        _logResponse(response);
        return response.data;
      case 400:

        ///* This is a catch block for when the server returns a 400 bad request status.
        _logResponse(response);
        throw BadRequestException(response.data.toString());
      case 401:

        ///* This is a catch block for when the server returns a 401 unauthorised error.
        _logResponse(response);
        throw ForbiddenRequestException(response.data.toString());
      case 403:

        ///* This is a catch block for when the server returns a 403 access unauthorised error.
        _logResponse(response);
        throw ForbiddenRequestException(response.data.toString());
      case 408:

        ///* This is a catch block for when the server returns a 408 timeout error.
        _logResponse(response);
        throw Exception(response.data.toString());
      case 409:

        ///* This is a catch block for when the server returns a 409.
        _logResponse(response);
        throw BadRequestException(response.data.toString());
      case 500:

        ///* This is a catch block for when the server returns a 500 error.
        _logResponse(response);
        throw InternalServerException(FactorStrings.errErrorWhileCommunicatingWithServer);
      default:
        throw UnknownApiException(
          '${FactorStrings.msgUnhandledStatusCode}: ${response.statusCode}',
        );
    }
  }
}
