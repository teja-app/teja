import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/token/token_actions.dart';
import 'package:teja/shared/storage/secure_storage.dart';

class TokenWidget extends StatefulWidget {
  const TokenWidget({Key? key}) : super(key: key);

  @override
  _TokenWidgetState createState() => _TokenWidgetState();
}

class _TokenWidgetState extends State<TokenWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fetchTokenSummary();
    });
  }

  Future<void> _fetchTokenSummary() async {
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(const FetchTokenSummaryAction());
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, vm) {
        return Row(
          children: [
            Image.asset(
              'assets/icons/token.png',
              width: 42.0,
              height: 42.0,
            ),
            Text(
              '${vm.pending}',
              style: textTheme.bodySmall,
            ),
            const SizedBox(width: 8.0),
          ],
        );
      },
    );
  }
}

class _ViewModel {
  final int pending;

  _ViewModel({
    required this.pending,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      pending: store.state.tokenState.pending,
    );
  }
}
