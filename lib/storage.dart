import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Storage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return new File('$path/aionaddress.txt');
  }

  Future<List<String>> readAddress() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = file.readAsStringSync();

      return contents.split('\n').toList();
    } catch (e) {
      // If we encounter an error, return 0
      return new List(0);
    }
  }

  Future<void> writeAddress(String address) async {
    final file = await _localFile;
    file.writeAsString('$address\n', mode: FileMode.APPEND);
  }

  Future updateAddresses(List<String> addresses) async {
    final file = await _localFile;
    String contents = "";
    addresses.forEach( (e) {
      if(e != "") {
        contents += '$e\n';
      }
    });
    file.writeAsStringSync('$contents');
  }
}
