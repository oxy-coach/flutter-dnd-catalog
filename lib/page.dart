
import 'package:flutter/material.dart';

class DndCatalogPage extends StatelessWidget {

  final String title;
  final Widget widget;

  final List menuList = [
    {'title': "Главная", 'route': '/'},
    {'title': "Классы", 'route': '/classes'},
    {'title': "Заклинания", 'route': '', 'children': [
      {'title': 'По уровням', 'route': '/spells'},
      {'title': 'Избранное', 'route': '/spells-favorites'},
      {'title': 'Поиск', 'route': '/spells-search'},
    ]},
    {'title': "Оружие", 'route': '/weapons'},
    {'title': "Доспехи", 'route': '/armors'},
    {'title': "Предметы", 'route': '', 'children': [
      {'title': 'Общие', 'route': '/items'},
      {'title': 'Наборы', 'route': '/sets'},
      {'title': 'Инструменты', 'route': '/tools'},
    ]},
  ];

  final menuWidgets = <Widget>[
    /*
    DrawerHeader(
      child: Text('Заголовок меню'),
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
    ),
    */
    ListTile(title: Text(''),)
  ];

  DndCatalogPage({this.title = 'Title', this.widget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: Drawer(
        child:ListView(
          padding: EdgeInsets.zero,
          children: menuWidgets..addAll(menuList.map((data) => _tileBuilder(context, data['title'], data['route'], data['children'])).toList())
        )
      ),
      body: widget
    );
  }

  Widget _tileBuilder(context, title, route, [children]) {
    if (children != null) {
      return ExpansionTile(
        key: PageStorageKey(title),
        title: Text(title),
        children: List<Widget>.from(children.map((child) => _tileBuilder(context, child['title'], child['route'])).toList())
      );
    } else {
      return ListTile(
        title: Text(title),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        },
      );
    }
  }
}