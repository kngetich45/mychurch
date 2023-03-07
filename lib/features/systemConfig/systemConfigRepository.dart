import 'dart:convert';

import 'package:flutter/services.dart';

import '../../utils/errorMessageKeys.dart';
import 'model/supportedQuestionLanguage.dart';
import 'model/systemConfigModel.dart';
import 'systemConfigRemoteDataSource.dart';
import 'systemCongifException.dart'; 

class SystemConfigRepository {
  static final SystemConfigRepository _systemConfigRepository = SystemConfigRepository._internal();
  late SystemConfigRemoteDataSource _systemConfigRemoteDataSource;

  factory SystemConfigRepository() {
    _systemConfigRepository._systemConfigRemoteDataSource = SystemConfigRemoteDataSource();
    return _systemConfigRepository;
  }

  SystemConfigRepository._internal();

  Future<SystemConfigModel> getSystemConfig() async {
    try {
      final result = await _systemConfigRemoteDataSource.getSystemConfing();
      return SystemConfigModel.fromJson(Map.from(result));
    } catch (e) {
      throw SystemConfigException(errorMessageCode: e.toString());
    }
  }

  Future<List<SupportedLanguage>> getSupportedQuestionLanguages() async {
    try {
      final result = await _systemConfigRemoteDataSource.getSupportedQuestionLanguages();
      return result.map((e) => SupportedLanguage.fromJson(Map.from(e))).toList();
    } catch (e) {
      throw SystemConfigException(errorMessageCode: e.toString());
    }
  }

  Future<String> getAppSettings(String type) async {
    try {
      final result = await _systemConfigRemoteDataSource.getAppSettings(type);
      return result;
    } catch (e) {
      throw SystemConfigException(errorMessageCode: e.toString());
    }
  }

  Future<List<String>> getImagesFromFile(String fileName) async {
    try {
      final result = await rootBundle.loadString(fileName);
      final images = (jsonDecode(result) as Map)['images'] as List;
      return images.map((e) => e.toString()).toList();
    } catch (e) {
      throw SystemConfigException(errorMessageCode: defaultErrorMessageCode);
    }
  }
}
