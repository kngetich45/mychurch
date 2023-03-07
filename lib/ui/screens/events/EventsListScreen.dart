import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/appLocalization.dart';
import '../../../app/routes.dart';
import '../../../features/events/EventsRepository.dart';
import '../../../features/events/cubits/EventsCubit.dart';
import '../../../features/profileManagement/cubits/userDetailsCubit.dart';
import '../../../utils/errorMessageKeys.dart';
import '../../../utils/uiUtils.dart';
import '../../widgets/circularProgressContainner.dart';
import '../../widgets/errorContainer.dart';
import 'dart:async';
import '../../../utils/img.dart';
import 'package:cached_network_image/cached_network_image.dart'; 
import '../../../features/events/models/EventsModel.dart';
import '../../styles/TextStyles.dart'; 
import 'package:intl/intl.dart';
import '../../../i18n/strings.g.dart';

class EventsListScreen extends StatefulWidget {
  static const routeName = "/eventslist";
  const EventsListScreen({Key? key}) : super(key: key);

  @override
  State<EventsListScreen> createState() => _EventsListScreenState();
   static Route<dynamic> route(RouteSettings routeSettings) { 
     
      return CupertinoPageRoute(
         builder: (_) => BlocProvider<EventsCubit>(
            create: (_) => EventsCubit(EventsRepository()),
            child: EventsListScreen()));
  }
}

class _EventsListScreenState extends State<EventsListScreen> {
  DateTime selectedDate = DateTime.now();
  String _selecteddate = "";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _selecteddate = DateFormat('yyyy-MM-dd').format(selectedDate);
        print(_selecteddate);
      });
    } else {
      print("picked null" + picked.toString());
    }
  }

  @override
  void initState() {
    _selecteddate = DateFormat('yyyy-MM-dd').format(selectedDate);
    Future.delayed(Duration.zero, () {
        context.read<EventsCubit>().getEvents(  
          eventsDate: _selecteddate,
          userId: context.read<UserDetailsCubit>().getUserId(),
        );
    });
    _fetchEvents();
    super.initState();
  }
    _fetchEvents() { 
   Future.delayed(Duration.zero, () {
        context.read<EventsCubit>().getEvents( 
          eventsDate: _selecteddate,
          userId: context.read<UserDetailsCubit>().getUserId(),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(t.events),
        actions: [
          SizedBox(
            height: 38,
            width: 38,
            child: InkWell(
              highlightColor: Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(32.0)),
              onTap: () {
                setState(() {
                  selectedDate = selectedDate.subtract(new Duration(days: 1));
                  _selecteddate = DateFormat('yyyy-MM-dd').format(selectedDate);
                });
              },
              child: Center(
                child: Icon(
                  Icons.keyboard_arrow_left,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.calendar_today,
                    size: 18,
                  ),
                ),
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Text(
                    DateFormat('d MMM').format(selectedDate),
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 38,
            width: 38,
            child: InkWell(
              highlightColor: Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(32.0)),
              onTap: () {
                setState(() {
                  selectedDate = selectedDate.add(new Duration(days: 1));
                  _selecteddate = DateFormat('yyyy-MM-dd').format(selectedDate);
                });
              },
              child: Center(
                child: Icon(
                  Icons.keyboard_arrow_right,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 12),
        child: _eventsListScreenPageBody(context, _selecteddate, selectedDate), 
      ),
    );
  }
} 

Widget _eventsListScreenPageBody(BuildContext context, final String date, final DateTime dateTime) {
    
 return BlocConsumer<EventsCubit, EventsState>(
        bloc: context.read<EventsCubit>(),
        listener: (context, state) {
          if (state is  EventsFailure) {
            if (state.errorMessage == unauthorizedAccessCode) {
              //
              print(state.errorMessage);
              UiUtils.showAlreadyLoggedInDialog(context: context);
            }
          }
        },
        builder: (context, state) {
          if (state is  EventsFetchInProgress || state is  EventsInitial) {
            return Center(
              child: CircularProgressContainer(
                useWhiteLoader: false,
              ),
            );
          }
          if (state is EventsFailure) {
            return ErrorContainer(
              showBackButton: false,
              errorMessageColor: Theme.of(context).primaryColor,
              showErrorImage: true,
              errorMessage: AppLocalization.of(context)!.getTranslatedValues(
                convertErrorCodeToLanguageKey(state.errorMessage),
              ),
              onTapRetry: () {
                context.read<EventsCubit>().getEvents(  
                    eventsDate: date,
                    userId: context.read<UserDetailsCubit>().getUserId(),
                    );
              },
            );
          }
          final eventsList = (state as EventsSuccess).eventsList;
     
            return ListView.builder(
              itemCount: eventsList.length,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(3),
              itemBuilder: (BuildContext context, int index) {
                return ItemTile(
                  index: index,
                  events: eventsList[index],
                );
              },
            );
            });
  }
 

class ItemTile extends StatelessWidget {
  final EventsModel events;
  final int index;

  const ItemTile({
    Key? key,
    required this.index,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(events.date!);
    return InkWell(
      onTap: () {
           
             Navigator.of(context).pushNamed(Routes.eventsViewer, arguments: { 
                  "items": events
              });  
      },
      child: Container(
        height: 90,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Card(
                      margin: EdgeInsets.all(0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Container(
                        height: 80,
                        width: 100,
                        child: CachedNetworkImage(
                          imageUrl: 'https://churchs.bevics.com/images/events/'+ events.thumbnail.toString(),
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
                      )),
                  Container(width: 10),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(events.title.toString(),
                              maxLines: 2,
                              style: TextStyles.headline(context).copyWith(
                                  //color: MyColors.grey_80,
                                  fontWeight: FontWeight.w500, fontSize: 16)),
                        ),
                        Spacer(),
                        Row(
                          children: <Widget>[
                            Text(
                                DateFormat('EEE, MMM d, yyyy').format(tempDate),
                                style: TextStyles.caption(context)
                                //.copyWith(color: MyColors.grey_60),
                                ),
                            Spacer(),
                            Text(events.time.toString(),
                                style: TextStyles.caption(context)
                                //.copyWith(color: MyColors.grey_60),
                                ),
                          ],
                        ),
                        Spacer(),
                        
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 10,
            ),
            Divider(
              height: 0.1,
               color: Colors.grey.shade400,
            )
          ],
        ),
      ),
    );
  }
}
