import 'dart:convert';
import 'dart:io'; 
import 'package:bevicschurch/utils/apiBodyParameterLabels.dart';
import 'package:bevicschurch/utils/apiUtils.dart';
import 'package:bevicschurch/utils/constants.dart';
import 'package:bevicschurch/utils/errorMessageKeys.dart';
import 'package:http/http.dart' as http;

import 'HymnsException.dart';

class HymnsRemoteDataSource {
     
   Future<List> fetchItems({required String userId,required int hymnsId,required String querys}) async {
    try {
      Map<String, String> body = {
        accessValueKey: accessValue,
        userIdKey: userId,
        queryData: querys, 
        hymnsIdData: hymnsId.toString(),
      };
 
      final response = await http.post(Uri.parse(getHmnsList),
          body: body, headers: await ApiUtils.getHeaders());

      final responseJson = jsonDecode(response.body);
       

      if (responseJson['error']) { 
        throw HymnsException(errorMessageCode: responseJson['message']); //error
      } 
     
      return responseJson['data'];
    } on SocketException catch (_) {
      throw HymnsException(errorMessageCode: noInternetCode);
    } on HymnsException catch (e) {
      throw HymnsException(errorMessageCode: e.toString());
    } catch (e) {
      throw HymnsException(errorMessageCode: defaultErrorMessageCode);
    }
  } 
  
   Future<List> fetchHymnsCategory({required String userId}) async {
    try {
      Map<String, String> body = {
        accessValueKey: accessValue,
        userIdKey: userId
      };
 
      final response = await http.post(Uri.parse(getHmnsCatList),
          body: body, headers: await ApiUtils.getHeaders());

      final responseJson = jsonDecode(response.body);
       

      if (responseJson['error']) { 
        throw HymnsException(errorMessageCode: responseJson['message']); //error
      } 
      print(responseJson['data']);
      return responseJson['data'];
    } on SocketException catch (_) {
      throw HymnsException(errorMessageCode: noInternetCode);
    } on HymnsException catch (e) {
      throw HymnsException(errorMessageCode: e.toString());
    } catch (e) {
      throw HymnsException(errorMessageCode: defaultErrorMessageCode);
    }
  } 
}