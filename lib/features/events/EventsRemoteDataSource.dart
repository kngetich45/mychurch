import 'dart:convert';
import 'dart:io'; 
import 'package:bevicschurch/utils/apiBodyParameterLabels.dart';
import 'package:bevicschurch/utils/apiUtils.dart';
import 'package:bevicschurch/utils/constants.dart';
import 'package:bevicschurch/utils/errorMessageKeys.dart';
import 'package:http/http.dart' as http;

import 'EventsException.dart';
 

class EventsRemoteDataSource {
     
   Future<List> fetchItems({required String eventDate, required String userId}) async {
    try {
      Map<String, String> body = {
        accessValueKey: accessValue,
        userIdKey: userId, 
        eventsDate: eventDate
      };
  print(body);
      final response = await http.post(Uri.parse(getEventList),
          body: body, headers: await ApiUtils.getHeaders());

      final responseJson = jsonDecode(response.body);
       

      if (responseJson['error']) { 
        throw EventsException(errorMessageCode: responseJson['message']); //error
      }  
      return responseJson['data'];
    } on SocketException catch (_) {
      throw EventsException(errorMessageCode: noInternetCode);
    } on EventsException catch (e) {
      throw EventsException(errorMessageCode: e.toString());
    } catch (e) {
      throw EventsException(errorMessageCode: defaultErrorMessageCode);
    }
  } 
   
}