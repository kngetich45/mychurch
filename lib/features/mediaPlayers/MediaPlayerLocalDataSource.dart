import 'dart:convert';
import 'dart:io'; 
import 'package:bevicschurch/utils/apiBodyParameterLabels.dart';
import 'package:bevicschurch/utils/apiUtils.dart';
import 'package:bevicschurch/utils/constants.dart';
import 'package:bevicschurch/utils/errorMessageKeys.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'MediaPlayerException.dart';

class MediaPlayerLocalDataSource {
   Future<void> openBox(String videoLocalsBox) async {
    if (!Hive.isBoxOpen(videoLocalsBox)) {
      await Hive.openBox<String>(videoLocalsBox);
    }
  }

  
  Future<void> addExamModuleId(String examModuleId) async {
    await Hive.box(examBox).put(examModuleId, examModuleId);
  }

  Future<void> removeExamModuleId(String examModuleId) async {
    await Hive.box(examBox).delete(examModuleId);
  }

  List<String> getAllExamModuleIds() {
    List<String> examModuleIds = [];
    //get all exam module ids
    for (var i = 0; i < Hive.box(examBox).length; i++) {
      examModuleIds.add(Hive.box(examBox).getAt(i));
    }
    print("Total pending exams are : ${examModuleIds.length}");
    return examModuleIds;
  }



  
   Future<dynamic> fetchRemoteToLocalVideos(String userId, String? userEmail) async {
    try {
      //body of post request
      final body = {
        accessValueKey: accessValue, 
        userIdKey: userId,
        userEmailKey: userEmail,
        mediaType: 'video',
        pageNo: '0',
      }; 
      final response = await http.post(Uri.parse(getmedia),
          body: body, headers: await ApiUtils.getHeaders());
      final responseJson = jsonDecode(response.body);
      if (responseJson['error']) { 
        throw MediaPlayerException(errorMessageCode: responseJson['message']);
      }  
      return responseJson['data'];
    } on SocketException catch (_) {
      throw MediaPlayerException(errorMessageCode: noInternetCode);
    } on MediaPlayerException catch (e) {
      throw MediaPlayerException(errorMessageCode: e.toString());
    } catch (e) {
      throw MediaPlayerException(errorMessageCode: defaultErrorMessageCode);
    }
  }


  
}
