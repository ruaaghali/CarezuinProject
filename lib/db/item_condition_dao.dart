import 'package:flutteradmotors/viewobject/condition_of_item.dart';
import 'package:sembast/sembast.dart';
import 'package:flutteradmotors/db/common/ps_dao.dart';

class ItemConditionDao extends PsDao<ConditionOfItem> {
  ItemConditionDao() {
    init(ConditionOfItem());
  }

  static const String STORE_NAME = 'ConditionOfItem';
  final String _primaryKey = 'id';

  @override
  String getPrimaryKey(ConditionOfItem object) {
    return object.id;
  }

  @override
  String getStoreName() {
    return STORE_NAME;
  }

  @override
  Filter getFilter(ConditionOfItem object) {
    return Filter.equals(_primaryKey, object.id);
  }
}
