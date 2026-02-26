import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_iap/game_iap.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:nes_ui/nes_ui.dart';

class PurchaseProductDialog extends StatefulWidget {
  const PurchaseProductDialog({
    required this.productId,
    this.title = 'Purchase',
    this.child,
    this.onSuccess,
    this.onError,
    this.onCanceled,
    super.key,
  });

  final String productId;
  final String title;
  final Widget? child;
  final void Function()? onSuccess;
  final void Function()? onError;
  final void Function()? onCanceled;

  static Future<PurchaseStatus?> show(
    BuildContext context, {
    required String productId,
    String title = 'Purchase',
    Widget? child,
    void Function()? onSuccess,
    void Function()? onError,
    void Function()? onCanceled,
  }) {
    final iapCubit = context.read<IapCubit>()..resetInProgress();

    unawaited(
      iapCubit.requestProductTarget(productId: productId, consumable: false),
    );

    return NesDialog.show<PurchaseStatus>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: iapCubit,
        child: PurchaseProductDialog(
          productId: productId,
          title: title,
          child: child,
          onSuccess: onSuccess,
          onError: onError,
          onCanceled: onCanceled,
        ),
      ),
    );
  }

  @override
  State<PurchaseProductDialog> createState() => _PurchaseProductDialogState();
}

class _PurchaseProductDialogState extends State<PurchaseProductDialog> {
  bool _purchaseRequested = false;

  @override
  Widget build(BuildContext context) {
    const buttonWidth = 180.0;

    return BlocConsumer<IapCubit, IapState>(
      listenWhen: (previous, state) {
        return previous.inProgress != state.inProgress;
      },
      listener: (context, state) {
        if (state.inProgress?.status == PurchaseStatus.purchased) {
          widget.onSuccess?.call();
          Navigator.of(context).pop(PurchaseStatus.purchased);
        } else if (state.inProgress?.status == PurchaseStatus.error) {
          widget.onError?.call();
          Navigator.of(context).pop(PurchaseStatus.error);
        } else if (state.inProgress?.status == PurchaseStatus.canceled) {
          widget.onCanceled?.call();
          Navigator.of(context).pop(PurchaseStatus.canceled);
        }
      },
      builder: (context, state) {
        final purchaseTarget = state.purchaseTarget;
        if (state.inProgress?.status == PurchaseStatus.pending ||
            state.restoreInProgress ||
            purchaseTarget == null) {
          return Column(
            spacing: 16,
            children: [
              Text(
                purchaseTarget == null
                    ? 'Loading product...'
                    : 'Processing purchase...',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const Divider(),
              const NesPixelRowLoadingIndicator(),
            ],
          );
        }
        return Column(
          spacing: 16,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const Divider(),
            if (widget.child != null) widget.child!,
            if (_purchaseRequested)
              const NesPixelRowLoadingIndicator()
            else ...[
              Text.rich(
                TextSpan(
                  children: [
                    if (purchaseTarget.discount case final discountPrice?) ...[
                      TextSpan(
                        text: '${purchaseTarget.price}  ',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      TextSpan(text: discountPrice),
                    ] else
                      TextSpan(text: purchaseTarget.price),
                  ],
                ),
              ),
              NesButton.text(
                buttonWidth: buttonWidth,
                type: NesButtonType.primary,
                text: 'Buy',
                onPressed: () {
                  setState(() {
                    _purchaseRequested = true;
                  });
                  context.read<IapCubit>().requestPurchase();
                },
              ),
              NesButton.text(
                buttonWidth: buttonWidth,
                type: NesButtonType.normal,
                text: 'Restore',
                onPressed: () {
                  context.read<IapCubit>().restorePurchases();
                },
              ),
              if (Platform.isIOS)
                NesLink(
                  label: 'Redeem Code',
                  onPressed: () {
                    context.read<IAPService>().openIOSCodeRedemptionSheet();
                  },
                ),
            ],
          ],
        );
      },
    );
  }
}
