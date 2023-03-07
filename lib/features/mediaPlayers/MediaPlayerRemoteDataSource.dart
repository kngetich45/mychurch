import 'dart:convert';
import 'dart:io'; 
import 'package:bevicschurch/utils/apiBodyParameterLabels.dart';
import 'package:bevicschurch/utils/apiUtils.dart';
import 'package:bevicschurch/utils/constants.dart';
import 'package:bevicschurch/utils/errorMessageKeys.dart';
import 'package:http/http.dart' as http;

import 'MediaPlayerException.dart';

class MediaPlayerRemoteDataSource {


  
  Future<dynamic> getDashboardCategory(String userId) async {
    try {
      //body of post request
      final body = {
        accessValueKey: accessValue, 
        userIdKey: userId,
      };
      final response = await http.post(Uri.parse(getDashboardCategoryUrl),
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


   Future<dynamic> fetchDashboardVideos(String userId, String? userEmail) async {
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
     
   Future<List> fetchAudioData(String userId, String? userEmail) async {
    try {
       
        final body = {
        accessValueKey: accessValue, 
        userIdKey: userId,
        userEmailKey: userEmail,
        mediaType: 'audio',
        pageNo: '0',
      }; 
  
      final response = await http.post(Uri.parse(getmedia),
          body: body, headers: await ApiUtils.getHeaders());

      final responseJson = jsonDecode(response.body);
       

      if (responseJson['error']) { 
        throw MediaPlayerException(errorMessageCode: responseJson['message']); //error
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

 
  Future<List> fetchVideoData(String userId, String? userEmail) async {
    try {
       
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
        throw MediaPlayerException(errorMessageCode: responseJson['message']); //error
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

     Future<List> fetchMediabyCategory({required String userId, String? userEmail, String? catId}) async {
    try {
       
        final body = {
        accessValueKey: accessValue, 
        userIdKey: userId,
        userEmailKey: userEmail,
        categoryId: catId,
        pageNo: '0',
      }; 
  
      final response = await http.post(Uri.parse(getmediabyCategoryId),
          body: body, headers: await ApiUtils.getHeaders());

      final responseJson = jsonDecode(response.body);
       

      if (responseJson['error']) { 
        throw MediaPlayerException(errorMessageCode: responseJson['message']); //error
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

   Future<List> fetchItems({required String userId, String? userEmail}) async {
    try {
       
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
        throw MediaPlayerException(errorMessageCode: responseJson['message']); //error
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
     
   Future updateViewsCount({required int? userupdate}) async {
    try {
       
        final body = {
        accessValueKey: accessValue, 
    //    userIdKey: userId,
        "updateId": userupdate,
      }; 
  
      final response = await http.post(Uri.parse(getmedia),
          body: body, headers: await ApiUtils.getHeaders());

      final responseJson = jsonDecode(response.body);
       

      if (responseJson['error']) { 
        throw MediaPlayerException(errorMessageCode: responseJson['message']); //error
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