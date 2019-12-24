import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:firebase_web/firebase_web_implementation.dart';
import 'package:seaside_web/app_component.template.dart' as ng;
import 'package:seaside_blocs/src/singletons.dart' as singletons;
import 'main.template.dart' as self;
import 'package:key_value_store_web/key_value_store_web.dart';
import 'dart:html';

@GenerateInjector(
  routerProvidersHash, // You can use routerProviders in production
)
final InjectorFactory injector = self.injector$Injector;

void main() {
  singletons.firebaseApp = WebFirebaseApp();
  singletons.isWeb = true;
  singletons.keyValueStore = WebKeyValueStore(window.localStorage);
  runApp(ng.AppComponentNgFactory, createInjector: injector);
}
