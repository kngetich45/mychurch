import 'package:bevicschurch/features/bible/models/BibleModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../app/routes.dart';
import '../../../../features/bible/BibleRepository.dart';
import '../../../../features/bible/cubits/BibleCubit.dart'; 
import '../../../../features/providers/BibleProvider.dart'; 
import '../../../styles/TextStyles.dart';

class BibleVersesTile extends StatefulWidget {
  final BibleModel object;
  final bool showCompare;

  const BibleVersesTile({
    Key? key,
    required this.object,
    required this.showCompare,
  }) : super(key: key);

  @override 
    State<BibleVersesTile> createState() => _BibleVersesTileState();
  static Route<dynamic> route(RouteSettings routeSettings){
      Map arguments = routeSettings.arguments as Map;
    return CupertinoPageRoute(
      builder: (_)=> MultiProvider(
                providers: [ BlocProvider<BibleCubit>(
        create: (_) => BibleCubit(BibleRepository())),
                      ChangeNotifierProvider<BibleProvider>(
                     create: (context) => BibleProvider(),
                    ),
                     ],    
        child: BibleVersesTile(
             object: arguments['items'],
             showCompare: arguments['items'],
        ),
      )
      );
  }
}

class _BibleVersesTileState extends State<BibleVersesTile> {
   @override
  Widget build(BuildContext context) {
    BibleProvider bibleModel = Provider.of<BibleProvider>(context);
    int fontSize = bibleModel.selectedFontSize;
    return InkWell(
      onTap: () {
        bibleModel.onVerseTapped(widget.object);
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          title: Consumer<BibleProvider>(
            builder: (context, bibleModel, child) {
              if (bibleModel.isBibleHighlighted(widget.object)) {
                return RichText(
                  text: TextSpan(
                    style: TextStyles.subhead(context).copyWith(
                        //color: MyColors.grey_80,
                        fontWeight: FontWeight.w500),
                    children: <TextSpan>[
                      TextSpan(
                        text: widget.object.verse.toString() + ". ",
                        style: TextStyle(fontSize: fontSize.toDouble()),
                      ),
                      TextSpan(
                        text: widget.object.content,
                        style: TextStyle(
                            fontSize: fontSize.toDouble(),
                            backgroundColor: Colors.grey[400]),
                      ),
                    ],
                  ),
                );
              } else {
                //print(bibleModel.coloredHighlightedBibleVerses[0].content);
                BibleModel? bible =
                    bibleModel.getBibleColoredHighlightedVerse(widget.object);
                //print(bible);
                if (bible != null) {
                  return RichText(
                    text: TextSpan(
                      style: TextStyles.subhead(context).copyWith(
                          //color: MyColors.grey_80,
                          fontWeight: FontWeight.w500),
                      children: <TextSpan>[
                        TextSpan(
                          text: bible.verse.toString() + ". ",
                          style: TextStyle(fontSize: fontSize.toDouble()),
                        ),
                        TextSpan(
                          text: bible.content,
                          style: TextStyle(
                              fontSize: fontSize.toDouble(),
                              backgroundColor: bible.color == 0
                                  ? Colors.yellow
                                  : Color(bible.color!)),
                        ),
                      ],
                    ),
                  );
                } else
                  return RichText(
                    text: TextSpan(
                      style: TextStyles.subhead(context).copyWith(
                          //color: MyColors.grey_80,
                          fontWeight: FontWeight.w500),
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.object.verse.toString() + ". ",
                          style: TextStyle(fontSize: fontSize.toDouble()),
                        ),
                        TextSpan(
                          text: widget.object.content,
                          style: TextStyle(fontSize: fontSize.toDouble()),
                        ),
                      ],
                    ),
                  );
              }
            },
          ),
          subtitle: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Row(
              children: <Widget>[
                Spacer(),
                Visibility(
                  visible: widget.showCompare,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(Routes.bibleVerseCompare,
                          arguments: {
                            "position": 0,
                            "items": widget.object,
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        "compare",
                        style:
                            TextStyles.caption(context).copyWith(fontSize: 15),
                      ),
                    ),
                  ),
                ),
            
              ],
            ),
          ),
        ),
      ),
    );
  }
}
