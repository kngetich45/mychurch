import 'dart:convert';
import 'dart:io'; 
import 'package:bevicschurch/utils/apiBodyParameterLabels.dart';
import 'package:bevicschurch/utils/apiUtils.dart';
import 'package:bevicschurch/utils/constants.dart';
import 'package:bevicschurch/utils/errorMessageKeys.dart';
import 'package:http/http.dart' as http;

import 'GivingException.dart';

class GivingRemoteDataSource {
     
   Future<List> fetchItems({required String userId,required int givingId,required String querys}) async {
    try {
      Map<String, String> body = {
        accessValueKey: accessValue,
        userIdKey: userId,
        queryData: querys, 
        givingIdData: givingId.toString(),
      };
 
      final response = await http.post(Uri.parse(getGivingList),
          body: body, headers: await ApiUtils.getHeaders());

      final responseJson = jsonDecode(response.body);
       

      if (responseJson['error']) { 
        throw GivingException(errorMessageCode: responseJson['message']); //error
      } 
     
      return responseJson['data'];
    } on SocketException catch (_) {
      throw GivingException(errorMessageCode: noInternetCode);
    } on GivingException catch (e) {
      throw GivingException(errorMessageCode: e.toString());
    } catch (e) {
      throw GivingException(errorMessageCode: defaultErrorMessageCode);
    }
  } 
  
   Future<List> fetchGivingCategory({required String userId}) async {
    try {
      Map<String, String> body = {
        accessValueKey: accessValue,
        userIdKey: userId
      };
 
      final response = await http.post(Uri.parse(getGivingCatList),
          body: body, headers: await ApiUtils.getHeaders());

      final responseJson = jsonDecode(response.body);
       

      if (responseJson['error']) { 
        throw GivingException(errorMessageCode: responseJson['message']); //error
      } 
      print(responseJson['data']);
      return responseJson['data'];
    } on SocketException catch (_) {
      throw GivingException(errorMessageCode: noInternetCode);
    } on GivingException catch (e) {
      throw GivingException(errorMessageCode: e.toString());
    } catch (e) {
      throw GivingException(errorMessageCode: defaultErrorMessageCode);
    }
  } 
}