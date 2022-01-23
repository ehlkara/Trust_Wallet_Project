import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:trust_wallet/wallets/WIF.dart';
import 'package:trust_wallet/wallets/base_wallet.dart';
import 'package:trust_wallet_core/flutter_trust_wallet_core.dart' as Bitcoin;
import 'package:trust_wallet_core/trust_wallet_core_ffi.dart';

class BitcoinAddress extends BaseWallet {
  final Bitcoin.HDWallet wallet;
  const BitcoinAddress(this.wallet,{Key? key}) : super('Bitcoin Address',key: key);

  @override
  _BitcoinAddressState createState() => _BitcoinAddressState();
}

class _BitcoinAddressState extends BaseWalletState<BitcoinAddress> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int coin = TWCoinType.TWCoinTypeBitcoinTestnet;
    final privakye2 = widget.wallet.getKey(coin, "m/44'/0'/0'/0/0");
    logger.d(hex.encode(privakye2.data()));
    final publicKey2 = privakye2.getPublicKeySecp256k1(true);
    logger.d(widget.wallet.getExtendedPublicKey(TWPurpose.TWPurposeBIP44, coin, TWHDVersion.TWHDVersionTPUB));
    final bitcoinAddress = Bitcoin.BitcoinAddress.createWithPublicKey(publicKey2, coin);
    logger.d(bitcoinAddress.description());
    final segwitAddress = Bitcoin.SegwitAddress.createWithPublicKey(Bitcoin.HRP.Bitcoin, publicKey2);
    logger.d(segwitAddress.description());
    final address2 = Bitcoin.AnyAddress.createWithPublicKey(publicKey2, 0);
    logger.d("address2  = ${address2.description()}");

    final pubKeyHash = Bitcoin.Hash.hashSHA256RIPEMD(publicKey2.data());
    final bitcoinScript = Bitcoin.BitcoinScript.buildPayToWitnessPubkeyHash(pubKeyHash);
    final scriptHash = Bitcoin.Hash.hashSHA256RIPEMD(bitcoinScript.data());
    final data = Uint8List.fromList([5]..addAll(scriptHash.toList()));
    final bitcoinAddress2 = Bitcoin.BitcoinAddress.createWithData(data);
    logger.d(bitcoinAddress2.description());


    final bip84Privakey = widget.wallet.getKeyForCoin(TWCoinType.TWCoinTypeBitcoin);
    final wif = WIF.encode(hex.encode(bip84Privakey.data()), TWCoinType.TWCoinTypeBitcoin);
    logger.d("bip84 origin privakey = ${hex.encode(bip84Privakey.data())}");
    logger.d("bip84 wif privakey = $wif");

    final keystore = Bitcoin.StoredKey.importHDWallet(widget.wallet.mnemonic(), "wtf", "123", TWCoinType.TWCoinTypeBitcoin);
    logger.d("keystore json = ${keystore?.exportJson()}");
  }
}
