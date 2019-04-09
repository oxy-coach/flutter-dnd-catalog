

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:dnd_catalog/models/db.dart';
import 'package:dnd_catalog/models/favorites.dart';
import 'package:dnd_catalog/pages/class.dart';
import 'package:dnd_catalog/pages/home.dart';
import 'package:dnd_catalog/pages/spell.dart';
import 'package:dnd_catalog/pages/spell-search.dart';
import 'package:dnd_catalog/pages/spell-favorites.dart';
import 'package:dnd_catalog/pages/item.dart';
import 'package:dnd_catalog/pages/weapon.dart';
import 'package:dnd_catalog/pages/armor.dart';
import 'package:dnd_catalog/pages/set.dart';
import 'package:dnd_catalog/pages/tool.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  final dbModel = DbModel();
  //final favoritesModel = FavoritesModel();

  @override
  Widget build(BuildContext context) {
  return ScopedModel<DbModel> ( 
      model: dbModel,
      child: ScopedModel<FavoritesModel>(
        model: new FavoritesModel(),
        child: _getMaterialApp(),
      )
    );
  }

  _getMaterialApp() {
    return MaterialApp(
      title: 'Каталог',
      initialRoute: '/',
      routes: {
        '/classes': (context) => ClassesPage(),
        '/spells': (context) => SpellsPage(),
        '/spells-search': (context) => SpellSearchPage(),
        '/spells-favorites': (context) => FavoriteSpellsPage(),
        '/items': (context) => ItemsPage(),
        '/weapons': (context) => WeaponsPage(),
        '/armors': (context) => ArmorsPage(),
        '/sets': (context) => SetsPage(),
        '/tools': (context) => ToolsPage(),
      },
      home: HomePage(),
    );
  }
}


