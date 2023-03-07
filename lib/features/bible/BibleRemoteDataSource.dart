import 'dart:convert';
import 'dart:io'; 
import 'package:bevicschurch/utils/apiBodyParameterLabels.dart';
import 'package:bevicschurch/utils/apiUtils.dart';
import 'package:bevicschurch/utils/constants.dart';
import 'package:bevicschurch/utils/errorMessageKeys.dart';
import 'package:http/http.dart' as http;

import 'BibleException.dart';
 
 

class BibleRemoteDataSource {

  Future<List> fetchbible({required String userId}) async {
    try {
      Map<String, String> body = {
        accessValueKey: accessValue,
        userIdKey: userId
      };
  
      final response = await http.post(Uri.parse(getEventList),
          body: body, headers: await ApiUtils.getHeaders());

      final responseJson = jsonDecode(response.body);
       

      if (responseJson['error']) { 
        throw BibleException(errorMessageCode: responseJson['message']); //error
      }  
      return responseJson['data'];
    } on SocketException catch (_) {
      throw BibleException(errorMessageCode: noInternetCode);
    } on BibleException catch (e) {
      throw BibleException(errorMessageCode: e.toString());
    } catch (e) {
      throw BibleException(errorMessageCode: defaultErrorMessageCode);
    }
  } 


     
   Future<List> fetchbibleVerse({required String userId}) async {
    try {
      Map<String, String> body = {
        accessValueKey: accessValue,
        userIdKey: userId
      };
  
      final response = await http.post(Uri.parse(getBibleVerse),
          body: body, headers: await ApiUtils.getHeaders());

      final responseJson = jsonDecode(response.body);
       

      if (responseJson['error']) { 
        throw BibleException(errorMessageCode: responseJson['message']); //error
      }  
      
      return responseJson['data'];
    } on SocketException catch (_) {
      throw BibleException(errorMessageCode: noInternetCode);
    } on BibleException catch (e) {
      throw BibleException(errorMessageCode: e.toString());
    } catch (e) {
      throw BibleException(errorMessageCode: defaultErrorMessageCode);
    }
  } 

  Future fetchBibledownloadFile({required String userId, required String bibleSource, required var filePath}) async {
    try {
      Map<String, String> body = {
        accessValueKey: accessValue,
        userIdKey: userId,
        bibleSources: bibleSource,
        filePaths: filePath,
      };
     print(body);
      final response = await http.post(Uri.parse(getEventList),
          body: body, headers: await ApiUtils.getHeaders());

      final responseJson = jsonDecode(response.body);
       

      if (responseJson['error']) { 
        throw BibleException(errorMessageCode: responseJson['message']); //error
      }  
      print(responseJson['data']);
      return responseJson['data'];

    } on SocketException catch (_) {
      throw BibleException(errorMessageCode: noInternetCode);
    } on BibleException catch (e) {
      throw BibleException(errorMessageCode: e.toString());
    } catch (e) {
      throw BibleException(errorMessageCode: defaultErrorMessageCode);
    }
  } 
}