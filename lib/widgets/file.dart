import 'package:hive/hive.dart';

part 'file.g.dart';

@HiveType(typeId: 0)
class File extends HiveObject {
  File get copy {
    final objectInstance = File(name: name, content: content);
    return objectInstance;
  }

  @HiveField(0)
  String name;

  @HiveField(1)
  String content;

  File({required this.name, required this.content});
}
