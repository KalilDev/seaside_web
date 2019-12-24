import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:seaside_blocs/model.dart';
import 'package:seaside_web/src/views/login_page_component.dart';
import 'src/views.dart';

import 'package:seaside_web/src/navigation/routes.dart';
import 'package:seaside_blocs/bloc/authentication_manager.dart';
import 'package:seaside_blocs/bloc/favorites_manager.dart';
import 'package:seaside_blocs/bloc/settings_manager.dart';
import 'package:seaside_blocs/bloc/stream_manager.dart';
import 'package:seaside_web/src/components.dart';

@Component(
  selector: 'my-app',
  template: '''
    <h1>{{title}}</h1>
    <login-page *ngIf="showLogin"></login-page>
    <material-progress *ngIf="showLoading" [indeterminate]="true"></material-progress>
    <router-outlet *ngIf="showNavigator" [routes]="Routes.all"></router-outlet>
  ''',
  styleUrls: ['app_component.css'],
  directives: [routerDirectives, LoginPage, NgIf, MaterialProgressComponent],
  providers: [
    ClassProvider(AuthenticationManagerBloc),
    ClassProvider(FavoritesManagerBloc),
    ClassProvider(SettingsManagerBloc),
    ClassProvider(StreamManagerBloc),
    ],
  exports: [RoutePaths, Routes],
)
class AppComponent implements OnInit {
  final AuthenticationManagerBloc _authManager;
  AppComponent(this._authManager);
  final title = 'Tour of Heroes';

  bool showLoading = true;
  bool showLogin = false;
  bool showNavigator = false;
  @override
  void ngOnInit() {
    _authManager.listen((AuthenticationManagerState state) {
      if (state is AuthenticatedAuthenticationManagerState) {
        showLoading = false;
        showLogin = false;
        showNavigator = true;
      }
      if (state is UnauthenticatedAuthenticationManagerState) {
        showLoading = false;
        showLogin = true;
        showNavigator = false;
      }
      if (state is LoadingAuthenticationManagerState) {
        showLoading = true;
        showLogin = false;
        showNavigator = false;
      }
    });
  }
}
