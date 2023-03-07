import 'dart:convert';
import 'dart:io'; 
import 'package:bevicschurch/utils/apiBodyParameterLabels.dart';
import 'package:bevicschurch/utils/apiUtils.dart';
import 'package:bevicschurch/utils/constants.dart';
import 'package:bevicschurch/utils/errorMessageKeys.dart';
import 'package:http/http.dart' as http;

import 'CommentsException.dart';

class CommentsRemoteDataSource {
     
   Future<List> fetchMakeComments({required String media, required String userId, String? userEmail, required String content }) async {
   /*  try {
      Map<String, String> body = {
        accessValueKey: accessValue,
        userIdKey: userId, 
        devotionalsDate:devotionalDate
      };
  
      final response = await http.post(Uri.parse(getDevotionalsList),
          body: body, headers: await ApiUtils.getHeaders());

      final responseJson = jsonDecode(response.body);
       

      if (responseJson['error']) { 
        throw CommentsException(errorMessageCode: responseJson['message']); //error
      } 
       
      return responseJson['data'];
    } on SocketException catch (_) {
      throw CommentsException(errorMessageCode: noInternetCode);
    } on CommentsException catch (e) {
      throw CommentsException(errorMessageCode: e.toString());
    } catch (e) {
      throw CommentsException(errorMessageCode: defaultErrorMessageCode);
    }
  }  */
 
   try {
      //body of post request
      final body = {
         accessValueKey: accessValue, 
        userIdKey: userId,
        userEmailKey: userEmail,
        mediaIdData: media,
       // contentData: Utility.getBase64EncodedString(content)
         contentData: content
      };
 
          final response = await http.post(Uri.parse(makecomment),
          body: body, headers: await ApiUtils.getHeaders());
          final responseJson = jsonDecode(response.body);
          if (responseJson['error']) {
            throw CommentsException(errorMessageCode: responseJson['message']);
          }
       /* print("Testing -------------------- ");
      print(responseJson['data']);
           totalPostComments = int.parse(res["total_count"]);
          setComment(Comments.fromJson(res["comment"])); */

           
 
      return responseJson['data'];
    } on SocketException catch (_) {
      throw CommentsException(errorMessageCode: noInternetCode);
    } on CommentsException catch (e) {
      throw CommentsException(errorMessageCode: e.toString());
    } catch (e) {
      throw CommentsException(errorMessageCode: defaultErrorMessageCode);
    }
   
   }



      Future<List> fetchComments({required String mediaId, required String userId, String? userEmail, required String comentsId }) async {
   
   try {
      //body of post request
      final body = {
         accessValueKey: accessValue, 
        userIdKey: userId,
        userEmailKey: userEmail,
        mediaIdData: mediaId, 
         contentData: comentsId
      };
      print(body);

        final response = await http.post(Uri.parse(getcomments),
        body: body, headers: await ApiUtils.getHeaders());
        final responseJson = jsonDecode(response.body);
        if (responseJson['error']) {
          throw CommentsException(errorMessageCode: responseJson['message']);
        } 
        print(responseJson['data']);
      return responseJson['data'];
    } on SocketException catch (_) {
      throw CommentsException(errorMessageCode: noInternetCode);
    } on CommentsException catch (e) {
      throw CommentsException(errorMessageCode: e.toString());
    } catch (e) {
      throw CommentsException(errorMessageCode: defaultErrorMessageCode);
    }
   
   }
}