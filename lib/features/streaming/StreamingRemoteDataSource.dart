import 'dart:convert';
import 'dart:io'; 
import 'package:bevicschurch/utils/apiBodyParameterLabels.dart';
import 'package:bevicschurch/utils/apiUtils.dart';
import 'package:bevicschurch/utils/constants.dart';
import 'package:bevicschurch/utils/errorMessageKeys.dart';
import 'package:http/http.dart' as http;

import 'StreamingException.dart';

class StreamingRemoteDataSource {
     
  
  
   Future<List> fetchStreamingCategory({required String userId}) async {
    try {
      Map<String, String> body = {
        accessValueKey: accessValue,
        userIdKey: userId
      };
 
      final response = await http.post(Uri.parse(getStreamingList),
          body: body, headers: await ApiUtils.getHeaders());

      final responseJson = jsonDecode(response.body);
       

      if (responseJson['error']) { 
        throw StreamingException(errorMessageCode: responseJson['message']); //error
      } 
      print(responseJson['data']);
      return responseJson['data'];
    } on SocketException catch (_) {
      throw StreamingException(errorMessageCode: noInternetCode);
    } on StreamingException catch (e) {
      throw StreamingException(errorMessageCode: e.toString());
    } catch (e) {
      throw StreamingException(errorMessageCode: defaultErrorMessageCode);
    }
  } 
}