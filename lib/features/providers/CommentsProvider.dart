import 'dart:io';

import 'package:bevicschurch/features/profileManagement/models/userProfile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/Utility.dart';
import '../../utils/Alerts.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http; 
import '../../utils/apiBodyParameterLabels.dart';
import '../../utils/apiUtils.dart';
import '../../utils/constants.dart';
import '../../utils/errorMessageKeys.dart';
import '../mediaPlayers/MediaPlayerException.dart';
import '../comments/models/CommentsModel.dart'; 
import '../../i18n/strings.g.dart';
import '../profileManagement/cubits/userDetailsCubit.dart';

class CommentsProvider with ChangeNotifier {
  List<CommentsModel> _items = [];
  bool isError = false;
  int? media = 0;
  int? totalPostComments = 0;
  UserProfile? userdata;
  bool isLoading = false;
  bool isMakingComment = false;
  bool isMakingCommentsError = false;
  bool? hasMoreComments = false;
  bool isLoadingMore = false;
  ScrollController scrollController = new ScrollController();
  final TextEditingController inputController = new TextEditingController();
  final TextEditingController editController = new TextEditingController();
  late BuildContext _context;
  

  CommentsProvider(
      BuildContext context, int? media, UserProfile? userdata, int? commentCount) {
    _context = context;
    this.media = media;
    this.userdata = userdata;
    this.totalPostComments = commentCount;
    loadComments();
  }

  bool isUser(String? email) {
    if (userdata == null) return false;
    return email == userdata!.email;
  }

  loadComments() {
    isLoading = true;
    notifyListeners();
    fetchComments();
  }

  setCommentPostDetails() {}

  List<CommentsModel> get items {
    return _items;
  }

  void setComments(List<CommentsModel> item) {
    _items.clear();
    _items = item.reversed.toList();
    if (item.length == 0)
      isError = true;
    else
      isError = false;
    isLoading = false;
    notifyListeners();
    if (items.length > 2) {
      if (scrollController.hasClients) {
        Future.delayed(Duration(milliseconds: 50), () {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        });
      }
    }
  }

  void setComment(CommentsModel item) {
    items.add(item);
    isMakingComment = false;
    inputController.clear();
    notifyListeners();
    if (items.length > 2) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  }

  void setMoreArticles(List<CommentsModel> item) {
    _items.insertAll(0, item.reversed.toList());
    isLoadingMore = false;
    notifyListeners();
  }

  /// Removes all items from the cart.
  void removeAll() {
    _items.clear();
    //notifyListeners();
  }

  Future<void> fetchComments() async {
    try {
      final response = await http.post(Uri.parse(getcomments),
          body: jsonEncode({
            "data": {"id": 0, "media": media}
          }));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        Map<String, dynamic> res = json.decode(response.body);
        hasMoreComments = res["has_more"];
        List<CommentsModel> comments = await compute(parseComments, response.body);
        setComments(comments);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setCommentsFetchError();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      setCommentsFetchError();
    }
  }

  setCommentsFetchError() {
    isError = true;
    isLoading = false;
    notifyListeners();
  }

  loadMoreComments() {
    isLoadingMore = true;
    fetchMoreComments();
    notifyListeners();
  }

  Future<void> fetchMoreComments() async {
    try {
      final response = await http.post(Uri.parse(getcomments),
          body: jsonEncode({
            "data": {"id": items[0].id, "media": media}
          }));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Map<String, dynamic> res = json.decode(response.body);
        hasMoreComments = res["has_more"];
        List<CommentsModel> articles = await compute(parseComments, response.body);
        setMoreArticles(articles);
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        loadMoreCommentsError();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      loadMoreCommentsError();
    }
  }

  loadMoreCommentsError() {
    isLoadingMore = false;
    notifyListeners();
    Alerts.showCupertinoAlert(_context, t.error, t.errorloadingmorecomments);
  }

  makeComment(String content) {
    isMakingComment = true;
    constructComment(content);
    notifyListeners();
  }

