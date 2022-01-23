import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:trust_wallet/wallets/base_wallet.dart';
import 'package:trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:trust_wallet_core/trust_wallet_core_ffi.dart';

class Ethereum extends BaseWallet {
  final HDWallet wallet;

  const Ethereum(this.wallet,{Key? key}) : super('Ethereum',key: key);

  @override
  _EthereumState createState() => _EthereumState();
}

class _EthereumState extends BaseWalletState<Ethereum> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logger.d("mnemonic: ${widget.wallet.mnemonic()}");
    logger.d("address: ${widget.wallet.getAddressForCoin(TWCoinType.TWCoinTypeEthereum)}");
    final publicKey = widget.wallet.getKeyForCoin(TWCoinType.TWCoinTypeEthereum).getPublicKeySecp256k1(false);
    AnyAddress anyAddress = AnyAddress.createWithPublicKey(publicKey, TWCoinType.TWCoinTypeEthereum);
    logger.d("address from any address: ${anyAddress.description()}");
    print(widget.wallet.mnemonic());
    String privateKeyhex = hex.encode(widget.wallet.getKeyForCoin(TWCoinType.TWCoinTypeEthereum).data());
    logger.d("privateKeyhex: $privateKeyhex");
    logger.d("seed = ${hex.encode(widget.wallet.seed())}");
    final keystore = StoredKey.importPrivateKey(widget.wallet.getKeyForCoin(TWCoinType.TWCoinTypeEthereum).data(), "name", "password", TWCoinType.TWCoinTypeEthereum);
    logger.d("keystore: ${keystore?.exportJson()}");
  }
}
