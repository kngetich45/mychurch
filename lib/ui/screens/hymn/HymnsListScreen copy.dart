/*  
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/appLocalization.dart';
import '../../../app/routes.dart';
import '../../../features/hymns/HymnsRepository.dart';
import '../../../features/hymns/cubits/HymnsCubit.dart';
import '../../../features/models/ScreenArguements.dart';
import 'dart:async';
import 'dart:math';
import '../../../features/profileManagement/cubits/userDetailsCubit.dart';
import '../../../utils/errorMessageKeys.dart';
import '../../../utils/uiUtils.dart';
import 'BookmarkedHymnsListScreen.dart';
import 'package:provider/provider.dart';
import '../../../features/providers/HymnsBookmarksModel.dart';
import 'HymnsViewerScreen.dart';
import '../../../features/hymns/models/HymnsModel.dart';
import '../../widgets/circularProgressContainner.dart';
import '../../widgets/errorContainer.dart';
import 'NoitemScreen.dart';
import '../../../i18n/strings.g.dart';
import '../../../ui/styles/TextStyles.dart'; 
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HymnsListScreen extends StatefulWidget {
  static const routeName = "/hymnslist";

  @override
  _HymnsListScreenState createState() => _HymnsListScreenState();
      static Route<dynamic> route(RouteSettings routeSettings) { 
      return CupertinoPageRoute(
         builder: (_) => BlocProvider<HymnsCubit>(
            create: (_) => HymnsCubit(HymnsRepository()),
            child: HymnsListScreen()));
  }
}

class _HymnsListScreenState extends State<HymnsListScreen> {
  late BuildContext context;
  bool showClear = false;
  String query = "";
  final TextEditingController inputController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          maxLines: 1,
          controller: inputController,
          style: new TextStyle(fontSize: 18, color: Colors.white),
          keyboardType: TextInputType.text,
          onSubmitted: (_query) {
            setState(() {
              query = _query;
              showClear = (_query.length > 0);
            });
          },
          onChanged: (term) {
            /* setState(() {
              showClear = (term.length > 2);
            });*/
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: t.hymns,
            hintStyle: TextStyle(fontSize: 20.0, color: Colors.white70),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
           // Navigator.pop(context);
           Navigator.of(context)
                        .pushNamed(Routes.dashboard);
          },
        ),
        actions: <Widget>[
          showClear
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                  ),
                  onPressed: () {
                    inputController.clear();
                    showClear = false;
                    setState(() {
                      query = "";
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.bookmark),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(BookmarkedHymnsListScreen.routeName);
                  }),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 12),
        child: HymnScreenBody(
          query: query,
          key: UniqueKey(),
        ),
      ),
    );
  }
}

class HymnScreenBody extends StatefulWidget {
  final String query;
 
  const HymnScreenBody({
    Key? key,
    required this.query,
  }) : super(key: key);
  @override
  _HymnScreenBodyBodyRouteState createState() => new _HymnScreenBodyBodyRouteState();
  

}

class _HymnScreenBodyBodyRouteState extends State<HymnScreenBody> {
   
  List<HymnsModel>? items = [];
  bool isLoading = false;
  bool isError = false;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  int page = 0;
/* 
  void _onRefresh() async {
    loadItems();
  }

  void _onLoading() async {
    loadMoreItems();
  } */

