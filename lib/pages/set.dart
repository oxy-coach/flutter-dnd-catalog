
import 'package:flutter/material.dart';
import 'package:dnd_catalog/page.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:dnd_catalog/models/db.dart';
import 'package:scoped_model/scoped_model.dart';

class SetsPage extends StatefulWidget {

  @override
  _SetsPageState createState() => new _SetsPageState(); 
}

class _SetsPageState extends State<SetsPage> {

  List _list = <Set>[];

  @override
  Widget build(BuildContext context) {
    var db = ScopedModel.of<DbModel>(context).db;
    return DndCatalogPage(
      title: "Наборы",
      widget: new FutureBuilder(
        future: db.then((db) => db.query('sets')),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              
              _list = snapshot.data.map((data) => Set.fromMap(data)).toList();

              return ListView.builder(
                itemBuilder: (BuildContext context, int index) => SetWidget(_list[index]),
                itemCount: _list.length,
              );
            } else {
              return new CircularProgressIndicator();
            }
          } else { 
            return Center(
              child: CircularProgressIndicator()
              );
          }
        }
      ),
    );
  }
}



class SetWidget extends StatelessWidget {

  final setModel;

  SetWidget(this.setModel);

  Widget _buildTiles(Set setModel) {
    return ExpansionTile(
      key: PageStorageKey<Set>(setModel),
      title: Text(setModel.name),
      children: <Widget>[
        ListTile(title: Html(data: setModel.description))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(setModel);
  }
}

class Set {
  int id, price;
  String name, description;

  Set(this.id, this.name, this.price, this.description);

  Set.fromMap(map)
    : id = map["id"],
      name = map["name"],
      price = map["price"],
      description = map["description"];
}