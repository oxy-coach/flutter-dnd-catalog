
import 'package:flutter/material.dart';
import 'package:dnd_catalog/page.dart';
import 'package:dnd_catalog/helper.dart';
import 'package:dnd_catalog/models/db.dart';
import 'package:scoped_model/scoped_model.dart';

class ItemsPage extends StatefulWidget {

  @override
  _ItemsPageState createState() => new _ItemsPageState(); 
}

class _ItemsPageState extends State<ItemsPage> {

  List _list = <Item>[];

  @override
  Widget build(BuildContext context) {
    var db = ScopedModel.of<DbModel>(context).db;
    return DndCatalogPage(
      title: "Предметы",
      widget: new FutureBuilder(
        future: db.then((db) => db.query('item')),
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
    _list = snapshot.data.map((data) => Item.fromMap(data)).toList();

    var list = ListHelper.groupList(_list.map((item) => item.toMap()).toList(), 'group');

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => _buildItem(list[index]),
      itemCount: list.length,
    );
  }
  
  _buildItem(item) {
    if (item is! ItemsGroup) {
      return ItemWidget(Item.fromMap(item));
    } else {
      return ExpansionTile(
        key: PageStorageKey(item),
        initiallyExpanded: true,
        title: Text(item.name),
        children: List<Widget>.from(item.list.map((weapon) {
          return Container(
            padding: EdgeInsets.only(left: 10.0),
            child: ItemWidget(Item.fromMap(weapon))
          );
        }).toList()),
      );
    }
  }
}

class Item {
  int id, price;
  dynamic weight;
  String name, group;

  Item(this.id, this.name, this.price, this.weight, this.group);

  Item.fromMap(map)
    : id = map["id"],
      name = map["name"],
      price = map["price"],
      weight = map["weight"],
      group = map["group"];

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

class ItemWidget extends StatelessWidget {

  final item;

  ItemWidget(this.item);

  List<dynamic> _rowsList (model) {
    return [
      {'title': "Цена", 'value': '${Helper.countPrice(model.price)}'},
      {'title': "Вес", 'value': '${model.weight} ф'},
    ];
  } 

  Widget _buildTiles(Item item) {
    return ExpansionTile(
      key: PageStorageKey<Item>(item),
      title: Text(item.name),
      children: ItemPropertiesWidget.buildRows(_rowsList(item))
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(item);
  }
}