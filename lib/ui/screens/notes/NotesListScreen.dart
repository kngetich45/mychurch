import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/appLocalization.dart';
import '../../../app/routes.dart';
import '../../../ui/styles/colors.dart';
import '../../../ui/widgets/circularProgressContainner.dart';
import '../../../ui/widgets/errorContainer.dart';
import '../../../ui/widgets/pageBackgroundGradientContainer.dart';
import '../../../utils/errorMessageKeys.dart';
import '../../../utils/uiUtils.dart'; 
import '../../../utils/Alerts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import '../../../features/providers/NotesProvider.dart'; 
import 'package:clipboard/clipboard.dart'; 
import '../../../utils/TimUtil.dart';
import '../../../features/models/Notes.dart';
import '../../../i18n/strings.g.dart';
import '../../../ui/styles/TextStyles.dart';
import '../../../ui/screens/EmptyListScreen.dart';
import '../../../features/notes/NotesRepository.dart';
import '../../../features/notes/cubits/NotesCubit.dart';

class NotesListScreen extends StatefulWidget {
  static const routeName = "/noteslist";
    NotesListScreen({Key? key}) : super(key: key);
  @override
  _NotesListScreenRouteState createState() => _NotesListScreenRouteState();
   static Route<NotesListScreen> route(RouteSettings routeSettings) { 

        return CupertinoPageRoute(
        builder: (_) => BlocProvider<NotesCubit>(
              create: (_) => NotesCubit(NotesRepository()),
              child: NotesListScreen(),
            ));
  }
 
}

class _NotesListScreenRouteState extends State<NotesListScreen> {
  NotesProvider? notesProvider;
  ScrollController? controller;
  bool fabIsVisible = true;
  bool showClear = false;
  String query = "";
  final TextEditingController inputController = new TextEditingController();

 


  @override
  void initState() {
    controller = ScrollController();
    controller!.addListener(() {
      setState(() {
        fabIsVisible =
            controller!.position.userScrollDirection == ScrollDirection.forward;
      });
    });
    Future.delayed(Duration.zero, () {
      context.read<NotesCubit>().getNotes();
    });
    //loadData();

    super.initState();
  }
   /* loadData(){

    notesProvider = context.read<NotesCubit>().getNotes();
    items = notesProvider!.notesList;

   } */

  @override
  Widget build(BuildContext context) {
 //   notesProvider = Provider.of<NotesProvider>(context);
   //notesProvider = context.read<NotesCubit>().getNotes();

   // List<Notes> items = notesProvider!.notesList;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: TextField(
          maxLines: 1,
          controller: inputController,
          style: new TextStyle(fontSize: 18, color: Colors.white),
          keyboardType: TextInputType.text,
          onChanged: (term) {
            if (term.length > 0) {
              notesProvider!.searchNotes(term);
              showClear = true;
            } else if (term.length == 0) {
              showClear = false;
              notesProvider!.getNotes();
            }
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: t.notes,
            hintStyle: TextStyle(fontSize: 20.0, color: Colors.white70),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.dashboard);
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
                    notesProvider!.getNotes();
                  },
                )
              : Container(),
        ],
      ),
      body: Builder(builder: (BuildContext context) { 
      
         return Stack(
             children: [
                PageBackgroundGradientContainer(),
                BlocConsumer<NotesCubit, NotesState>(
                    bloc: context.read<NotesCubit>(),
                    listener: (context, state) {
                      if (state is NotesFailure) {
                        if (state.errorMessage == unauthorizedAccessCode) {
                          //
                          UiUtils.showAlreadyLoggedInDialog(
                            context: context,
                          );
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state is NotesFetchInProgress || state is NotesInitial) {
                        return Center(
                            child: CircularProgressContainer(
                          useWhiteLoader: false,
                        ));
                      }
                      if (state is NotesFailure) {
                        print(state.errorMessage);
                        return ErrorContainer(
                          errorMessage: AppLocalization.of(context)!
                              .getTranslatedValues(
                                  convertErrorCodeToLanguageKey(
                                      state.errorMessage)),
                          onTapRetry: () {
                            context.read<NotesCubit>().getNotes();
                          },
                          showErrorImage: true,
                          errorMessageColor: Theme.of(context).primaryColor,
                        );
                      }
                      final items = (state as NotesSuccess).notesList;
      
                        return Padding(
                        padding: EdgeInsets.all(3),
                        child: (items.length == 0)
                            ? EmptyListScreen(message: t.nonotesfound)
                            : GridView.builder(
                               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1),

                                controller: controller,
                                itemCount: items.length,
                                scrollDirection: Axis.vertical,
                                padding: EdgeInsets.all(3),
                                itemBuilder: (BuildContext context, int index) {
                                  return ItemTile(
                                    object: items[index],
                                    notesProvider: notesProvider,
                                  );
                                },
                              ),
                      );}
                     )]);
              }),
      floatingActionButton: AnimatedOpacity(
        child: FloatingActionButton.extended(
          backgroundColor: primaryColor,
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(Routes.newNotes);
          },
          icon: Icon(Icons.add_circle),
          label: Text(t.newnote),
        ),
        duration: Duration(milliseconds: 100),
        opacity: fabIsVisible ? 1 : 0,
      ),
    );
    
  }
  
}

