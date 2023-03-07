import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../../../app/appLocalization.dart';
import '../../../features/devotionals/DevotionalsRepository.dart';
import '../../../features/devotionals/cubits/DevotionalsCubit.dart'; 
import '../../../features/profileManagement/cubits/userDetailsCubit.dart';
import '../../../utils/errorMessageKeys.dart';
import '../../../utils/img.dart'; 
import '../../../utils/uiUtils.dart';
import '../../styles/TextStyles.dart';
import '../../widgets/Banneradmob.dart';
import '../../../utils/constants.dart';
import '../../widgets/bannerAdContainer.dart';
import '../../widgets/circularProgressContainner.dart';
import '../../widgets/errorContainer.dart';
import 'package:intl/intl.dart';
import '../../../i18n/strings.g.dart';

class DevotionalScreen extends StatefulWidget {
  static const routeName = "/devotionals";
   
    const DevotionalScreen({Key? key}) : super(key: key);
    
  @override
  State<DevotionalScreen> createState() => _DevotionalScreenState();
   static Route<dynamic> route(RouteSettings routeSettings) { 
     
      return CupertinoPageRoute(
         builder: (_) => BlocProvider<DevotionalsCubit>(
            create: (_) => DevotionalsCubit(DevotionalsRepository()),
            child: DevotionalScreen()));
  }

}

class _DevotionalScreenState extends State<DevotionalScreen> {
  DateTime selectedDate = DateTime.now();
  String _selecteddate = "";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2022, 8),
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
        context.read<DevotionalsCubit>().getDevotionals(  
          devotionalDate: _selecteddate,
          userId: context.read<UserDetailsCubit>().getUserId(),
        );
    });
    _fetchDevotion();
    super.initState();
  }
  _fetchDevotion() { 
   Future.delayed(Duration.zero, () {
        context.read<DevotionalsCubit>().getDevotionals( 
          devotionalDate: _selecteddate,
          userId: context.read<UserDetailsCubit>().getUserId(),
        );
    });
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(t.devotionals),
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 0),
        child: SingleChildScrollView(
          child: _devotionalsPageBody(context, _selecteddate, selectedDate),
        ),
      ),
    );
  }
}  
Widget _devotionalsPageBody(BuildContext context, final String date, final DateTime dateTime) {
  
  return BlocConsumer<DevotionalsCubit, DevotionalsState>(
        bloc: context.read<DevotionalsCubit>(),
        listener: (context, state) {
          if (state is  DevotionalsFailure) {
            if (state.errorMessage == unauthorizedAccessCode) {
              //
              print(state.errorMessage);
              UiUtils.showAlreadyLoggedInDialog(context: context);
            }
          }
        },
        builder: (context, state) {
          if (state is  DevotionalsFetchInProgress || state is  DevotionalsInitial) {
            return Center(
              child: CircularProgressContainer(
                useWhiteLoader: false,
              ),
            );
          }
          if (state is DevotionalsFailure) {
            return ErrorContainer(
              showBackButton: false,
              errorMessageColor: Theme.of(context).primaryColor,
              showErrorImage: true,
              errorMessage: AppLocalization.of(context)!.getTranslatedValues(
                convertErrorCodeToLanguageKey(state.errorMessage),
              ),
              onTapRetry: () {
                context.read<DevotionalsCubit>().getDevotionals(  
                    devotionalDate: date,
                    userId: context.read<UserDetailsCubit>().getUserId(),
                    );
              },
            );
          }
          final devotionalsList = (state as DevotionalsSuccess).devotionalsList;
    
    
     return Container(
       // padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
             Container(
              height: 250,
              //margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: CachedNetworkImage(
                  imageUrl: databaseUrl+'/images/devotionals/'+devotionalsList[0].thumbnail.toString(),
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
                    Img.get('devotionals.jpg'),
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: double.infinity,
                    //color: Colors.black26,
                  )),
                ),
              ),
            ),
            Container(height: 20),
             Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),

                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[ 

                    Text(devotionalsList[0].title.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyles.headline(context)
                            .copyWith(fontWeight: FontWeight.bold)),
                    Container(height: 5),
                    Text(devotionalsList[0].author.toString(),
                        textAlign: TextAlign.start,
                        style: TextStyles.subhead(context)
                            .copyWith(fontWeight: FontWeight.w500, fontSize: 18)),
                    Divider(height: 5),
                    Text(DateFormat('EEE, MMM d, yyyy').format(dateTime),
                        textAlign: TextAlign.justify,
                        style: TextStyles.subhead(context).copyWith(fontSize: 16)),
                    Container(height: 20),
                  
                    HtmlWidget(
                      devotionalsList[0].biblereading.toString(),
                      
                      textStyle: TextStyles.medium(context).copyWith(fontSize: 17),
                    ),
                    Container(height: 20),
                    HtmlWidget(
                      devotionalsList[0].content.toString(),
                       
                      textStyle: TextStyles.medium(context).copyWith(fontSize: 20),
                    ),
                    Container(height: 20),
                     Banneradmob(),
                     Container(height: 20),
                    HtmlWidget(
                      devotionalsList[0].confession.toString(),
                      
                      textStyle: TextStyles.medium(context).copyWith(fontSize: 20),
                    ),
                    Container(height: 20),
                    HtmlWidget(
                      devotionalsList[0].studies.toString(),
                      
                      textStyle: TextStyles.medium(context).copyWith(fontSize: 20),
                    ), 
                    Container(height: 20),
                    BannerAdContainer()
                    ],
               ),
           ),
          ],
        ),
      );
    });
  
}
 
