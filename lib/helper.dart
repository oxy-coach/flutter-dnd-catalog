
import 'package:flutter/material.dart';

class Helper {

  /// Посчитать цену
  /// 
  /// @return String
  static countPrice(int price) {
    if (price >= 100) {
      return (price ~/ 100).toString() + ' зм';
    }
    if (price >= 10) {
      return (price ~/ 10).toString() + ' см';
    }
    return price.toString() + ' мм';
  }
}

class ItemPropertiesWidget extends StatelessWidget {
  final row;

  ItemPropertiesWidget({this.row});

  static buildRows(list) {
    return List<Widget>.from(list.map((data) => buildRow(data['title'], data['value'], data['bold'] ?? true)).toList());
  }

  static buildRow(title, value, [bold = true]) {
    return ItemPropertiesWidget (
      row: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('$title: '), 
          Expanded( 
            child: Text("$value", style: TextStyle(fontWeight: (bold) ? FontWeight.bold : FontWeight.normal))
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      margin: EdgeInsets.only(bottom: 15.0),
      child: Container(
        child: row,
      )
    );
  }
}

class ListHelper {
  
  /// Возвращает сгруппированный список 
  /// list - список, groupAttribute - аттрибут группировки
  static groupList(list, groupAttribute) {

    var newList = [];
    var groups = [];

    list.forEach((item) {
      var itemGroup = item[groupAttribute];
      if (itemGroup != null && !itemGroup.isEmpty) {
        if (groups.indexOf(itemGroup) < 0) {
          var group = ItemsGroup(itemGroup, []);
          newList.add(group);
          groups.add(itemGroup);
        }

        addToGrouppedList(newList, item, groupAttribute);

      } else {
        newList.add(item);
      }
    });

    return newList;
  }

  /// Добавить элемент в группированный список
  static addToGrouppedList(list, item, groupAttribute) {
    list.forEach((element) {
      if (element is ItemsGroup && element.name == item[groupAttribute]) {
        element.addElement(item);
      }
    });
  }
}

/// Класс для групп элементов
class ItemsGroup {
  String name;
  List list;

  ItemsGroup(this.name, this.list);

  addElement(item) {
    this.list.add(item);
  }
}