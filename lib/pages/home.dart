
import 'package:flutter/material.dart';
import 'package:dnd_catalog/page.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DndCatalogPage(
      title: "Главная",
      widget: ListView(
        children: List<Widget>.from(tables.map((table) => _renderTable(table)).toList())
      )
    );
  }

  final tables = [
    {
      'title': "Модификаторы характеристик",
      'rows': [
        ['Значение хар-ки', 'Модификатор'],
        ['1', '-5'],
        ['2-3', '-4'],
        ['4-5', '-3'],
        ['6-7', '-2'],
        ['8-9', '-1'],
        ['10-11', '0'],
        ['12-13', '+1'],
        ['14-15', '+2'],
        ['16-17', '+3'],
        ['18-19', '+4'],
        ['20-21', '+5'],
        ['22-23', '+6'],
        ['24-25', '+7'],
        ['26-27', '+8'],
        ['28-29', '+9'],
        ['30', '+10'],
      ],
    },
    {
      'title': "Развитие персонажа",
      'rows': [
        ['Опыт', 'Уровень', 'Модификатор'],
        ['0', '1', '+2'],
        ['300', '2', '+2'],
        ['900', '3', '+2'],
        ['2 700', '4', '+2'],
        ['6 500', '5', '+3'],
        ['14 000', '6', '+3'],
        ['23 000', '7', '+3'],
        ['34 000', '8', '+3'],
        ['48 000', '9', '+4'],
        ['64 000', '10', '+4'],
        ['85 000', '11', '+4'],
        ['100 000', '12', '+4'],
        ['120 000', '13', '+5'],
        ['140 000', '14', '+5'],
        ['165 000', '15', '+5'],
        ['195 000', '16', '+5'],
        ['225 000', '17', '+6'],
        ['265 000', '18', '+6'],
        ['305 000', '19', '+6'],
        ['335 000', '20', '+6'],
      ],
    }
  ];

  Widget _renderTable(table) {
    int index = 0;
    return Column(
      children: <Widget>[
        ListTile(title: Text(table['title'])),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          child: Table(
            border: TableBorder.all(),
            children: List<TableRow>.from(table['rows'].map((row) {
              return _renderTableRow(row, index++);
            }).toList())
          ),
        )
      ],
    );
  }

  _renderTableRow(row, index) {
    var style = ((index % 2) == 1) ? Colors.blue[100] : Colors.white ;
    return TableRow(
      decoration: BoxDecoration(
        color: (index == 0) ? null : style,
      ),
      children: List<Widget>.from(row.map((item) {
        var bold = (index > 0) ? FontWeight.normal : FontWeight.bold; 
        return TableCell(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: Text(item, style: TextStyle(fontWeight: bold)),
          ),
        );
      }).toList())
    );
  }
}
