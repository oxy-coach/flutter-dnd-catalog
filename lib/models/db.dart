
import 'package:scoped_model/scoped_model.dart';
import 'package:dnd_catalog/db.dart';

class DbModel extends Model {

  final _db = DBLoader.loadDb();

  get db => _db;
}