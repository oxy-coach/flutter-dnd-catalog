
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:dnd_catalog/page.dart';
import 'package:dnd_catalog/models/db.dart';
import 'package:dnd_catalog/widgets/spells-list.dart';


class SpellsPage extends StatefulWidget {

  @override
  _SpellsPageState createState() => new _SpellsPageState();
}

class _SpellsPageState extends State<SpellsPage> {
  
  @override
  Widget build(BuildContext context) {
    var db = ScopedModel.of<DbModel>(context).db;
    return DndCatalogPage(
      title: "Заклинания по уровням",
      widget: new SpellsListWidget(db.then((db) => db.query('spell')), true)
    );
  }
}