  /* loadItems() {
    refreshController.requestRefresh();
    page = 0;
    setState(() {});
   fetchItems();
 
  } */
   void fetchItems() {
    page = 0;
    Future.delayed(Duration.zero, () {
        context.read<HymnsCubit>().getHymns(
          page: page.toString(),
          query: widget.query,
          userId: context.read<UserDetailsCubit>().getUserId(),
        );
    });
  }
/* 
  loadMoreItems() {
    page = page + 1;
     
        Future.delayed(Duration.zero, () {
        context.read<HymnsCubit>().getHmns(
          page: page.toString(),
          query: widget.query,
          userId: context.read<UserDetailsCubit>().getUserId(),
        );
    });
  } */
/* 
  void setItems(List<Hymns>? item) {
    items!.clear();
    items = item;
    refreshController.refreshCompleted();
    isError = false;
    setState(() {});
  }

  void setMoreItems(List<Hymns> item) {
    refreshController.loadComplete();
    isError = false;
    items!.addAll(item);
    setState(() {});
  } */
   /*  Future<List?> fetchItems(String contestId) async {
    try {
      Map<String, String> body = {
        accessValueKey: accessValue,
        contestIdKey: contestId,
        "query": widget.query,
        "page": page.toString()
      };

      final response = await http.post(Uri.parse(getHmnsList),
          body: body, headers: await ApiUtils.getHeaders());

      final responseJson = jsonDecode(response.body);


      if (responseJson['error']) {
        throw QuizException(errorMessageCode: responseJson['message']); //error
      }
      return responseJson['data'];
    } on SocketException catch (_) {
      throw QuizException(errorMessageCode: noInternetCode);
    } on QuizException catch (e) {
      throw QuizException(errorMessageCode: e.toString());
    } catch (e) {
      throw QuizException(errorMessageCode: defaultErrorMessageCode);
    }
  } */

/*   Future<void> fetchItems() async {
    try {
      final dio = Dio();
      // Adding an interceptor to enable caching.
      final body = {
        accessValueKey: accessValue, 
        userIdKey: userId,
        "query": widget.query,
        "page": page.toString()
      };

      final response = await dio.post(
        getHmnsList,
        data: jsonEncode({
          "data": body
        }),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        dynamic res = jsonDecode(response.data);
        print(res);
        List<Hymns>? mediaList = parseSliderMedia(res);
        if (page == 0) {
          setItems(mediaList);
        } else {
          setMoreItems(mediaList!);
        }
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setFetchError();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      setFetchError();
    }
  }

  static List<Hymns>? parseSliderMedia(dynamic res) {
    final parsed = res["hymns"].cast<Map<String, dynamic>>();
    return parsed.map<Hymns>((json) => Hymns.fromJson(json)).toList();
  } */

  /* setFetchError() {
    if (page == 0) {
      setState(() {
        isError = true;
        refreshController.refreshFailed();
      });
    } else {
      setState(() {
        refreshController.loadFailed();
      });
    }
  } */

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      fetchItems();
    });
  }

  @override
  Widget build(BuildContext context) {
 /*    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text(t.pulluploadmore);
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text(t.loadfailedretry);
          } else if (mode == LoadStatus.canLoading) {
            body = Text(t.releaseloadmore);
          } else {
            body = Text(t.nomoredata);
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: (isError == true && items!.length == 0)
          ? NoitemScreen(
              title: t.oops, message: t.dataloaderror, onClick: _onRefresh)
          : ListView.builder(
              itemCount: items!.length,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(3),
              itemBuilder: (BuildContext context, int index) {
                return ItemTile(
                  object: items![index],
                );
              },
            ),
    ); */
print(widget.query);
return BlocConsumer<HymnsCubit, HymnsState>(
        bloc: context.read<HymnsCubit>(),
        listener: (context, state) {
          if (state is  HymnsFailure) {
            if (state.errorMessage == unauthorizedAccessCode) {
              //
              print(state.errorMessage);
              UiUtils.showAlreadyLoggedInDialog(context: context);
            }
          }
        },
        builder: (context, state) {
          if (state is  HymnsFetchInProgress || state is  HymnsInitial) {
            return Center(
              child: CircularProgressContainer(
                useWhiteLoader: false,
              ),
            );
          }
          if (state is HymnsFailure) {
            return ErrorContainer(
              showBackButton: false,
              errorMessageColor: Theme.of(context).primaryColor,
              showErrorImage: true,
              errorMessage: AppLocalization.of(context)!.getTranslatedValues(
                convertErrorCodeToLanguageKey(state.errorMessage),
              ),
              onTapRetry: () {
                context.read<HymnsCubit>().getHymns(
                     page: page.toString(),
                    query: widget.query,
                    userId: context.read<UserDetailsCubit>().getUserId(),
                    );
              },
            );
          }
          final hymnsList = (state as HymnsSuccess).hymnsList;

          return ListView.builder(
              itemCount: hymnsList.length,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(3),
              itemBuilder: (BuildContext context, int index) {
                return ItemTile(
                  object: hymnsList[index],
                );
              },
            );
         
        });



  }
}

class ItemTile extends StatelessWidget {
  final HymnsModel object;

