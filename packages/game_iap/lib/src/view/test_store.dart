import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_iap/game_iap.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class TestStore extends StatelessWidget {
  const TestStore({required this.child, this.enabled = false, super.key});

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final iapService = context.read<IAPService>();
    if (enabled) {
      return MultiBlocListener(
        listeners: [
          BlocListener<IapCubit, IapState>(
            listenWhen: (previous, state) {
              return previous.restoreInProgress != state.restoreInProgress &&
                  state.restoreInProgress;
            },
            listener: (context, state) async {
              final products = await _RestoreDialog.show(context);
              if (products != null) {
                for (final productId in products) {
                  iapService.simulatePurchaseUpdate([
                    PurchaseDetails(
                      productID: productId,
                      verificationData: PurchaseVerificationData(
                        localVerificationData: '',
                        serverVerificationData: '',
                        source: '',
                      ),
                      transactionDate: DateTime.now().toIso8601String(),
                      status: PurchaseStatus.restored,
                    )..pendingCompletePurchase = true,
                  ]);
                }
              }
            },
          ),
          BlocListener<IapCubit, IapState>(
            listenWhen: (previous, state) {
              return previous.inProgress != state.inProgress &&
                  state.inProgress != null &&
                  state.inProgress?.status == PurchaseStatus.pending;
            },
            listener: (context, state) async {
              await Future<void>.delayed(const Duration(milliseconds: 1000));
              await showDialog<void>(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: SizedBox(
                      height: 280,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 16,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                iapService.simulatePurchaseUpdate([
                                  PurchaseDetails(
                                    productID: state.inProgress!.productId,
                                    verificationData: PurchaseVerificationData(
                                      localVerificationData: '',
                                      serverVerificationData: '',
                                      source: '',
                                    ),
                                    transactionDate: DateTime.now()
                                        .toIso8601String(),
                                    status: PurchaseStatus.purchased,
                                  )..pendingCompletePurchase = true,
                                ]);
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Simulate Success',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                iapService.simulatePurchaseUpdate([
                                  PurchaseDetails(
                                    productID: state.inProgress!.productId,
                                    verificationData: PurchaseVerificationData(
                                      localVerificationData: '',
                                      serverVerificationData: '',
                                      source: '',
                                    ),
                                    transactionDate: DateTime.now()
                                        .toIso8601String(),
                                    status: PurchaseStatus.error,
                                  ),
                                ]);
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Simulate Failure',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                iapService.simulatePurchaseUpdate([
                                  PurchaseDetails(
                                    productID: state.inProgress!.productId,
                                    verificationData: PurchaseVerificationData(
                                      localVerificationData: '',
                                      serverVerificationData: '',
                                      source: '',
                                    ),
                                    transactionDate: DateTime.now()
                                        .toIso8601String(),
                                    status: PurchaseStatus.canceled,
                                  ),
                                ]);
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Simulate Cancelation',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
        child: child,
      );
    }

    return child;
  }
}

class _RestoreDialog extends StatefulWidget {
  static Future<List<String>?> show(BuildContext context) {
    return showDialog<List<String>>(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _RestoreDialog(),
        ),
      ),
    );
  }

  @override
  State<_RestoreDialog> createState() => _RestoreDialogState();
}

class _RestoreDialogState extends State<_RestoreDialog> {
  late final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        spacing: 16,
        children: [
          const Text(
            'Type the product ids to be restored, separated by commas.',
          ),
          TextField(
            controller: _controller,
            maxLines: 5,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'e.g. test_product_1, test_product_2',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final input = _controller.text;
              final productIds = input
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();
              Navigator.of(context).pop(productIds);
            },
            child: const Text('Simulate Restored Purchases'),
          ),
        ],
      ),
    );
  }
}
