import 'package:flutter/material.dart';
import 'package:trust_wallet/wallets/bitcoin_transaction.dart';
import 'package:trust_wallet/wallets/ethereum.dart';
import 'package:trust_wallet/wallets/private_key_validation.dart';
import 'package:trust_wallet/wallets/tron.dart';
import 'package:trust_wallet/wallets/bitcoin_address.dart' as bitcoin;
import 'package:trust_wallet_core/flutter_trust_wallet_core.dart';

List<String> logs = [];

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Example(),
    );
  }
}

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  late HDWallet wallet;

  @override
  void initState() {
    FlutterTrustWalletCore.init();
    super.initState();
    String mnemonic = "rent craft script crucial item someone dream federal notice page shrug pipe young hover duty"; // 有测试币的 tron地址
    wallet = HDWallet.createWithMnemonic(mnemonic);
  }

  Widget _exampleItem({
    required String name,
    required WidgetBuilder builder,
  }) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: builder));
      },
      child: Text(name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('wallet core example app'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Text(wallet.mnemonic()),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _exampleItem(
                    name: 'Ethereum',
                    builder: (_) {
                      return Ethereum(wallet);
                    },
                  ),
                  _exampleItem(
                    name: 'Bitcoin Address',
                    builder: (_) {
                      return bitcoin.BitcoinAddress(wallet);
                    },
                  ),
                  _exampleItem(
                    name: 'Bitcoin Transaction',
                    builder: (_) {
                      return BitcoinTransaction(wallet);
                    },
                  ),
                  _exampleItem(
                    name: 'Tron',
                    builder: (_) {
                      return Tron(wallet);
                    },
                  ),
                  _exampleItem(
                    name: 'PrivateKey.isValid(a,b)',
                    builder: (_) {
                      return PrivateKeyValidation(wallet);
                    },
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                wallet.delete();
                wallet = HDWallet();
                setState(() {});
              },
              child: Text("gen"),
            ),
          ],
        ),
      ),
    );
  }
}