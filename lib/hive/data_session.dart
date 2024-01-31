import 'package:hive/hive.dart';

part 'data_session.g.dart';

@HiveType(typeId: 0)
class DataSession extends HiveObject {
  @HiveField(0)
  final String data;

  DataSession({required this.data});
}
