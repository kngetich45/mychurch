import 'package:bevicschurch/features/mediaPlayers/models/MediaPlayerModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../app/routes.dart';
import '../../../../features/providers/AudioPlayerProvider.dart';
import '../../../../features/providers/SubscriptionProvider.dart';
import '../../../../utils/Alerts.dart';
import '../../../../utils/TimUtil.dart';
import '../../../../utils/Utility.dart';
import '../../../styles/TextStyles.dart'; 
import 'package:cached_network_image/cached_network_image.dart'; 
import '../../../widgets/MediaPopupMenu.dart'; 

class MediaItemVideoTile extends StatefulWidget {
  final MediaPlayerModel object;
  final List<MediaPlayerModel> mediaList;
  final int index;

  const MediaItemVideoTile({
    Key? key,
    required this.mediaList,
    required this.index,
    required this.object,
  }) : super(key: key);

  @override
  _MediaItemTileState createState() => _MediaItemTileState();
  
}

class _MediaItemTileState extends State<MediaItemVideoTile> {
  @override
  Widget build(BuildContext context) {
    bool isSubscribed = Provider.of<SubscriptionProvider>(context).isSubscribed;
     Provider.of<AudioPlayerProvider>(context, listen: false).setContext(context);
     Provider.of<AudioPlayerProvider>(context, listen: false).setStreamController(0);
    return InkWell(
      onTap: () {
        if (Utility.isMediaRequireUserSubscription(
            widget.object, isSubscribed)) {
          Alerts.showPlaySubscribeAlertDialog(context);
          return;
        }
        if (widget.object.mediaType!.toLowerCase() == "audio") {

          
          Provider.of<AudioPlayerProvider>(context, listen: false).preparePlaylist(
              Utility.extractMediaByType(
                  widget.mediaList, widget.object.mediaType),
              widget.object);
          Navigator.of(context).pushNamed(Routes.playPage);


        } else {
          Navigator.of(context).pushNamed(Routes.videoplayer, 
              arguments: {
                "position": 0,
                "items": widget.object,
                "itemsList": Utility.extractMediaByType(
                    widget.mediaList, widget.object.mediaType),
              });
        }
      },
      child: Container(
        height: 130,
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(15, 5, 10, 5),
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
                        width: 80,
                        child: CachedNetworkImage(
                          imageUrl: widget.object.coverPhoto!,
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
                              child: Icon(
                            Icons.error,
                            color: Colors.grey,
                          )),
                        ),
                      )),
                  Container(width: 10),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 4, 0, 10),
                          child: Row(
                            children: <Widget>[
                              Text(widget.object.category!,
                                  style: TextStyles.caption(context)
                                  //.copyWith(color: MyColors.grey_60),
                                  ),
                              Spacer(),
                              Text(
                                  TimUtil.timeFormatter(
                                      widget.object.duration!),
                                  style: TextStyles.caption(context)
                                  //.copyWith(color: MyColors.grey_60),
                                  ),
                            ],
                          ),
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(widget.object.title!,
                                maxLines: 2,
                                style: TextStyles.subhead(context).copyWith(
                                    //color: MyColors.grey_80,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                        
                        Row(
                          children: <Widget>[
                            widget.object.viewsCount == 0
                                ? Container()
                                : Text(
                                    widget.object.viewsCount.toString() +
                                        " view(s)",
                                    style: TextStyles.caption(context)
                                    //.copyWith(color: MyColors.grey_60),
                                    ),
                            Spacer(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: MediaPopupMenu(widget.object),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 0,
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