class ItemTile extends StatefulWidget {
  final Notes object;
  final NotesProvider? notesProvider;

  const ItemTile({
    Key? key,
    required this.object,
    required this.notesProvider,
  }) : super(key: key);

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  @override
  Widget build(BuildContext context) {
   /*  var enableAction = false; */
/*     final doc = Document.fromJson(jsonDecode(widget.object.content!)); */
    return InkWell(
      onTap: () { 
             Navigator.of(context)
                          .pushNamed(Routes.notesEditor, arguments: { 
                        "position": 0,
                        "items": widget.object,
                        "itemsList": [],
                        "itemsID": widget.object.id,
            });
         },
      onLongPress: (() {
         setState(() {
           /*  enableAction=true; */
          });
      }),
      child: Container(
         
        width: double.infinity,
        margin: EdgeInsets.all(5),
           decoration: BoxDecoration(color: widget.object.color,),
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          children: <Widget>[
              
                  /*   Container(
                    margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                    height: 50,
                    width: 50,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: object.color,
                      child: Text(
                        object.title!.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ), */  
                    
                     Column(
                        children: <Widget>[
                          Container(
                            height: 10,
                          ),
                           
                              Text(
                                TimUtil.formatMilliSecondsFullDatestamp(
                                    widget.object.date!),
                                style: TextStyles.caption(context)
                                    .copyWith(fontSize: 15),
                                    
                              ),
                              
                              Text(
                                  TimUtil.formatMilliSecondsFullDTime(
                                      widget.object.date!),
                                  style: TextStyles.caption(context)
                                  //.copyWith(color: MyColors.grey_60),
                                  ),
                           
                          Container(
                            height: 25,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(widget.object.title!,
                                maxLines: 2,
                                style: TextStyles.subhead(context).copyWith(
                                    fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500)),
                          ),
                         
                        ],
                      
                  ),
                
              
            
             
                Container(
                  padding: EdgeInsets.only(top: 25),
                  child: Row(
                    children: <Widget>[
                       Container(width: 15),
                      InkWell(
                        child: Icon(Icons.share, color: Colors.white, size: 21.0),
                        onTap: () async {
                          /*final doc = Document.fromJson(jsonDecode(object.content));
                          QuillController _controller = QuillController(
                              document: doc,
                              selection: const TextSelection.collapsed(offset: 0));*/
                
                          await Share.share(
                            Document.fromJson(jsonDecode(widget.object.content!))
                                .toPlainText(),
                            subject: widget.object.title,
                          );
                        },
                      ),
                      Spacer(),
                     
                      InkWell(
                        child: Icon(Icons.content_copy,
                            color: Colors.white, size: 21.0),
                        onTap: () {
                          FlutterClipboard.copy(
                                  Document.fromJson(jsonDecode(widget.object.content!))
                                      .toPlainText())
                              .then((value) =>
                                  Alerts.showToast(context, t.copiedtoclipboard));
                        },
                      ),
                        Spacer(),
                      InkWell(
                        child:
                            Icon(Icons.delete_forever, color: Colors.white, size: 21.0),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => new CupertinoAlertDialog(
                              title: new Text(t.deletenote),
                              content: new Text(t.deletenotehint),
                              actions: <Widget>[
                                new TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: new Text(t.cancel),
                                ),
                                new TextButton(
                                  onPressed: () {
                                    widget.notesProvider!.deleteNote(widget.object);
                                    Navigator.of(context).pop();
                                  },
                                  child: new Text(t.ok),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                     Container(width: 15),
                    ],
                  ),
                )
             
          ],
        ),
      ),
      
    );
  }
}
