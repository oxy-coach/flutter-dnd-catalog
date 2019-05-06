
import 'package:flutter/material.dart';
import 'package:dnd_catalog/page.dart';
import 'package:dnd_catalog/models/db.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:dnd_catalog/widgets/spells-list.dart';

class ClassesPage extends StatefulWidget {

  @override
  _ClassesPageState createState() => new _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {

  List _list = <Class>[];

  @override
  Widget build(BuildContext context) {
    var db = ScopedModel.of<DbModel>(context).db;
    return DndCatalogPage(
      title: "Классы",
      widget: new FutureBuilder(
        future: db.then((db) => db.query('class')),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              
              _list = snapshot.data.map((data) => Class.fromMap(data)).toList();

              return ListView.builder(
                itemBuilder: (BuildContext context, int index) => ClassWidget(_list[index], context),
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


class ClassWidget extends StatelessWidget {

  final classModel;
  final context;

  ClassWidget(this.classModel, this.context);

  Widget _buildTiles(Class model, context) {
    return ExpansionTile(
      key: PageStorageKey<Class>(model),
      title: Text(model.name),
      children: <Widget>[
        ListTile(
          title: Text('Заклинания'),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SpellsScreen(model),
                ),
              );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(classModel, context);
  }
}


class SpellsScreen extends StatelessWidget {

  final model;

  SpellsScreen(this.model);

  @override
  Widget build(BuildContext context) {
    var db = ScopedModel.of<DbModel>(context).db;

    return Scaffold(
      appBar: AppBar(title: Text("${model.name}: Заклинания")),
      //body: Center(child: Text('заклинания'))
      body: SpellsListWidget(db.then((db) => _getClassSpells(db, model.id)), true)
    );
    //return new SpellsListWidget(db.then((db) => _getClassSpells(db, model.id)));
  }

  Future _getClassSpells(db, id) {
    return db.rawQuery('SELECT s.* FROM `classSpells` AS cs INNER JOIN `spell` AS s ON s.id = cs.spellId WHERE cs.classId = $id');
  }
}

class Class {
  int id;
  String name;
  String spellsInfo;

  Class(this.id, this.name, this.spellsInfo);

  Class.fromMap(map)
    : id = map["id"],
      name = map["name"],
      spellsInfo = map["spellsInfo"] ;
}