
import 'package:flutter/material.dart';
import 'package:dnd_catalog/page.dart';
import 'package:dnd_catalog/models/db.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:dnd_catalog/helper.dart';


class ArmorsPage extends StatefulWidget {

  @override
  _ArmorsPageState createState() => new _ArmorsPageState();
}

class _ArmorsPageState extends State<ArmorsPage> {

  List _list = <Armor>[];

  @override
  Widget build(BuildContext context) {
    var db = ScopedModel.of<DbModel>(context).db;
    return DndCatalogPage(
      title: "Доспехи",
      widget: new FutureBuilder(
        future: db.then((db) => db.query('armor')),
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
    _list = snapshot.data.map((data) => Armor.fromMap(data)).toList();

    var list = ListHelper.groupList(_list.map((item) => item.toMap()).toList(), 'group');

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => _buildItem(list[index]),
      itemCount: list.length,
    );
  }

  _buildItem(item) {
    if (item is Armor) {
      return ArmorWidget(item);
    } else {
      return ExpansionTile(
        key: PageStorageKey(item),
        initiallyExpanded: true,
        title: Text(item.name),
        children: List<Widget>.from(item.list.map((weapon) {
          return Container(
            padding: EdgeInsets.only(left: 10.0),
            child: ArmorWidget(Armor.fromMap(weapon))
          );
        }).toList()),
      );
    }
  }
}


class ArmorWidget extends StatelessWidget {

  final armor;

  ArmorWidget(this.armor);

  List<dynamic> _rowsList (model) {
    return [
      {'title': "Цена", 'value': '${Helper.countPrice(model.price)}'},
      {'title': "КД", 'value': '${model.ac}'},
      {'title': "Вес", 'value': '${model.weight} ф'},
    ];
  } 

  Widget _buildTiles(Armor armor) {
    return ExpansionTile(
      key: PageStorageKey<Armor>(armor),
      title: Text(armor.name),
      children: ItemPropertiesWidget.buildRows(_rowsList(armor))
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(armor);
  }
}


class Armor {
  int id, price;
  dynamic weight;
  String ac, group, name, stealth, strength;

  Armor(
    this.id,
    this.name,
    this.price,
    this.weight,
    this.ac,
    this.group,
    this.stealth,
    this.strength
  );

  Armor.fromMap(map)
    : id = map['id'],
      name = map["name"],
      price = map["price"],
      weight = map["weight"],
      ac = map["ac"],
      group = map["group"],
      stealth = map["stealth"],
      strength = map["strength"];

  toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'price': this.price,
      'weight': this.weight,
      'ac': this.ac,
      'group': this.group,
      'stealth': this.stealth,
      'strength': this.strength,
    };
  }
}