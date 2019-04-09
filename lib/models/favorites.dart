
import 'package:scoped_model/scoped_model.dart';
import 'package:dnd_catalog/db.dart';

class FavoritesModel extends Model {

  final _db = DBLoader.loadDb();
  final tableName = 'favoriteSpells';

  List _list = [];
  bool listLoaded = false;

  /// никому не нужный геттер
  get list => getList();
  
  /// загрузка списка избранных скилов
  loadList() async {
    _list = await _db.then((db) => db.query(tableName)).then((list) => list.map((item) => item['spellId']).toList());
    listLoaded = true;
  }
  
  /// асинхронно получить список id избранных заклинаний
  getList() async {

    if (!listLoaded) {
      await loadList();
    }

    return _list;
  }

  /// есть ли заклинание в избранном 
  isInList(spellId) async {
    var list = await getList();

    return (list.indexOf(spellId) >= 0);
  }
  
  /// переключить избранность у заклинания
  toggleFavorites(spellId) async {
    if (!await isInList(spellId)) {
      await addToFavorites(spellId);
    } else {
      await removeFromFavorites(spellId);
    }
  }
  
  /// добавить заклинание в избранное
  addToFavorites(spellId) async {
    _list.add(spellId);
    await _db.then((db) => db.insert(tableName, {'spellId': spellId}));
    notifyListeners(); // уведомляем об изменении
  }

  /// удалить заклинание из избранного
  removeFromFavorites(spellId) async {
    _list.remove(spellId);
    await _db.then((db) => db.delete(tableName, where: "spellId = ?", whereArgs: [spellId]));
    notifyListeners(); // уведомляем об изменении
  }
  
}