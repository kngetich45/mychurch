import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:package_info/package_info.dart';
import 'package:share_plus/share_plus.dart';
import '../../features/mediaPlayers/models/MediaPlayerModel.dart';
import '../../features/providers/BookmarksProvider.dart';
import '../../features/providers/DownloadsProvider.dart'; 
import '../../../features/models/ScreenArguements.dart';
import '../../features/models/Downloads.dart';
import '../screens/Downloader.dart';
import '../../i18n/strings.g.dart'; 

enum MenuIndex { DOWNLOAD, DELETE, PLAYLIST, BOOKMARK, UNBOOKMARK, SHARE }

class MenuList {
  MenuList({
    this.index,
    this.title = '',
  });

  String title;
  MenuIndex? index;
}

class MediaPopupMenu extends StatelessWidget {
  MediaPopupMenu(this.media, {this.isDownloads});
  final MediaPlayerModel? media;
  final isDownloads;

  @override
  Widget build(BuildContext context) {
    BookmarksProvider bookmarksModel = Provider.of<BookmarksProvider>(context);
    DownloadsProvider downloadsModel = Provider.of<DownloadsProvider>(context);

    return PopupMenuButton(
      elevation: 3.2,
      //initialValue: choices[1],
      itemBuilder: (BuildContext context) {
        bool isBookmarked = bookmarksModel.isMediaBookmarked(media);
        List<MenuList> choices = [];
        if (media!.canDownload! && media!.videoType == "mp4_video") {
          choices
              .add(new MenuList(title: t.download, index: MenuIndex.DOWNLOAD));
        }
        if (isDownloads != null &&
            downloadsModel.isMediaInDownloads(media!.id)!.status ==
                DownloadTaskStatus.complete) {
          choices
              .add(new MenuList(title: t.deletemedia, index: MenuIndex.DELETE));
        }
        choices
            .add(new MenuList(title: t.addplaylist, index: MenuIndex.PLAYLIST));
        if (isBookmarked) {
          choices.add(
              new MenuList(title: t.unbookmark, index: MenuIndex.UNBOOKMARK));
        } else {
          choices
              .add(new MenuList(title: t.bookmark, index: MenuIndex.BOOKMARK));
        }
        choices.add(new MenuList(title: t.share, index: MenuIndex.SHARE));
        return choices.map((itm) {
          return PopupMenuItem(
            value: itm,
            child: Text(itm.title),
          );
        }).toList();
      },
      //initialValue: 2,
      onCanceled: () {
        print("You have canceled the menu.");
      },
      onSelected: (dynamic value) {
        MenuList itm = (value as MenuList);
        print(value);
        switch (itm.index) {
          case MenuIndex.DOWNLOAD:
           // downloadFIle(context, media!);
            break;
          case MenuIndex.DELETE:
            downloadsModel.removeDownloadedMedia(context, media!.id);
            break;
          case MenuIndex.PLAYLIST:
           /*  Navigator.pushNamed(
              context,
              AddPlaylistScreen.routeName,
              arguments: ScreenArguements(position: 0, items: media),
            ); */
            break;
          case MenuIndex.BOOKMARK:
            bookmarksModel.bookmarkMedia(media!);
            break;
          case MenuIndex.UNBOOKMARK:
            bookmarksModel.unBookmarkMedia(media!);
            break;
          case MenuIndex.SHARE:
            ShareFile.share(media!);
            break;
          default:
        }
      },
      icon: Icon(
        Icons.more_vert,
        color: Colors.grey[500],
      ),
    );
  }

  downloadFIle(BuildContext context, MediaPlayerModel media) {
    Downloads downloads = Downloads.mapCurrentDownloadMedia(media);
    Navigator.pushNamed(context, Downloader.routeName,
        arguments: ScreenArguements(
          position: 0,
          items: downloads,
        ));
  }
}

class ShareFile {
  static share(MediaPlayerModel media) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;
    if (media.http!) {
      await Share.share(
        t.sharefiletitle +
            media.title! +
            "\n" +
            t.sharefilebody +
            " http://play.google.com/store/apps/details?id=" +
            packageName,
        subject: t.sharefiletitle + media.title!,
      );
    } else {
      // ignore: deprecated_member_use
      await Share.shareFiles(
        [media.streamUrl!],
        text: t.sharefilebody +
            " http://play.google.com/store/apps/details?id=" +
            packageName,
        subject: t.sharefiletitle + media.title!,
      );
    }
  }
}
