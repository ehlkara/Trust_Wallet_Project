
import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:flutter/material.dart';
import 'package:trust_wallet_core/flutter_trust_wallet_core.dart';
import 'package:trust_wallet_core/protobuf/Tron.pb.dart' as TronWallet;
import 'package:trust_wallet_core/trust_wallet_core_ffi.dart';
import 'package:trust_wallet/wallets/base_wallet.dart';


class Tron extends BaseWallet {
  final HDWallet wallet;

  const Tron(this.wallet,{Key? key}) : super('Tron', key: key);

  @override
  _TronState createState() => _TronState();
}

class _TronState extends BaseWalletState<Tron> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final now = DateTime.now();

    int coin = TWCoinType.TWCoinTypeTron;

    String nowBlock =
        '{"blockID":"00000000011918071ecc35c6178f7cea6abf0a0747cf1084b43c9660bd02eb24","block_header":{"raw_data":{"number":18421767,"txTrieRoot":"0000000000000000000000000000000000000000000000000000000000000000","witness_address":"41839d08f05ade5b365e81d1a66c20af13ebb2991d","parentHash":"0000000001191806eeaac4f94195754bab81a6da304f839f15f12ba874e57884","version":22,"timestamp":1631928606000},"witness_signature":"8c0f92f8880521a21c2d9ecf7b1b58cffbaa6ce739c465cb1118328dcd901b0f699d669d3b3382150c4823cab64d644517d92f378dbbbcd2ae1bb535ac08799500"}}';
    Map blockHeader = json.decode(nowBlock)['block_header']['raw_data'];
    print(blockHeader);
    logger.d(widget.wallet.getAddressForCoin(coin));
    final addressList = Base58.base58DecodeNoCheck(widget.wallet.getAddressForCoin(coin));
    if (addressList == null) {
      print("addressList null !!!");
      return;
    }
    String hexaaddress = hex.encode(addressList);
    logger.d("hexAddress = $hexaaddress");

    final input = TronWallet.SigningInput(
        transaction: TronWallet.Transaction(
          transfer: TronWallet.TransferContract(
            ownerAddress: widget.wallet.getAddressForCoin(coin),
            toAddress: 'TD3QZkapTC2Uuq1Tn6tv4TfzagDHxr7gxz',
            amount: $fixnum.Int64.parseInt('200000'),
          ),
          timestamp: $fixnum.Int64.parseInt(now.millisecondsSinceEpoch.toString()),
          expiration: $fixnum.Int64.parseInt('${now.millisecondsSinceEpoch + 10 * 60 * 60 * 1000}'),
          blockHeader: TronWallet.BlockHeader(
            timestamp: $fixnum.Int64.parseInt(blockHeader['timestamp'].toString()),
            txTrieRoot: hex.decode(blockHeader['txTrieRoot']),
            parentHash: hex.decode(blockHeader['parentHash']),
            number: $fixnum.Int64.parseInt(blockHeader['number'].toString()),
            witnessAddress: hex.decode(blockHeader['witness_address']),
            version: blockHeader['version'],
          ),
        ),
        privateKey: widget.wallet.getKeyForCoin(coin).data().toList());
    final output = TronWallet.SigningOutput.fromBuffer(AnySigner.sign(input.writeToBuffer(), coin).toList());
    logger.d(output.json);
    print(output.json);

    TronWallet.Transaction tr = TronWallet.Transaction(
        freezeBalance: TronWallet.FreezeBalanceContract(
          ownerAddress: "TUQuaXCjDhLQsJbUeCN42PTZzQQnGh7SQP",
          frozenBalance: $fixnum.Int64.parseInt("4900000"),
          frozenDuration: $fixnum.Int64.parseInt("3"),
          resource: "ENERGY",
        ),
        blockHeader: TronWallet.BlockHeader(
          timestamp: $fixnum.Int64.parseInt(blockHeader['timestamp'].toString()),
          txTrieRoot: hex.decode(blockHeader['txTrieRoot']),
          parentHash: hex.decode(blockHeader['parentHash']),
          number: $fixnum.Int64.parseInt(blockHeader['number'].toString()),
          witnessAddress: hex.decode(blockHeader['witness_address']),
          version: blockHeader['version'],
        )
    );
    final freeze = TronWallet.SigningInput(
      transaction: tr,
      privateKey: widget.wallet.getKeyForCoin(coin).data().toList(),
    );
    final freezeOutput = TronWallet.SigningOutput.fromBuffer(AnySigner.sign(freeze.writeToBuffer(), coin).toList());
    print(freezeOutput.json);
  }
}
