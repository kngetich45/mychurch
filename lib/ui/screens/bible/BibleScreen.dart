import 'package:bevicschurch/features/providers/BibleProvider.dart';
import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../../../app/routes.dart';
import '../../../features/bible/BibleRepository.dart';
import '../../../features/bible/cubits/BibleCubit.dart';
import '../../../features/bible/cubits/BibleVerseCubit.dart';
import '../../../features/bible/models/BibleModel.dart';
import '../../../i18n/strings.g.dart'; 
import '../../styles/TextStyles.dart';
import 'BibleViewScreen.dart';

class BibleScreen extends StatefulWidget {
  static const routeName = "/biblescreen";
const BibleScreen({Key? key}) : super(key: key);
  @override 
   State<BibleScreen> createState() =>_BibleScreenState();

       static Route<BibleScreen> route(RouteSettings routeSettings) { 

        return CupertinoPageRoute(
        builder: (_) => MultiProvider(
                providers: [BlocProvider<BibleCubit>(
                      create: (_) => BibleCubit(BibleRepository())),
                      BlocProvider<BibleVerseCubit>(
                      create: (_) => BibleVerseCubit(BibleRepository())),
                       ChangeNotifierProvider<BibleProvider>(
                          create: (context) => BibleProvider(),
                        ),
                         
                     // ChangeNotifierProvider.value(value: BibleProvider()),
                      ],
              child: BibleScreen(),
            ));
  } 
} 
class _BibleScreenState extends State<BibleScreen> {
  Future<List<BibleModel>>? bibleLoader;
  PageController? controller;
  int itemCount = 0;
  List<BibleModel>? currentBibleList = [];
  BibleProvider? bibleProvider;

  @override
  void initState() { 
    itemCount =
        Provider.of<BibleProvider>(context, listen: false).selectedBookLength;
    bibleLoader = Provider.of<BibleProvider>(context, listen: false)
        .showCurrentBibleData(
            Provider.of<BibleProvider>(context, listen: false).selectedChapter);
    controller = PageController(
      initialPage:
          Provider.of<BibleProvider>(context, listen: false).selectedChapter - 1,
    );

    super.initState();
  }
   
  @override
  Widget build(BuildContext context) { 
  //BibleProvider bibleModel = Provider.of<BibleProvider>(context);
    bibleProvider = Provider.of<BibleProvider>(context);
    int bibleversionsize = bibleProvider!.downloadedBibleList.length;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(t.biblebooks),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.bibleSearch);
              },
              icon: Icon(Icons.search),
              iconSize: 25,
            ),
          ),
          Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {
                    //  showSearchFilterOptions(context, bibleProvider);
                    },
                    icon: Icon(Icons.filter_list),
                    iconSize: 30,
                  ),
                )
        ],
      ),
     body: bibleversionsize == 0 ? EmptyLayout() : BibleViewScreen(),
     //  body: bibleversionsize == 0 ? EmptyLayout() :  _bibleViewLayout(context),

    );
  }
   
}
 


class EmptyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(Routes.bibleVerse);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Lottie.asset("assets/lottie/bible.json",
                      height: 200, width: 200),
                ),
                Container(height: 0),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(t.nobibleversionshint,
                      textAlign: TextAlign.center,
                      style: TextStyles.medium(context).copyWith()),
                ),
                Container(height: 5),
                Container(
                  width: 180,
                  height: 40,
                  child: TextButton(
                    child: Text(t.downloadbible,
                        style: TextStyle(color: Colors.white)),
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(Routes.bibleVerse);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
