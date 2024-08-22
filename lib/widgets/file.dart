import 'package:hive/hive.dart';

part 'file.g.dart';

@HiveType(typeId: 0)
class File extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String content;

  File({required this.name, required this.content});
}
