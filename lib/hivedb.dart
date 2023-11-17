import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

part 'hivedb.g.dart';

@HiveType(typeId: 0)
class SearchKeyword extends HiveObject {
  @HiveField(1)
  String name = "madrid";
}
