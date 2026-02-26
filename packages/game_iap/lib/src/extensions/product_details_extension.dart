import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

extension ProductDetailsExtension on ProductDetails {
  String? get discount {
    if (this is AppStoreProductDetails) {
      final appStoreDetails = this as AppStoreProductDetails;
      final introductoryPrice = appStoreDetails.skProduct.introductoryPrice;
      if (introductoryPrice != null) {
        return '$currencySymbol${introductoryPrice.price}';
      }
    } else if (this is GooglePlayProductDetails) {
      final googleDetails = this as GooglePlayProductDetails;
      final subscriptionIndex = googleDetails.subscriptionIndex;
      if (subscriptionIndex != null) {
        final offerDetails =
            googleDetails.productDetails.subscriptionOfferDetails;
        if (offerDetails != null && offerDetails.isNotEmpty) {
          final phases = offerDetails[subscriptionIndex].pricingPhases;
          if (phases.length > 1 &&
              phases.first.priceAmountMicros < phases.last.priceAmountMicros) {
            return phases.first.formattedPrice;
          }
        }
      }
    }
    return null;
  }
}
