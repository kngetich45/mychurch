import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../features/events/EventsRepository.dart';
import '../../../features/events/cubits/EventsCubit.dart';
import '../../../utils/img.dart';
import '../../../utils/constants.dart';
import '../../../features/events/models/EventsModel.dart';
import '../../styles/TextStyles.dart'; 
import 'package:intl/intl.dart';
import '../../../i18n/strings.g.dart';
import '../../widgets/Banneradmob.dart'; 

class EventsViewerScreen extends StatefulWidget {
  static const routeName = "/eventsviewer";
    final EventsModel events;
  const EventsViewerScreen({Key? key, required this.events}) : super(key: key);


  @override
  State<EventsViewerScreen> createState() => _BranchesPageBodyState();
   static Route<dynamic> route(RouteSettings routeSettings){
      Map arguments = routeSettings.arguments as Map;
    return CupertinoPageRoute(
      builder: (_)=> BlocProvider<EventsCubit>(
        create: (_) => EventsCubit(EventsRepository()),
        child: EventsViewerScreen(
             events: arguments['items']
        ),
      )
      );
  }
}

class _BranchesPageBodyState extends State<EventsViewerScreen> {
  bool isLoading = false;
  bool isError = false;

  @override
  void initState() {
    /*Future.delayed(const Duration(milliseconds: 0), () {
      loadItems();
    });*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(t.events),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 12),
        child: SingleChildScrollView(
          child: getEventsBody(),
        ),
      ),
    );
  }

  Widget getEventsBody() {
/*     if (isLoading) {
      return Container(
        height: 600,
        child: Center(
          child: CupertinoActivityIndicator(
            radius: 20,
          ),
        ),
      );
    } else if (isError || widget.events == null) {
      return Container(
        height: 600,
        child: Center(
          child: NoitemScreen(
              title: t.oops,
              message: t.dataloaderror,
              onClick: () {
                //loadItems();
              }),
        ),
      );
    } else */
      return Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(widget.events.title.toString(),
                  textAlign: TextAlign.start,
                  style: TextStyles.headline(context)
                      .copyWith(fontWeight: FontWeight.bold)),
            ),
            Container(height: 5),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  DateFormat('EEE, MMM d, yyyy').format(
                      new DateFormat("yyyy-MM-dd").parse(widget.events.date.toString())),
                  textAlign: TextAlign.justify,
                  style: TextStyles.subhead(context).copyWith(fontSize: 16)),
            ),
            Container(height: 20),
            Container(
              height: 200,
              //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: CachedNetworkImage(
                  imageUrl: databaseUrl+'/images/events/'+widget.events.thumbnail.toString(),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black12, BlendMode.darken)),
                    ),
                  ),
                  placeholder: (context, url) =>
                      Center(child: CupertinoActivityIndicator()),
                  errorWidget: (context, url, error) => Center(
                      child: Image.asset(
                    Img.get('event.jpg'),
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: double.infinity,
                    //color: Colors.black26,
                  )),
                ),
              ),
            ),
            Container(height: 20),
            HtmlWidget(
              widget.events.details.toString(),
              textStyle: TextStyles.body1(context).copyWith(fontSize: 20),
            ),
              Container(height: 30),
             Row(children: [

                ElevatedButton(
                  onPressed: (){
                    // Navigator.of(context).pushNamed(Routes.home);
                  },
                  child: const Text("Event Registrations ", style: TextStyle(
                      color: Colors.black,
                      ),
                    ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.greenAccent,
                    shadowColor: Colors.redAccent,
                    
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle:
                    const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )
                  ),
                  ),
                  Spacer(),
                ElevatedButton(
                  onPressed: (){
                    // Navigator.of(context).pushNamed(Routes.home);
                  },
                  child: const Text("Add To Calender", style: TextStyle(
                      color: Colors.white,
                      ),
                    ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    shadowColor: Colors.redAccent,
                    
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    textStyle:
                    const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                        color: Colors.white,
                      )
                  ),
                  ),
           

             ],),
              
            Container(height: 30),
            Banneradmob(),
          ],
        ),
      );
  }
}
