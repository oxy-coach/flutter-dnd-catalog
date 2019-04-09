
import 'package:flutter/material.dart';
import 'package:dnd_catalog/page.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DndCatalogPage(
      title: "Главная",
      widget: Center(
        child: Container(
          child: Text('Главная'),
        ),
      )
    );
  }
}