  const ItemTile({
    Key? key,
    required this.object,
  })  : 
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screen =  MediaQuery.of(context).size/2;
    return InkWell(
      onTap: () {
        print("thumbnail = " + object.thumbnail!);
        Navigator.of(context).pushNamed(HymnsViewerScreen.routeName,
            arguments: ScreenArguements(
              position: 0,
              items: object,
              itemsList: [],
            ));
      },
      child: Container(
        height: 70,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(10, 5, 15, 5),
        child: Column(
          children: <Widget>[
            Expanded( 
              child: Row(
                
                children: <Widget>[
                  Container(
                    height: 40,
                    width: 40,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors
                          .primaries[Random().nextInt(Colors.primaries.length)],
                      child: Text(
                        object.title!.substring(0, 1),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
 

                  Container(
                    width: 270,
                    padding: EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,  
                  child:Flexible(
                  child: RichText(
                  overflow: TextOverflow.ellipsis,
                  strutStyle: StrutStyle(fontSize: 18.0),
                  text: TextSpan(
                      style: TextStyles.headline(context).copyWith(fontWeight: FontWeight.w500, fontSize: 17),
                      text: object.title!),
                   ),
                  ),
              ),
                
           

            /*  Container(
            padding: EdgeInsets.all(4.0),
            color: Colors.lime, 
            child: Row(
            children: <Widget>[
              Container(
              width: _screen.width * 0.4,
                child:Flexible(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  strutStyle: StrutStyle(fontSize: 18.0),
                  text: TextSpan(
                      style: TextStyles.headline(context).copyWith(fontWeight: FontWeight.w500, fontSize: 18),
                      text: object.title!),
                   ),
                  ),
              ),
              Container(
              width: _screen.width * 0.45,
                child: Consumer<HymnsBookmarksModel>(
                  builder: (context, bookmarksModel, child) {
                    bool isBookmarked =
                        bookmarksModel.isHymnBookmarked(object);
                    return InkWell(
                      child: Icon(Icons.bookmark,
                          color: isBookmarked
                              ? Colors.redAccent
                              : Colors.grey,
                          size: 20.0),
                      onTap: () {
                        if (isBookmarked)
                          bookmarksModel.unBookmarkHymn(object);
                        else
                          bookmarksModel.bookmarkHymn(object);
                      },
                    );
                  },
                ),
              ),
               ],
              ),
            ),
 */




               /*    Expanded(   
                    
                       child:Row(
                       
                              children: <Widget>[

                            Align(
                              
                            alignment: Alignment.centerLeft,
                          //  child: Text(object.title!,
                             child: Text(object.title!,overflow: TextOverflow.ellipsis, 
                                maxLines: 2,
                                style: TextStyles.headline(context).copyWith(
                                    //color: MyColors.grey_80,
                                    fontWeight: FontWeight.w500, fontSize: 18)),
                               
                          ),

                             Spacer(),

                            Consumer<HymnsBookmarksModel>(
                              builder: (context, bookmarksModel, child) {
                                bool isBookmarked =
                                    bookmarksModel.isHymnBookmarked(object);
                                return InkWell(
                                  child: Icon(Icons.bookmark,
                                      color: isBookmarked
                                          ? Colors.redAccent
                                          : Colors.grey,
                                      size: 20.0),
                                  onTap: () {
                                    if (isBookmarked)
                                      bookmarksModel.unBookmarkHymn(object);
                                    else
                                      bookmarksModel.bookmarkHymn(object);
                                  },
                                );
                              },
                            ),
                               
                              ],
                            ),
                         
                     
                  ) */
                ],
              ),
              
            ),
               Container(
              alignment: Alignment.centerRight,
                child: Consumer<HymnsBookmarksModel>(
                  builder: (context, bookmarksModel, child) {
                    bool isBookmarked =
                        bookmarksModel.isHymnBookmarked(object);
                    return InkWell(
                      child: Icon(Icons.bookmark,
                          color: isBookmarked
                              ? Colors.redAccent
                              : Colors.grey,
                          size: 20.0),
                      onTap: () {
                        if (isBookmarked)
                          bookmarksModel.unBookmarkHymn(object);
                        else
                          bookmarksModel.bookmarkHymn(object);
                      },
                    );
                  },
                ),
              ),
            Divider(
              height: 0.1,
              //color: Colors.grey.shade800,
            )
          ],
        ),
      ),
    );
  }
}
 */