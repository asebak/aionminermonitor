import 'package:bignum/bignum.dart';

class AccountDetails{
  String balance;
  var blockNumber;
  String nonce;

  AccountDetails.fromJson(Map json) {
    this.balance = json["balance"];
    this.blockNumber = json["blockNumber"];
    this.nonce = json["nonce"];
    //var balance2 = new BigInteger(balance, 10, "").toString();
    //secondary = Text('Balance: $balance2');
  }
}