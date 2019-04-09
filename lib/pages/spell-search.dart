
import 'package:flutter/material.dart';
import 'package:dnd_catalog/page.dart';

class SpellSearchPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DndCatalogPage(
      title: "Поиск заклинаний",
      widget: Center(
        child: Container(
          child: Text('Поиск заклинаний'),
        ),
      )
    );
  }

  // TODO: Добавить форму для поиска по названию, уровню, ритуалу, школе
}