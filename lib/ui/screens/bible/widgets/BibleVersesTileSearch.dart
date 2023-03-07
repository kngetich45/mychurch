 

import 'package:bevicschurch/features/providers/BibleProvider.dart'; 
import '../../../../app/routes.dart';
import '../../../../features/bible/models/BibleModel.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:provider/provider.dart'; 
import '../../../styles/TextStyles.dart';

class BibleVersesTileSearch extends StatefulWidget {
  final BibleModel object;
  final String query;

  const BibleVersesTileSearch({
    Key? key,
    required this.object,
    required this.query,
  }) : super(key: key);

  @override
  @override
  _BibleVersesTileState createState() => _BibleVersesTileState();
 
}

class _BibleVersesTileState extends State<BibleVersesTileSearch> {
  late Map<String, HighlightedWord> words;

  @override
  void initState() {
    super.initState();
    words = {
      widget.query: HighlightedWord(
        onTap: () {},
        textStyle: TextStyle(
            fontSize: Provider.of<BibleProvider>(context, listen: false)
                .selectedFontSize
                .toDouble(),
            color: Colors.red),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
   
    BibleProvider bibleModel = Provider.of<BibleProvider>(context);
    int fontSize = bibleModel.selectedFontSize;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
        title: TextHighlight(
          text: widget.object.book! +
              " " +
              widget.object.chapter.toString() +
              " vs" +
              widget.object.verse.toString() +
              ": \n" +
              widget.object.content!,
          words: words,
          matchCase: false,
          textStyle: TextStyle(
              fontSize: fontSize.toDouble(),
              color: Colors.black),
        ),

    
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Row(
            children: <Widget>[
              Spacer(),
              Visibility(
                visible: bibleModel.downloadedBibleList.length > 1,
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
                      style: TextStyles.caption(context).copyWith(fontSize: 15),
                    ),
                  ),
                ),
              ),
              /* Container(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, BibleTranslator.routeName,
                      arguments: ScreenArguements(
                        position: 0,
                        items: widget.object,
                      ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "translate",
                    style: TextStyles.caption(context).copyWith(fontSize: 15),
                  ),
                ),
              ), */
            ],
          ),
        ),
      ),
    );
  }
}
