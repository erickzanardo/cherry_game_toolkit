import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:game_iap/src/iap_service.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

part 'iap_state.dart';

class IapCubit extends HydratedCubit<IapState> {
  IapCubit({required IAPService iapService, String? noAdsProductId})
    : _iapService = iapService,
      _noAdsProductId = noAdsProductId,
      super(const IapState(purchases: [])) {
    _purchaseSubscription = _iapService.purchaseStream.listen(
      _listenToPurchaseUpdated,
    );
  }

  final IAPService _iapService;
  final String? _noAdsProductId;

  late final StreamSubscription<List<PurchaseDetails>> _purchaseSubscription;

  void resetInProgress() {
    emit(
      state.copyWith(
        clearInProgress: true,
        restoreInProgress: false,
        clearTargetIsConsumable: true,
        clearPurchaseTarget: true,
      ),
    );
  }

  Future<void> _listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        emit(
          state.copyWith(
            inProgress: PurchaseInProgress(
              productId: purchaseDetails.productID,
              status: PurchaseStatus.pending,
            ),
          ),
        );
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          emit(
            state.copyWith(
              inProgress: PurchaseInProgress(
                productId: purchaseDetails.productID,
                status: PurchaseStatus.error,
              ),
            ),
          );
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          emit(
            state.copyWith(
              inProgress: PurchaseInProgress(
                productId: purchaseDetails.productID,
                status: PurchaseStatus.canceled,
              ),
            ),
          );
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          if (purchaseDetails.pendingCompletePurchase) {
            await _iapService.completePurchase(purchaseDetails);
          }
          final updatedPurchases = List<String>.from(state.purchases);
          if (!updatedPurchases.contains(purchaseDetails.productID)) {
            updatedPurchases.add(purchaseDetails.productID);
          }
          final newState = state.copyWith(
            purchases: updatedPurchases,
            restoreInProgress: false,
            inProgress: PurchaseInProgress(
              productId: purchaseDetails.productID,
              status: PurchaseStatus.purchased,
            ),
          );

          emit(newState);
        }
      }
    }
  }

  Future<void> requestProductTarget({
    required String productId,
    required bool consumable,
  }) async {
    final response = await _iapService.queryProductDetails({productId});

    if (response.notFoundIDs.isNotEmpty) {
      return;
    }

    final productDetails = response.productDetails.first;

    emit(
      state.copyWith(
        purchaseTarget: productDetails,
        targetIsConsumable: consumable,
      ),
    );
  }

  Future<void> requestPurchase() async {
    final productDetails = state.purchaseTarget;
    if (productDetails == null) {
      return;
    }

    final consumable = state.targetIsConsumable;
    if (consumable == null) {
      return;
    }

    final purchaseParam = PurchaseParam(productDetails: productDetails);

    late final bool result;

    if (consumable) {
      result = await _iapService.buyConsumable(purchaseParam: purchaseParam);
    } else {
      result = await _iapService.buyNonConsumable(purchaseParam: purchaseParam);
    }
    if (result) {
      emit(
        state.copyWith(
          inProgress: PurchaseInProgress(
            productId: productDetails.id,
            status: PurchaseStatus.pending,
          ),
        ),
      );
    }
  }

  Future<void> restorePurchases() {
    emit(state.copyWith(restoreInProgress: true));
    return _iapService.restorePurchases();
  }

  bool userHasNoAds() {
    if (_noAdsProductId == null) return false;
    return state.purchases.contains(_noAdsProductId);
  }

  void updateLastDialogShownAt(DateTime dateTime) {
    emit(state.copyWith(lastDialogShownAt: dateTime));
  }

  void forceLastPurchaseDialog() {
    emit(
      state.copyWith(
        lastDialogShownAt: DateTime.now().subtract(const Duration(days: 8)),
      ),
    );
  }

  @override
  IapState? fromJson(Map<String, dynamic> json) {
    final purchases =
        (json['purchases'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList() ??
        [];

    final lastDialogShownAtString = json['lastDialogShownAt'] as String?;
    final lastDialogShownAt = lastDialogShownAtString == null
        ? null
        : DateTime.tryParse(lastDialogShownAtString);

    return IapState(
      purchases: purchases,
      lastDialogShownAt: lastDialogShownAt ?? DateTime.now(),
    );
  }

  @override
  Map<String, dynamic>? toJson(IapState state) {
    return {
      'purchases': state.purchases,
      'lastDialogShownAt': state.lastDialogShownAt?.toIso8601String(),
    };
  }

  @override
  Future<void> close() {
    unawaited(_purchaseSubscription.cancel());
    return super.close();
  }
}
