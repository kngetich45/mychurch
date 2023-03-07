import 'dart:convert';
import 'dart:io'; 
import 'package:bevicschurch/utils/apiBodyParameterLabels.dart';
import 'package:bevicschurch/utils/apiUtils.dart';
import 'package:bevicschurch/utils/constants.dart';
import 'package:bevicschurch/utils/errorMessageKeys.dart';
import 'package:http/http.dart' as http;

import 'DevotionalsException.dart';

class DevotionalsRemoteDataSource {
     
   Future<List> fetchItems({required String devotionalDate, required String userId}) async {
    try {
      Map<String, String> body = {
        accessValueKey: accessValue,
        userIdKey: userId, 
        devotionalsDate:devotionalDate
      };
  print(body);
      final response = await http.post(Uri.parse(getDevotionalsList),
          body: body, headers: await ApiUtils.getHeaders());

      final responseJson = jsonDecode(response.body);
       

      if (responseJson['error']) { 
        throw DevotionalsException(errorMessageCode: responseJson['message']); //error
      } 
       
      return responseJson['data'];
    } on SocketException catch (_) {
      throw DevotionalsException(errorMessageCode: noInternetCode);
    } on DevotionalsException catch (e) {
      throw DevotionalsException(errorMessageCode: e.toString());
    } catch (e) {
      throw DevotionalsException(errorMessageCode: defaultErrorMessageCode);
    }
  } 
   
}