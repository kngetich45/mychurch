import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/profileManagement/cubits/userDetailsCubit.dart';
import '../../features/profileManagement/models/userProfile.dart';
import '../../utils/Alerts.dart'; 
import '../../features/providers/SubscriptionProvider.dart';
import 'package:in_app_purchase/in_app_purchase.dart'; 
import '../../i18n/strings.g.dart';

class SubscriptionScreen extends StatefulWidget {
  static const routeName = "/subscriptionscreen";
  @override
  State<SubscriptionScreen> createState() => _MyAppState();
   static Route<dynamic> route(RouteSettings routeSettings){ 
       return CupertinoPageRoute(
        builder: (_) => MultiProvider(
                providers: [ 
                        ChangeNotifierProvider<SubscriptionProvider>(
                          create: (context) => SubscriptionProvider(),
                        ), 
                          
                     // ChangeNotifierProvider.value(value: BibleProvider()),
                      ],
              child: SubscriptionScreen(),
            ));
  }



}

class _MyAppState extends State<SubscriptionScreen> {
  late SubscriptionProvider subscriptionModel;

  @override
  Widget build(BuildContext context) {
    subscriptionModel = Provider.of<SubscriptionProvider>(context); 
     UserProfile userdata = context.read<UserDetailsCubit>().getUserProfile();
    List<Widget> stack = [];
    if (subscriptionModel.queryProductError == null) {
      stack.add(
        ListView(
          children: [
            _buildConnectionCheckTile(),
            _buildProductList(userdata),
          ],
        ),
      );
    } else {
      stack.add(Center(
        child: Text(subscriptionModel.queryProductError!),
      ));
    }
    if (subscriptionModel.purchasePending) {
      stack.add(
        Stack(
          children: [
            Opacity(
              opacity: 0.3,
              child: const ModalBarrier(dismissible: false, color: Colors.grey),
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.subscriptions),
      ),
      body: Stack(
        children: stack,
      ),
    );
  }

  Card _buildConnectionCheckTile() {
    if (subscriptionModel.loading) {
      return Card(child: ListTile(title: const Text('Trying to connect...')));
    }
    final List<Widget> children = <Widget>[];

    if (!subscriptionModel.isAvailable) {
      children.addAll([
        Divider(),
        ListTile(
          title: Text('Not connected',
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: const Text(
              'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
        ),
      ]);
    }
    return Card(child: Column(children: children));
  }

  Card _buildProductList(UserProfile? userdata) {
    if (subscriptionModel.loading) {
      return Card(
          child: (ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching Subscription plans...'))));
    }
    if (!subscriptionModel.isAvailable) {
      return Card();
    }
    final ListTile productHeader = ListTile(title: Text('Subscription Plans'));
    List<ListTile> productList = <ListTile>[];
    if (subscriptionModel.notFoundIds.isNotEmpty) {
      productList.add(ListTile(
          title: Text('[${subscriptionModel.notFoundIds.join(", ")}] not found',
              style: TextStyle(color: ThemeData.light().errorColor)),
          subtitle: Text(
              'Before you can see subscription plans, make sure you have create the different subscription plans and have published atleast a test app on Google Play Store.')));
    }

    // This loading previous purchases code is just a demo. Please do not use this as it is.
    // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
    // We recommend that you use your own server to verity the purchase data.
    Map<String, PurchaseDetails> purchases = Map.fromEntries(
        subscriptionModel.userPurchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        //InAppPurchaseConnection.instance.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
    productList.addAll(subscriptionModel.products.map(
      (ProductDetails productDetails) {
        PurchaseDetails? previousPurchase = purchases[productDetails.id];
        return ListTile(
            title: Text(
              productDetails.title,
            ),
            subtitle: Text(
              productDetails.description,
            ),
            trailing: previousPurchase != null
                ? Icon(Icons.check)
                : TextButton(
                    child: Text(productDetails.price),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      primary: Colors.white,
                    ),
                    onPressed: () {
                      if (userdata == null) {
                        Alerts.subscriptionloginrequiredhint(context);
                      } else {
                       // PurchaseParam purchaseParam = PurchaseParam(
                        //  productDetails: productDetails,
                        //  applicationUserName: null,
                       // );
                      }
                    },
                  ));
      },
    ));

    return Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Column(
              children: <Widget>[productHeader, Divider()] + productList),
        ));
  }

  void showPendingUI() {
    setState(() {
      subscriptionModel.purchasePending = true;
    });
  }
}
