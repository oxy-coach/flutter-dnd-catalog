
import 'package:flutter/material.dart';
import 'package:dnd_catalog/page.dart';
import 'package:dnd_catalog/models/db.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:dnd_catalog/helper.dart';

class WeaponsPage extends StatefulWidget {

  @override
  _WeaponsPageState createState() => new _WeaponsPageState();
}

class _WeaponsPageState extends State<WeaponsPage> {

  List _list = <Weapon>[];

  @override
  Widget build(BuildContext context) {
    var db = ScopedModel.of<DbModel>(context).db;
    return DndCatalogPage(
      title: "Оружие",
      widget: new FutureBuilder(
        future: db.then((db) => db.query('weapon')),
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


  _buildList(AsyncSnapshot snapshot) {
    _list = snapshot.data.map((data) => Weapon.fromMap(data)).toList();

    var list = ListHelper.groupList(_list.map((item) => item.toMap()).toList(), 'group');

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => _buildItem(list[index]),
      itemCount: list.length,
    );
  }

  _buildItem(item) {
    if (item is! ItemsGroup) {
      return WeaponWidget(item);
    } else {
      return ExpansionTile(
        key: PageStorageKey(item),
        initiallyExpanded: true,
        title: Text(item.name),
        children: List<Widget>.from(item.list.map((weapon) {
          return Container(
            padding: EdgeInsets.only(left: 10.0),
            child: WeaponWidget(Weapon.fromMap(weapon))
          );
        }).toList()),
      );
    }
  }
}

class WeaponWidget extends StatelessWidget {

  final weapon;

  WeaponWidget(this.weapon);

  List<dynamic> _rowsList (model) {
    return [
      {'title': "Цена", 'value': '${Helper.countPrice(model.price)}'},
      {'title': "Урон", 'value': '${model.damage}'},
      {'title': "Вес", 'value': '${model.weight} ф'},
      {'title': "Свойства", 'value': '${model.properties}', "bold": false},
    ];
  } 

  Widget _buildTiles(Weapon weapon) {
    return ExpansionTile(
      key: PageStorageKey<Weapon>(weapon),
      title: Text(weapon.name),
      children: ItemPropertiesWidget.buildRows(_rowsList(weapon))
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(weapon);
  }
}


class Weapon {
  int id, price;
  dynamic weight;
  String name, group, damage, properties;

  Weapon(
    this.id,
    this.price,
    this.name,
    this.weight,
    this.group,
    this.damage,
    this.properties,
  );

  Weapon.fromMap(map)
    : id = map["id"],
      name = map["name"],
      price = map["price"],
      weight = map["weight"],
      group = map["group"],
      damage = map["damage"],
      properties = map["properties"];

  toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'price': this.price,
      'weight': this.weight,
      'group': this.group,
      'damage': this.damage,
      'properties': this.properties,
    };
  }

}