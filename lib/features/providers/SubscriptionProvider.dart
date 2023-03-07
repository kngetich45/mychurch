import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionProvider with ChangeNotifier {
  List<String> notFoundIds = [];
  List<ProductDetails> products = [];
  List<PurchaseDetails> userPurchases = [];
  bool isAvailable = false;
  bool purchasePending = false;
  bool loading = true;
  String? queryProductError;
  bool isSubscribed = false;

  SubscriptionProvider() {
    initInAppPurchases();
  }

  //inapp purchases
  initInAppPurchases() {
    /*Stream purchaseUpdated =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      subscription.cancel();
    }, onError: (error) {
      // handle error here.
    }) as StreamSubscription<List<PurchaseDetails>>;
    initStoreInfo();*/
  }
}