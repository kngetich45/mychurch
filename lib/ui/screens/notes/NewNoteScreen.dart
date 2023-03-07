import 'dart:async';
import 'dart:convert';
import 'dart:math'; 
import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import '../../../app/routes.dart';
import '../../../i18n/strings.g.dart';
import '../../../features/notes/NotesRepository.dart';
import '../../../features/notes/cubits/NewNotesCubit.dart';

class NewNotesScreen extends StatefulWidget {
  static const routeName = "/newnotes";

  @override
  _NewNotesScreenState createState() => _NewNotesScreenState();
    static Route<NewNotesScreen> route(RouteSettings routeSettings) { 

        return CupertinoPageRoute(
        builder: (_) => BlocProvider<NewNotesCubit>(
              create: (_) => NewNotesCubit(NotesRepository()),
              child: NewNotesScreen(),
            ));
  } 

}

class _NewNotesScreenState extends State<NewNotesScreen> {
  QuillController? _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadNote();
    
  }

  Future<void> _loadNote() async {
    final doc = Document()..insert(0, 'Tap to add a Note');
    setState(() {
      _controller = QuillController(
          document: doc, selection: const TextSelection.collapsed(offset: 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(body: Center(child: Text('Loading...')));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        centerTitle: false,
        title: const Text(
          'Create Note',
        ),
         leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.notes);
          },
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                saveNoteDialog(context);
              })
        ],
      ),
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event) {
          if (event.data.isControlPressed && event.character == 'b') {
            if (_controller!
                .getSelectionStyle()
                .attributes
                .keys
                .contains('bold')) {
              _controller!
                  .formatSelection(Attribute.clone(Attribute.bold, null));
            } else {
              _controller!.formatSelection(Attribute.bold);
            }
          }
        },
        child: _buildWelcomeEditor(context),
      ),
    );
  }

  Widget _buildWelcomeEditor(BuildContext context) {
    var quillEditor = QuillEditor(
        controller: _controller!,
        scrollController: ScrollController(),
        scrollable: true,
        focusNode: _focusNode,
        autoFocus: false,
        readOnly: false,
        placeholder: 'Add content',
        expands: false,
        padding: EdgeInsets.zero,
        customStyles: DefaultStyles(
          h1: DefaultTextBlockStyle(
              const TextStyle(
                fontSize: 32,
                color: Colors.black,
                height: 1.15,
                fontWeight: FontWeight.w300,
              ),
              const Tuple2(16, 0),
              const Tuple2(0, 0),
              null),
          sizeSmall: const TextStyle(fontSize: 9),
        ));

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 20,
          ),
          Expanded(
            flex: 15,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: quillEditor,
            ),
          ),
          Container(
            child: QuillToolbar.basic(
              controller: _controller!,
            ),
          ),
        ],
      ),
    );
  }

  void saveNoteDialog(BuildContext _context) {
    String name = "";
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
         //  builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              t.savenotetitle,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  t.cancel,
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
               //   Navigator.of(context).pop();
                   Navigator.of(context).pushReplacementNamed(Routes.notes);
                },
              ),
              TextButton(
                child: Text(
                  t.ok,
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  if (name != "") {
                   //  context.read<NewNotesCubit>().saveNotes(
                    Provider.of<NewNotesCubit>(context, listen: false).saveNotes(
                          title: name,
                          color: Colors.primaries[
                              Random().nextInt(Colors.primaries.length)],
                          content: jsonEncode(_controller!.document.toDelta().toJson()),
                          date: DateTime.now().millisecondsSinceEpoch
                    ); 
                  //  Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed(Routes.notes);
                  }
                },
              ),
            ],
            content: TextField(
              controller: TextEditingController(text: ""),
              autofocus: true,
              onChanged: (text) {
                name = text;
              },
              // cursorColor: Colors.black,
            ),
          );
        }).then((val) {
      //Navigator.pop(_context);
       Navigator.of(context).pushReplacementNamed(Routes.notes);
    });
  }
}
