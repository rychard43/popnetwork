import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:pop_network/src/endpoint/endpoint.dart';
import 'package:pop_network/src/network.dart';

/// Responsible for managing files for requests.
class MockJsonFile {
  /// Responsible for getting the data from the file that are added to mock the features.
  static Future<dynamic> getDataFrom({
    required Endpoint endpoint,
    bool isPackage = false,
  }) async {
    var mockName = endpoint.mockName;
    if (endpoint.mockStrategy == null && mockName != null) {
      final jsonFile = await _openFileAsString(mockName, isPackage);
      return await _getData(jsonFile);
    }

    var jsonFile = endpoint.mockStrategy?.getNameJsonFile();
    if (jsonFile != null) {
      return await _getData(await _openFileAsString(jsonFile, isPackage));
    }
    return null;
  }

  static Future<String> _openFileAsString(
      String nameFile, bool isPackage) async {
    return await rootBundle.loadString(
        '${isPackage ? 'packages/' : ''}${PopNetwork.pathMocks}/$nameFile.json');
  }

  /// Responsible for getting the data from the file that are added to mock the features.
  static Future<dynamic> _getData(String jsonFile) async {
    try {
      return json.decode(jsonFile);
    } catch (_) {
      return null;
    }
  }
}
