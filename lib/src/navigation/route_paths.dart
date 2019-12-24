import 'package:angular_router/angular_router.dart';

const idParam = 'id';

class RoutePaths {
  static final home = RoutePath(path: 'home');
  static final settings = RoutePath(path: 'settings');
  static final content = RoutePath(path: 'content/:$idParam');
  static final editText = RoutePath(path: 'editText/:$idParam');
  static final createText = RoutePath(path: 'createText');
  static final author = RoutePath(path: 'author/:$idParam');
  static final editAuthor = RoutePath(path: 'editAuthor');
  static final tag = RoutePath(path: 'tag/:$idParam');
}

String getId(Map<String, String> parameters) {
  if (!parameters.containsKey(idParam))
    return null;
  return parameters[idParam];
}
