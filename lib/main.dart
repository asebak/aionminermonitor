import 'dart:async';

import 'package:aion_monitor/storage.dart';
import 'package:flutter/material.dart';

void main() => runApp(new AionBalanceApp());

class AionBalanceApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Aion Balance Monitor',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Aion Balance Monitor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _addresses;
  Iterable<Widget> _listTiles = new List<Widget>();

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  _MyHomePageState() {
   _getAllAddress();
  }

  Widget buildListTile(BuildContext context, String item) {
    if(item == ""){
      return MergeSemantics();
   }
    Widget secondary;
    secondary = const Text('Balance: ');

    return new MergeSemantics(
      child: new ListTile(
        isThreeLine: true,
        dense: true,
        leading: new ExcludeSemantics(child: new CircleAvatar(backgroundColor: Colors.transparent,backgroundImage: new AssetImage('assets/aion.png'))),
        title: new Text('$item'),
        subtitle: secondary,
        trailing: new IconButton(icon: const Icon(Icons.delete), color: Theme.of(context).hintColor, onPressed: (){
          Storage storage = new Storage();
          _removeAddressFromUI(item);
          storage.updateAddresses(_addresses).then((dynamic val){
            setState(() {
              _refreshListView();
            });
          });


        },),
      ),
    );
  }



  _getAllAddress() {
    Storage storage = new Storage();
    storage.readAddress().then((List<String> addresses){
      _addresses = addresses;
      setState(() {
        _refreshListView();
      });
    });
  }

  _refreshListView(){
    _listTiles = _addresses.map((String item) =>
        buildListTile(context, item));
    _listTiles = ListTile.divideTiles(context: context, tiles: _listTiles);
  }

  _addAddressToUI(address){
    _addresses.add(address);
    _refreshListView();
  }

  _removeAddressFromUI(address){
    var toRemove = [];
    _addresses.forEach( (e) {
      if(e == address || e == "") {
        toRemove.add(e);
      }
    });
    _addresses.removeWhere( (e) => toRemove.contains(e));
  }

   _addNewAddress() {
    final myController = new TextEditingController();
    AlertDialog dialog = new AlertDialog(
        content: new Form(
          key: _formKey,
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new TextFormField(
                validator:  (value){
                  RegExp regExp = new RegExp(
                    r"^0xa[a-f\d]{63}$",
                    caseSensitive: false,
                    multiLine: false,
                  );
                  bool isValidAccount = regExp.hasMatch(value);
                  if(!isValidAccount){
                    return "Not a valid Aion Account";
                  }
                  return null;
                },
                  autovalidate: true,
              controller: myController,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                      hintText: '0xa0',
                      labelText: 'Aion Address'
                  )
              )

            ],
          ),
        ),

        actions: <Widget> [
          new FlatButton(onPressed: () => Navigator.pop(context), child: new Text('Cancel')),
          new FlatButton(onPressed: () {

     if (this._formKey.currentState.validate()) {
         var text = myController.text;
         //if(!isValidAccount){
         Storage storage = new Storage();
         storage.writeAddress(text).then((void value) {
           setState(() {
             _addAddressToUI(text);
             Navigator.pop(context);
           });
         });
     }
          }, child: new Text('Add')),
        ]
    );
    return showDialog(
      context: context,
      builder: (context) {
        return dialog;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Scrollbar(
        child: new ListView(
          padding: new EdgeInsets.symmetric(vertical:  4.0 ),
          children: _listTiles.toList(),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _addNewAddress,
        tooltip: 'Add Wallet Address',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}
