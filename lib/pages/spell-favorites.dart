
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:dnd_catalog/page.dart';
import 'package:dnd_catalog/models/db.dart';
import 'package:dnd_catalog/widgets/spells-list.dart';
import 'package:dnd_catalog/models/favorites.dart';

class FavoriteSpellsPage extends StatefulWidget {

  @override
  _FavoriteSpellsState createState() => new _FavoriteSpellsState();
}

class _FavoriteSpellsState extends State<FavoriteSpellsPage> {
  
  @override
  Widget build(BuildContext context) {
    var db = ScopedModel.of<DbModel>(context).db;
    return DndCatalogPage(
      title: "Избранные заклинания",
      widget: ScopedModelDescendant<FavoritesModel>(
        builder: (context, child, model) {
          return new SpellsListWidget(db.then((db) => _queryFavoritesSpells(db)), false);
        },
      )
    );
  }

  _queryFavoritesSpells(db) {
    return db.rawQuery('SELECT s.* FROM favoriteSpells AS fs INNER JOIN spell AS s ON fs.spellId = s.id ');
  }
}