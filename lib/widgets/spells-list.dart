
import 'package:flutter/material.dart';
import 'package:dnd_catalog/classes/spell.dart';
import 'package:dnd_catalog/widgets/spell-item.dart';

class SpellsListWidget extends StatelessWidget {

  final Future future;
  final bool groupByLevel;
  final bool showLevel;

  SpellsListWidget(this.future, this.groupByLevel, [this.showLevel = false]);

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: future,
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
    );
  }

  /// Рендер списка заклинаний по снапшоту из базы
  _buildList(snapshot) {
    List list = List<Spell>.from(snapshot.data.map((data) => Spell.fromMap(data)).toList());

    // группировка по уровням
    if (groupByLevel) {
      Map levelGroupList = GrouppedSpellsList.getGrouppedList(list);

      var list2 = GrouppedSpellsList.convertToList(levelGroupList);

      return ListView.builder(
        itemBuilder: (BuildContext context, int index) => _buildLevelItem(list2[index]),
        itemCount: list2.length,
      );
    }

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => SpellWidget(list[index], showLevel),
      itemCount: list.length,
    );
  }

  /// Рендер списка уровня
  _buildLevelItem(item) {
    return ExpansionTile(
      key: PageStorageKey(item),
      title: Text(item['title']),
      children: List<Widget>.from(item['spells'].map((spell) {
        return Container(
          padding: EdgeInsets.only(left: 10.0),
          child: SpellWidget(spell, showLevel)
        );
      }).toList()),
    );
  }

}


/// Вспомогательный класс со статичными методами
/// для перегона списков в массивы и обратно
class GrouppedSpellsList {

  static getGrouppedList(List<Spell> list) {
    Map<int, Map> map = {};

    list.forEach((spell) {
      if (map[spell.level] == null) {
          map[spell.level] = {
            'title' : (spell.level == 0) ? 'Заговоры' : "Уровень ${spell.level}",
            'level': spell.level,
            'spells': [],
          };
        }

        map[spell.level]['spells'].add(spell);
    });

    return map;
  }

  static convertToList(Map map) {
    List list = [];
    map.forEach((index, element) => list.add(element));
    list.sort((a, b) => a['level'].compareTo(b['level']));
    return list;
  }
}