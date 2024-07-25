import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/infrastructure/service/token_service.dart';
import 'package:teja/presentation/onboarding/widgets/authenticate.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/storage/secure_storage.dart';

enum FeatureTab { free, paid }

class FeatureAccessBottomSheet extends StatefulWidget {
  final FeatureTab initialTab;

  const FeatureAccessBottomSheet({Key? key, this.initialTab = FeatureTab.free})
      : super(key: key);

  @override
  _FeatureAccessBottomSheetState createState() =>
      _FeatureAccessBottomSheetState();
}

class _FeatureAccessBottomSheetState extends State<FeatureAccessBottomSheet> {
  final InAppPurchase _iap = InAppPurchase.instance;
  bool _available = true;
  final TokenService _tokenService = TokenService();
  final SecureStorage _secureStorage = SecureStorage();

  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  final List<String> _kProductIDs = [
    'app.teja.subscription.all',
    'app.teja.subscription.monthly',
    'test.teja.subscription.pro'
  ];

  @override
  void initState() {
    super.initState();
    _initializeIAP();
  }

  Future<void> _initializeIAP() async {
    final bool available = await _iap.isAvailable();
    setState(() {
      _available = available;
    });

    if (_available) {
      final Set<String> kIds = _kProductIDs.toSet();
      print('Product IDs: $kIds');

      // final ProductDetailsResponse response =
      //     await _iap.queryProductDetails(kIds);
      try {
        final ProductDetailsResponse response =
            await _iap.queryProductDetails(kIds);
        if (response.error != null) {
          // Handle the error
          print('Error querying product details: ${response.error}');
        } else {
          print('Product details: ${response.productDetails}');
          setState(() {
            _products = response.productDetails;
          });
        }
      } catch (e) {
        print('Error querying product details: $e');
      }
    }

    _iap.purchaseStream.listen((List<PurchaseDetails> purchases) {
      _handlePurchaseUpdates(purchases);
    });
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (var purchase in purchases) {
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
      if (purchase.status == PurchaseStatus.purchased) {
        // Verify the purchase and grant the feature
        // You might want to call your backend here to verify the purchase
        final refreshToken = await _secureStorage.readRefreshToken();
        await _tokenService.getMeDetails(refreshToken!);
      }
    }
    setState(() {
      _purchases = purchases;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (store) => store,
      builder: (context, store) {
        final bool hasExistingMnemonic =
            store.state.authState.hasExistingMnemonic;
        final ThemeData theme = Theme.of(context);
        final textTheme = theme.textTheme;

        return DefaultTabController(
          length: 2, // Number of tabs
          initialIndex: widget.initialTab == FeatureTab.free ? 0 : 1,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: theme
                  .scaffoldBackgroundColor, // Use the theme's background color
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Adjust size to content
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Feature Locked',
                      style: textTheme.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const TabBar(
                  tabs: [
                    Tab(text: 'Free'),
                    Tab(text: 'Paid'),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildFreeTab(context, hasExistingMnemonic),
                      _buildPaidTab(context, hasExistingMnemonic),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFreeTab(BuildContext context, bool hasExistingMnemonic) {
    final ThemeData theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('You do not have access to this free feature.',
            style: textTheme.bodyMedium),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.center,
          child: hasExistingMnemonic
              ? Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    Text('Already Registered', style: textTheme.bodyMedium),
                  ],
                )
              : ElevatedButton(
                  onPressed: () {
                    _onRegisterPressed();
                  },
                  child: const Text('Register'),
                ),
        ),
      ],
    );
  }

  Widget _buildPaidTab(BuildContext context, bool hasExistingMnemonic) {
    final ThemeData theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('You do not have access to this paid feature.',
            style: textTheme.bodyMedium),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.center,
          child: hasExistingMnemonic
              ? ElevatedButton(
                  onPressed: () {
                    _buyProduct(_kProductIDs[0]);
                  },
                  child: const Text('Purchase All'),
                )
              : Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _onRegisterPressed();
                      },
                      child: const Text('Register'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _buyProduct(_kProductIDs[1]);
                      },
                      child: const Text('Purchase Monthly'),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  void _buyProduct(String productId) {
    try {
      if (_products.isEmpty) {
        throw Exception('Product details are not loaded yet.');
      }
      final ProductDetails product =
          _products.firstWhere((product) => product.id == productId);
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: product);
      _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      // Handle the error
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Product not found. Please try again later.')),
      );
    }
  }

  void _onRegisterPressed() {
    register(context, () {
      Future.delayed(const Duration(seconds: 3), () {
        GoRouter.of(context).pushNamed(RootPath.registration);
      });
    });
  }
}
