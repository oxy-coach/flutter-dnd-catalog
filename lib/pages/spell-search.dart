
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:dnd_catalog/page.dart';
import 'package:dnd_catalog/models/db.dart';
import 'package:dnd_catalog/widgets/spells-list.dart';

class SpellSearchPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DndCatalogPage(
      title: "Поиск заклинаний",
      widget: Center(
        child: Container(
          child: SpellsSearchForm(),
        ),
      )
    );
  }
}

/// Форма с результатом поиска (хотя хз зачем именно форма)
class SpellsSearchForm extends StatefulWidget {
  _SpellsSearchState createState() => _SpellsSearchState();
}

class _SpellsSearchState extends State<SpellsSearchForm> {

  final _formKey = GlobalKey<FormState>();

  Map _params = {
    "name": "",
    "level": "",
    "isRitual": "",
    "school": ""
  };

  Map selects = {
    'level' : {
      'title': 'Уровень',
      'param': 'level',
      'options': [
        {'value': '0', "title": "заговор"},
        {'value': '1', "title": "1"},
        {'value': '2', "title": "2"},
        {'value': '3', "title": "3"},
        {'value': '4', "title": "4"},
        {'value': '5', "title": "5"},
        {'value': '6', "title": "6"},
        {'value': '7', "title": "7"},
        {'value': '8', "title": "8"},
        {'value': '9', "title": "9"},
      ],
    },
    'isRitual': {
      'title': 'Ритуал',
      'param': 'isRitual',
      'options': [
        {'value': '0', 'title': 'Нет'},
        {'value': '1', 'title': 'Да'}
      ],
    },
    'school': {
      'title': 'Школа',
      'param': 'school',
      'options': [
        {'value': 'воплощение', 'title': 'воплощение'},
        {'value': 'вызов', 'title': 'вызов'},
        {'value': 'иллюзия', 'title': 'иллюзия'},
        {'value': 'некромантия', 'title': 'некромантия'},
        {'value': 'ограждение', 'title': 'ограждение'},
        {'value': 'очарование', 'title': 'очарование'},
        {'value': 'преобразование', 'title': 'преобразование'},
        {'value': 'прорицание', 'title': 'прорицание'},
      ],
    }
  };

  @override
  Widget build(BuildContext context) {
    var db = ScopedModel.of<DbModel>(context).db;
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 10.0),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: Colors.grey[500]),
                )
              ),
              child: Column(
                children: <Widget>[
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _params['name'] = value;
                      });
                    },
                  ),
                ]..addAll(_renderFormSelects(selects)),
              )
            ),
            ListTile(
              title: Text('Результаты поиска:'),
            ),
            new Expanded(
              child: SpellsListWidget(db.then((db) => _getQuery(db)), false, true),
            )
          ],
        ),
      )
    );
  }

  /// Рендер селектов
  _renderFormSelects(Map selects) {
    List list = <Widget>[];
    selects.forEach((title, select) {
      list.add(SelectWidget(
        title: select['title'],
        param: select['param'],
        options: select['options'],
        onChange: (value) {
          setState(() {
            _params[title] = value;
          });
        },
      ));
    });

    return list;
  }

  /// клеим параметры в строку запроса и получаем Future с результатом
  _getQuery(db) {
    String query = 'SELECT * FROM spell ';
    List params = [];
    String where = ' WHERE ';
    String order = ' ORDER BY name ';

    _params.forEach((key, value) {
      if (!value.isEmpty) {
        if (key == 'name') {
          params.add(' "$key" like "%$value%" ');
        } else {
          params.add(' "$key" = "$value" ');
        }
        
      }
    });

    if (params.length > 0) {
      query = query + where + params.join(' AND ') + order;
    } else {
      query = query + order;
    }

    return db.rawQuery(query);
  }
}

/// Виджет селекта в форме
class SelectWidget extends StatefulWidget {

  final title;
  final param;
  final List options;
  final Function onChange;

  SelectWidget({this.title, this.param, this.options, this.onChange});

  _SelectWidgetState createState() => _SelectWidgetState(title, param, options, onChange);
}

class _SelectWidgetState extends State<SelectWidget> {

  final title;
  final param;
  final options;
  final onChange;

  _SelectWidgetState(this.title, this.param, this.options, this.onChange);

  List<DropdownMenuItem> _dropDownMenuItems = <DropdownMenuItem>[];
  String _initialValue;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownItems();
    _initialValue = _dropDownMenuItems[0].value;
    super.initState();
  }

  /// Рендер элементов списка
  getDropDownItems() {
    List list = <DropdownMenuItem>[
      DropdownMenuItem(
        value: '',
        child: Text('-'),
      )
    ];

    options.forEach((item) {
      list.add(DropdownMenuItem(
        value: item['value'],
        child: Text(item['title'])
      ));
    });

    return list;
  }

  /// Колбек изменения селекта
  changedDropDownItem(value) {
    setState(() {
      _initialValue = value;
      onChange(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: Text(title + ':', style: TextStyle(fontSize: 16.0 ),),
          ),
          new DropdownButton(
            value: _initialValue,
            items: _dropDownMenuItems,
            onChanged: changedDropDownItem,
          )
        ],
      )
    );
  }
}