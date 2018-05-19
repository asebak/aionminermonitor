import 'dart:async';

import 'dart:convert';

import 'dart:io';


class AionApi {
  static const String endpoint = "https://mainnet-api.aion.network/aion";

  String _address;

  AionApi(String address){
    _address = address.replaceAll("0x", "");
  }

  Future<dynamic> getAccountDetails() async {
    var request = await new HttpClient().getUrl(Uri.parse('$endpoint/dashboard/getAccountDetails?searchParam=$_address'));
    var response = await request.close();
    if (response.statusCode == HttpStatus.OK) {
      var json = await response.transform(UTF8.decoder).join();
      print(json);
      var data = JSON.decode(json);
      if(data.length > 0) {
        return data["content"][0];
      }else{
        return null;
      }
    } else {
      print('Error getting response:\nHttp status ${response.statusCode}');
    }
    return null;
  }
}