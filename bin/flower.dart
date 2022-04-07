import 'dart:math' as math;

enum ResponseCode { ok, error }

class Response {
  final ResponseCode code;
  final Map<String, dynamic> body;

  Response({required this.code, required this.body});
}

/// Emulates a remote service.
class Flower {
  final Duration delay;

  final Map<String, Map<String, dynamic>> _db;

  Flower([this.delay = const Duration(milliseconds: 250)]) : _db = {};

  /// Tries to store [json] at [path]. This succeeds with a certain probability.
  ///
  /// Response gets returned indicating wheter or not storing succeeded.
  ///
  /// On success body contains [json].
  ///
  /// On error body contains `{'details': '<error-type>'}`.
  ///
  /// Error-types:
  /// 1. `not-reachable`
  /// 2. `already-exists`
  Future<Response> set(String path, Map<String, dynamic> json) async {
    await Future.delayed(delay);

    final randomNumber = math.Random().nextInt(10);

    if (randomNumber == 0) {
      // Error not reachable
      return Response(
        code: ResponseCode.error,
        body: {'details': 'not-reachable'},
      );
    } else if (randomNumber == 1) {
      // Error already exists
      return Response(
        code: ResponseCode.error,
        body: {'details': 'already-exists'},
      );
    } else if (randomNumber == 2) {
      // Ok but empty body
      return Response(
        code: ResponseCode.ok,
        body: {},
      );
    } else {
      _db[path] = json;
      // Ok with body containing received json
      return Response(
        code: ResponseCode.ok,
        body: json,
      );
    }
  }

  /// Tries get json at [path]. This succeeds with a certain probability.
  ///
  /// Response gets returned indicating wheter or not getting succeeded.
  ///
  /// On success body contains requested ressource json.
  ///
  /// On error body contains `{'details': '<error-type>'}`.
  ///
  /// Error-types:
  /// 1. `not-found`
  Future<Response> get(String path) async {
    await Future.delayed(delay);

    final json = _db[path];
    if (json != null) {
      final randomNumber = math.Random().nextInt(10);

      if (randomNumber < 3) {
        // Ok but empty body
        return Response(
          code: ResponseCode.ok,
          body: {},
        );
      } else {
        // Ok with body containing requested json
        return Response(
          code: ResponseCode.ok,
          body: json,
        );
      }
    } else {
      // Error not found
      return Response(
        code: ResponseCode.error,
        body: {'details': 'not-found'},
      );
    }
  }

  /// Tries to call the function named [name].
  ///
  /// Response gets returned indicating wheter or not the function call succeeded.
  ///
  /// On success body contains empty json.
  ///
  /// On error body contains `{'details': '<error-type>'}`.
  ///
  /// Error-types:
  /// 1. `permission-denied`
  /// 2. `already-running`
  Future<Response> callRemoteFunction(String name) async {
    // ignore incoming name
    await Future.delayed(delay);

    final randomNumber = math.Random().nextInt(10);

    if (randomNumber == 0) {
      // Error permission denied
      return Response(
        code: ResponseCode.error,
        body: {'details': 'permission-denied'},
      );
    } else if (randomNumber == 1) {
      // Error already running
      return Response(
        code: ResponseCode.error,
        body: {'details': 'already-running'},
      );
    } else {
      // Ok with empty body
      return Response(
        code: ResponseCode.ok,
        body: {},
      );
    }
  }
}
