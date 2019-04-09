
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:dnd_catalog/classes/spell.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:dnd_catalog/models/favorites.dart';


class SpellWidget extends StatelessWidget {

  final Spell spell;
  final bool showLevel;

  static const fontSize = 16.0;

  SpellWidget(this.spell, [this.showLevel = false]);

  /// Главный контейнер с заклинанием
  Widget _buildTiles(Spell spell) {

    var titleRow = <Widget>[
      Expanded(child: Text(spell.name))
    ];
    
    if (showLevel) titleRow..add(_renderTitleFlags(spell.levelStrShort, Colors.green[300]));
    if (spell.hasConcentration == 1) titleRow..add(_renderTitleFlags('К', Colors.blue[500]));
    if (spell.isRitual == 1) titleRow..add(_renderTitleFlags('Р', Colors.purple[300]));

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 0.5, color: Colors.grey[300]),
        )
      ),
      child: ExpansionTile(
        key: PageStorageKey<Spell>(spell),
        title: Row(
          children: titleRow
        ),

        /// немного моделей - рисуем звездочку избранного
        trailing: ScopedModelDescendant<FavoritesModel>( 
          builder: (context, child, model) {
            return  GestureDetector(
              onTap: () {
                // тоггл выбранного скила
                model.toggleFavorites(spell.id);
              },
              child: FutureBuilder(
                future: model.isInList(spell.id),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return _renderIcon(snapshot.data);
                  } else { 
                    return _renderIcon(false);
                  }
                },
              )
            );
          }
        ),

        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.grey[300]),
              )
            ),
          ),
          _buildRows(),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.only(left: 15.0),
              child: Text('Описание:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize ))
            ),
          ),
          
          ListTile(title: Html(data: spell.description))
        ],
      )
    );
  }

  /// иконочка звездочки избранного
  _renderIcon(bool snapshot) {
    var params = (snapshot == true) ? {
      "icon": Icons.star,
      "color": Colors.yellowAccent[400],
    } : {
      "icon": Icons.star_border,
      "color": Colors.grey[500],
    };

    return Icon(params['icon'], color: params['color']);
  }

  /// строки описания
  _buildRows() {

    var widgets = <Widget>[];

    String html = '<p>';
    html += '<i>Школа: <b>' + spell.school +'</b></i> <br>'; 
    if (spell.isRitual == 1) {
      html += '<i>Ритуал</i> <br>';
    }
    html += '<b>' + spell.levelString + '</b><br>';
    html += '<b>Время накладывания:</b> ' + spell.castTime + '<br>';
    html += '<b>Дистанция:</b> ' + spell.distance + '<br>' ;
    html += '</p>';

    widgets.add(ListTile(title: Html(data: html)));

    var row = <Widget>[
      Text('Компоненты: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize))
    ];

    if (spell.isVerbal == 1) row.add(_renderComponent("В", Colors.blue[400]));
    if (spell.isSomatic == 1) row.add(_renderComponent("С", Colors.green[400]));
    if (spell.isMaterial == 1) row.add(_renderComponent("М", Colors.pink[400]));

    widgets.add(
      Container(
        padding: EdgeInsets.only(left: 15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: row
        ),
      )
    );

    html = '<p>';
    if (spell.materials.isNotEmpty) html += '<b>Материалы: </b>' + spell.materials + '<br>';
    if (spell.hasConcentration == 1) html += '<b>Концентрация:</b> Да <br>';
    html += '<b>Длительность:</b> ' + spell.duration + ' <br>';
    html += '</p>';

    widgets.add(ListTile(title: Html(data: html)));

    return Column(
      children: widgets
    );
  }

  /// рендер элемента в строке компонентов заклинания
  _renderComponent(text, color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(" $text ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, background: Paint()..color = color, fontSize: fontSize))
    );
  }

  /// рендер флагов (концентрации и ритуала) в заголовке заклинания
  _renderTitleFlags(text, color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(' $text ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, background: Paint()..color = color, fontSize: fontSize)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(spell);
  }
}

