import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

class IAPService {
  IAPService({bool testStoreMode = false}) : _testStoreMode = testStoreMode;

  final bool _testStoreMode;

  late final _testPurchaseStreamController =
      StreamController<List<PurchaseDetails>>.broadcast();

  void simulatePurchaseUpdate(List<PurchaseDetails> purchases) {
    if (_testStoreMode) {
      _testPurchaseStreamController.add(purchases);
    }
  }

  Stream<List<PurchaseDetails>> get purchaseStream {
    if (_testStoreMode) {
      return _testPurchaseStreamController.stream;
    }
    return InAppPurchase.instance.purchaseStream;
  }

  Future<ProductDetailsResponse> queryProductDetails(Set<String> productIds) {
    if (_testStoreMode) {
      final response = ProductDetailsResponse(
        productDetails: [
          for (final id in productIds)
            ProductDetails(
              id: id,
              title: 'Test Product $id',
              description: 'This is a test product with id $id',
              price: r'$0.99',
              rawPrice: 0.99,
              currencyCode: 'USD',
            ),
        ],
        notFoundIDs: [],
      );
      return Future.delayed(const Duration(milliseconds: 1500)).then((_) {
        return response;
      });
    }

    return InAppPurchase.instance.queryProductDetails(productIds);
  }

  Future<bool> buyNonConsumable({required PurchaseParam purchaseParam}) {
    if (_testStoreMode) {
      simulatePurchaseUpdate([
        PurchaseDetails(
          productID: purchaseParam.productDetails.id,
          verificationData: PurchaseVerificationData(
            localVerificationData: '',
            serverVerificationData: '',
            source: '',
          ),
          transactionDate: DateTime.now().toIso8601String(),
          status: PurchaseStatus.pending,
        ),
      ]);
      return Future.value(true);
    }
    return InAppPurchase.instance.buyNonConsumable(
      purchaseParam: purchaseParam,
    );
  }

  Future<bool> buyConsumable({required PurchaseParam purchaseParam}) {
    if (_testStoreMode) {
      simulatePurchaseUpdate([
        PurchaseDetails(
          productID: purchaseParam.productDetails.id,
          verificationData: PurchaseVerificationData(
            localVerificationData: '',
            serverVerificationData: '',
            source: '',
          ),
          transactionDate: DateTime.now().toIso8601String(),
          status: PurchaseStatus.purchased,
        ),
      ]);
      return Future.value(true);
    }
    return InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
  }

  Future<void> completePurchase(PurchaseDetails purchaseDetails) {
    if (_testStoreMode) {
      return Future.value();
    }
    return InAppPurchase.instance.completePurchase(purchaseDetails);
  }

  Future<void> restorePurchases() {
    if (_testStoreMode) {
      return Future.value();
    }

    return InAppPurchase.instance.restorePurchases();
  }

  void openIOSCodeRedemptionSheet() {
    if (_testStoreMode) {
      return;
    }
    InAppPurchase.instance
        .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>()
        .presentCodeRedemptionSheet();
  }
}
