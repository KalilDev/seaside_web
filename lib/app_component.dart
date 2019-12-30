import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:seaside_blocs/model.dart';
import 'package:seaside_web/src/components/seaside_background_component.dart';
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
    <seaside-background></seaside-background>
    <svg class="seaside-logo" viewBox="0 0 59 57">
      <path d="M 4.654 10.957 C 4.654 10.957 9.985 1.55 18.107 0.003 C 28.424 -0.194 29.718 9.247 29.718 9.247 L 29.718 57.46 C 29.718 57.46 21.349 57.889 22.826 54.322 C 26.282 45.973 28.23 27.635 28.093 21.19 C 28.062 19.693 26.377 19.412 26.377 19.412 C 26.377 19.412 17.702 18.955 10.743 22.264 C 6.743 24.166 0.48 30.884 0.48 30.884 C 0.48 30.884 -0.701 25.242 0.642 21.376 C 2.63 15.653 8.518 13.58 14.794 13.651 C 21.07 13.721 27.084 16.805 27.44 16.376 C 27.867 15.858 22.533 11.47 16.4 9.635 C 11.657 8.216 4.654 10.957 4.654 10.957 Z M 54.782 10.957 C 54.782 10.957 49.451 1.55 41.329 0.003 C 31.012 -0.194 29.718 9.247 29.718 9.247 L 29.718 57.46 C 29.718 57.46 38.087 57.889 36.61 54.322 C 33.154 45.973 31.206 27.635 31.343 21.19 C 31.374 19.693 33.059 19.412 33.059 19.412 C 33.059 19.412 41.734 18.955 48.693 22.264 C 52.693 24.166 58.956 30.884 58.956 30.884 C 58.956 30.884 60.137 25.242 58.794 21.376 C 56.806 15.653 50.918 13.58 44.642 13.651 C 38.366 13.721 32.352 16.805 31.996 16.376 C 31.569 15.858 36.903 11.47 43.036 9.635 C 47.779 8.216 54.782 10.957 54.782 10.957 Z" style="fill: var(--on-background);"></path>
    </svg>
    <login-page *ngIf="showLogin"></login-page>
    <material-progress *ngIf="showLoading" [indeterminate]="true"></material-progress>
    <router-outlet *ngIf="showNavigator" [routes]="Routes.all"></router-outlet>
  ''',
  styleUrls: ['app_component.css'],
  directives: [routerDirectives, LoginPage, NgIf, MaterialProgressComponent, SeasideBackground],
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
