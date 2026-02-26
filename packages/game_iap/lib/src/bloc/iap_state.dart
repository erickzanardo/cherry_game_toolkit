part of 'iap_cubit.dart';

class PurchaseInProgress extends Equatable {
  const PurchaseInProgress({required this.productId, required this.status});

  final String productId;
  final PurchaseStatus status;

  PurchaseInProgress copyWith({String? productId, PurchaseStatus? status}) {
    return PurchaseInProgress(
      productId: productId ?? this.productId,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [productId, status];
}

class IapState extends Equatable {
  const IapState({
    required this.purchases,
    this.purchaseTarget,
    this.targetIsConsumable,
    this.inProgress,
    this.restoreInProgress = false,
    this.lastDialogShownAt,
  });

  final List<String> purchases;
  final ProductDetails? purchaseTarget;
  final bool? targetIsConsumable;
  final PurchaseInProgress? inProgress;
  final bool restoreInProgress;
  final DateTime? lastDialogShownAt;

  IapState copyWith({
    List<String>? purchases,
    ProductDetails? purchaseTarget,
    bool? targetIsConsumable,
    PurchaseInProgress? inProgress,
    bool? restoreInProgress,
    DateTime? lastDialogShownAt,
    bool clearPurchaseTarget = false,
    bool clearTargetIsConsumable = false,
    bool clearInProgress = false,
  }) {
    return IapState(
      purchases: purchases ?? this.purchases,
      purchaseTarget: clearPurchaseTarget
          ? null
          : (purchaseTarget ?? this.purchaseTarget),
      targetIsConsumable: clearTargetIsConsumable
          ? null
          : (targetIsConsumable ?? this.targetIsConsumable),
      inProgress: clearInProgress ? null : (inProgress ?? this.inProgress),
      restoreInProgress: restoreInProgress ?? this.restoreInProgress,
      lastDialogShownAt: lastDialogShownAt ?? this.lastDialogShownAt,
    );
  }

  @override
  List<Object?> get props => [
    purchases,
    purchaseTarget,
    targetIsConsumable,
    inProgress,
    restoreInProgress,
    lastDialogShownAt,
  ];
}
