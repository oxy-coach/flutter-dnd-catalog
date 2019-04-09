
import 'package:flutter/material.dart';
import 'package:dnd_catalog/page.dart';
import 'package:dnd_catalog/helper.dart';
import 'package:dnd_catalog/models/db.dart';
import 'package:scoped_model/scoped_model.dart';

class ToolsPage extends StatefulWidget {

  @override
  _ToolsPageState createState() => new _ToolsPageState(); 
}

class _ToolsPageState extends State<ToolsPage> {

  List _list = <Tool>[];

  @override
  Widget build(BuildContext context) {
    var db = ScopedModel.of<DbModel>(context).db;
    return DndCatalogPage(
      title: "Инструменты",
      widget: new FutureBuilder(
        future: db.then((db) => db.query('tool')),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return _buildList(snapshot);
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

  _buildList(snapshot) {
    _list = snapshot.data.map((data) => Tool.fromMap(data)).toList();

    var list = ListHelper.groupList(_list.map((item) => item.toMap()).toList(), 'group');

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => _buildItem(list[index]),
      itemCount: list.length,
    );
  }
  
  _buildItem(item) {
    if (item is! ItemsGroup) {
      return ToolWidget(Tool.fromMap(item));
    } else {
      return ExpansionTile(
        key: PageStorageKey(item),
        initiallyExpanded: true,
        title: Text(item.name),
        children: List<Widget>.from(item.list.map((weapon) {
          return Container(
            padding: EdgeInsets.only(left: 10.0),
            child: ToolWidget(Tool.fromMap(weapon))
          );
        }).toList()),
      );
    }
  }
}

class ToolWidget extends StatelessWidget {
  
  final tool;

  ToolWidget(this.tool);

  List<dynamic> _rowsList (model) {
    return [
      {'title': "Цена", 'value': '${Helper.countPrice(model.price)}'},
      {'title': "Вес", 'value': '${model.weight} ф'},
    ];
  } 

  Widget _buildTiles(Tool model) {
    return ExpansionTile(
      key: PageStorageKey<Tool>(model),
      title: Text(model.name),
      children: ItemPropertiesWidget.buildRows(_rowsList(model))
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(tool);
  }
}

class Tool {
  int id, price;
  dynamic weight;
  String group, name;

  Tool(this.id, this.price, this.weight, this.name, this.group);

  Tool.fromMap(map)
    : id = map['id'],
      name = map['name'],
      price = map['price'],
      weight = map['weight'],
      group = map['group'];

  toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'price': this.price,
      'weight': this.weight,
      'group': this.group,
    };
  }
}