  Future<void> constructComment(String content) async {

    try {
      //body of post request
      final body = {
         accessValueKey: accessValue, 
        userIdKey: _context.read<UserDetailsCubit>().getUserId(),
        userEmailKey: _context.read<UserDetailsCubit>().getUserEmail(),
        mediaIdData: media.toString(),
       // contentData: Utility.getBase64EncodedString(content)
         contentData: content
      };

      final response = await http.post(Uri.parse(makecomment),
          body: body, headers: await ApiUtils.getHeaders());
      final responseJson = jsonDecode(response.body);
      if (responseJson['error']) {
        throw MediaPlayerException(errorMessageCode: responseJson['message']);
      }
       print("Testing -------------------- ");
      print(responseJson['data']);
      /*      totalPostComments = int.parse(res["total_count"]);
          setComment(Comments.fromJson(res["comment"])); */

          
      return responseJson['data'];
    } on SocketException catch (_) {
      throw MediaPlayerException(errorMessageCode: noInternetCode);
    } on MediaPlayerException catch (e) {
      throw MediaPlayerException(errorMessageCode: e.toString());
    } catch (e) {
      throw MediaPlayerException(errorMessageCode: defaultErrorMessageCode);
    }
    
   /*  try {
       final data = {
         accessValueKey: accessValue, 
        userIdKey: _context.read<UserDetailsCubit>().getUserId(),
        userEmailKey: _context.read<UserDetailsCubit>().getUserEmail(),
        mediaIdData: media.toString(),
       // contentData: Utility.getBase64EncodedString(content)
         contentData: content
      };
      /* var data = {
        "content": Utility.getBase64EncodedString(content),
        "email": userdata!.email,
        "media": media
      }; */
      print(data.toString());
      final response = await http.post(Uri.parse(makecomment),
         // body: jsonEncode({"data": data}));
          body: data, headers: await ApiUtils.getHeaders());
           print("commentsDat " );
             print(response);
          final responseJson = jsonDecode(response.body);
        print("comments Response " + responseJson['data']);
        print("comments message " + responseJson['message']);
        print("comments error " + responseJson['error']);
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        print("comments = " );
        print("comments = " + response.body);
        Map<String, dynamic> res = json.decode(response.body);
        print(res);
      //  String? _status = res["data"];
       /*  if (_status == "ok") {
          totalPostComments = int.parse(res["total_count"]);
          setComment(Comments.fromJson(res["comment"]));
        } else {
          makeCommentsError();
          print("one");
        } */
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        print("two");
        makeCommentsError();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      print("three");
      makeCommentsError();
    } */
  }

  makeCommentsError() {
    isMakingComment = false;
    notifyListeners();
    Alerts.showCupertinoAlert(_context, t.error, t.errormakingcomments);
  }

  Future<void> showDeleteCommentAlert(int? commentId, int position) async {
    return showDialog(
        context: _context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: new Text(t.deletecommentalert),
              content: new Text(t.deletecommentalerttext),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: Text(t.ok),
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteComment(commentId, position);
                  },
                ),
                CupertinoDialogAction(
                  isDefaultAction: false,
                  child: Text(t.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  Future<void> deleteComment(int? commentId, int position) async {
    Alerts.showProgressDialog(_context, t.deletingcomment);
    try {
      var data = {"id": commentId, "media": media};
      print(data.toString());
      final response = await http.post(Uri.parse(deletecomment),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Map<String, dynamic> res = json.decode(response.body);
        print(res);
        String? _status = res["status"];
        if (_status == "ok") {
          totalPostComments = int.parse(res["total_count"]);
          Navigator.of(_context).pop();
          items.removeAt(position);
          notifyListeners();
        } else {
          processingErrorMessage(t.errordeletingcomments);
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        processingErrorMessage(t.errordeletingcomments);
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      processingErrorMessage(t.errordeletingcomments);
    }
  }

  static List<CommentsModel> parseComments(String responseBody) {
    final res = jsonDecode(responseBody);
    final parsed = res["comments"].cast<Map<String, dynamic>>();
    return parsed.map<CommentsModel>((json) => CommentsModel.fromJson(json)).toList();
  }

  Future<void> showEditCommentAlert(int? commentId, int position) async {
    editController.text =
        Utility.getBase64DecodedString(items[position].content!);
    await showDialog<void>(
      context: _context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text(Strings.edit_comment_alert),
          content: SingleChildScrollView(
            child: TextFormField(
              controller: editController,
              maxLines: 5,
              minLines: 1,
              autofocus: true,
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text(t.cancel),
                onPressed: () {
                  Navigator.pop(context);
                }),
            TextButton(
                child: Text(t.save),
                onPressed: () {
                  String text = editController.text;
                  if (text != "") {
                    Navigator.of(context).pop();
                    editComment(commentId, text, position);
                  }
                }),
          ],
        );
      },
    );
  }

  Future<void> editComment(int? id, String content, int position) async {
    Alerts.showProgressDialog(_context, t.editingcomment);
    try {
      var encoded = Utility.getBase64EncodedString(content);
      var data = {
        "content": encoded,
        "id": id,
        "email": userdata!.email,
        "media": media
      };
      print(data.toString());
      final response = await http.post(Uri.parse(editcomment),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Map<String, dynamic> res = json.decode(response.body);
        print(res);
        String? _status = res["status"];
        if (_status == "ok") {
          Navigator.of(_context).pop();
          items[position].content = encoded;
          notifyListeners();
        } else {
          processingErrorMessage(t.erroreditingcomments);
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        processingErrorMessage(t.erroreditingcomments);
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      processingErrorMessage(t.erroreditingcomments);
    }
  }

  Future<void> reportComment(int commentId, int position, String reason) async {
    Alerts.showProgressDialog(_context, t.reportingComment);
    try {
      var data = {
        "id": commentId,
        "type": "comments",
        "reason": reason,
        "email": userdata!.email
      };
      print(data.toString());
      final response = await http.post(Uri.parse(reportcomment),
          body: jsonEncode({"data": data}));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        Map<String, dynamic> res = json.decode(response.body);
        print(res);
        String? _status = res["status"];
        if (_status == "ok") {
          totalPostComments = totalPostComments! - 1;
          Navigator.of(_context).pop();
          items.removeAt(position);
          notifyListeners();
        } else {
          processingErrorMessage(t.errorReportingComment);
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        processingErrorMessage(t.errorReportingComment);
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      processingErrorMessage(t.errorReportingComment);
    }
  }

  processingErrorMessage(String msg) {
    Navigator.of(_context).pop();
    Alerts.showCupertinoAlert(_context, t.error, msg);
  }
}
