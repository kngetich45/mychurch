import 'dart:io';

import 'package:bevicschurch/ui/styles/colors.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launch_review/launch_review.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/routes.dart';
import '../../../../features/profileManagement/cubits/userDetailsCubit.dart';
import '../../../../features/systemConfig/cubits/systemConfigCubit.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/uiUtils.dart';
import '../../../styles/TextStyles.dart'; 

class BuildDrawer extends StatelessWidget {
  const BuildDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
 
    return Drawer(
      backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          
          children: [
              UserAccountsDrawerHeader(
              
              currentAccountPicture:
             /*  Image.asset(UiUtils.getImagePath("splash_logo.png")),   */ 
              CircleAvatar(
                
                backgroundImage: NetworkImage(
                      context.read<UserDetailsCubit>().getUserProfile().profileUrl!.toString()
                      ),
                      
              ),  
              accountEmail: Text(context.read<UserDetailsCubit>().getUserEmail()!),
              accountName: Text(
                context.read<UserDetailsCubit>().getUserName(),
                style: TextStyle(fontSize: 24.0),
              ),
              decoration: BoxDecoration(
                 color: Color(0xFFFF0080),
              ),
            ),
            ListTile(
              leading: Icon(Icons.house, color: primaryColor),
              title:  Text(
                'Dashboard',
                style: TextStyles.subhead(context).copyWith(
                                      fontSize: 18,
                                    )
              ),
              onTap: () {
                 Navigator.of(context).pop();
                 Navigator.of(context).pushNamed(Routes.dashboard);
              },
            ), 
             
            ListTile(
              leading: Icon(Icons.account_balance_wallet, color: primaryColor),
              title:   Text(
                'Wallet',
                style: TextStyles.subhead(context).copyWith(
                                        fontSize: 18,
                                    )
              ),
              onTap: () {
                 Navigator.of(context).pop();
                 Navigator.of(context).pushNamed(Routes.wallet);
              },
            ),
          
          ListTile(
              leading: Icon(Icons.savings, color: primaryColor),
              title:   Text(
                'Coin History',
                style: TextStyles.subhead(context).copyWith(
                                        fontSize: 18,
                                    )
              ),
              onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(Routes.coinHistory);
              },
            ),

            ListTile(
              leading: Icon(Icons.verified, color: primaryColor),
              title:   Text(
                'Badges',
                style: TextStyles.subhead(context).copyWith(
                                        fontSize: 18,
                                    )
              ),
              onTap: () {
                 Navigator.of(context).pop();
                 Navigator.of(context).pushNamed(Routes.badges);
              },
            ),

             ListTile(
              leading: Icon(Icons.emoji_events, color: primaryColor),
              title:   Text(
                'Rewards',
                style: TextStyles.subhead(context).copyWith(
                                        fontSize: 18,
                                    )
              ),
              onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(Routes.rewards);
              },
            ),
              ListTile(
              leading: Icon(Icons.notifications, color: primaryColor),
              title:   Text(
                'Notification',
                style: TextStyles.subhead(context).copyWith(
                                        fontSize: 18,
                                    )
              ),
              onTap: () {
                  Navigator.of(context).pop(); 
                Navigator.of(context).pushNamed(Routes.notification);
              },
            ),
              ListTile(
              leading: Icon(Icons.account_circle, color: primaryColor),
              title:   Text(
                'Account',
                style: TextStyles.subhead(context).copyWith(
                                        fontSize: 18,
                                    )
              ),
              onTap: () {
                  Navigator.of(context).pop(); 
                  Navigator.of(context).pushNamed(Routes.profile);
              },
            ),


              const Divider(height: 1, color: Colors.grey),

             ListTile(
              leading: Icon(Icons.help, color: primaryColor),
              title:   Text(
                'How to Play',
                style: TextStyles.subhead(context).copyWith(
                                        fontSize: 18,
                                    )
              ),
              onTap: () {
                 Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamed(Routes.appSettings, arguments: "How to Play");
              },
            ),

 

           ListTile(
              leading: Icon(Icons.info, color: primaryColor),
              onTap: () {
                Navigator.of(context).pop();

                Navigator.of(context).pushNamed(Routes.aboutApp);
              },
              title: Text("About Us",
              style: TextStyles.subhead(context).copyWith(
                                        fontSize: 18,
                                    )),
               //theme icon
            ),

            ListTile(
               leading: Icon(Icons.rate_review, color: primaryColor),
              onTap: () {
                Navigator.of(context).pop();
                LaunchReview.launch(
                  androidAppId: packageName,
                  iOSAppId: "585027354",
                );
              },
              title: Text("Rate Us",
              style: TextStyles.subhead(context).copyWith(
                                        fontSize: 18,
                                    )), 
              //theme icon
            ),

            ListTile(
             leading: Icon(Icons.share, color: primaryColor),
              onTap: () {
                Navigator.of(context).pop();
                try {
                  if (Platform.isAndroid) {
                    Share.share(context.read<SystemConfigCubit>().getAppUrl() +
                        "\n" +
                        context
                            .read<SystemConfigCubit>()
                            .getSystemDetails()
                            .shareappText);
                  } else {
                    Share.share(context.read<SystemConfigCubit>().getAppUrl() +
                        "\n" +
                        context
                            .read<SystemConfigCubit>()
                            .getSystemDetails()
                            .shareappText);
                  }
                } catch (e) {
                  UiUtils.setSnackbar(e.toString(), context, false);
                }
              },
              title: Text("Share App",
              style: TextStyles.subhead(context).copyWith(
                                        fontSize: 18,
                                    )),
              //theme icon
            ),




          ],
        ),
      );
  }
 
}