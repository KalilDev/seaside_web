import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:seaside_web/src/components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:seaside_blocs/bloc/authentication_manager.dart';
@Component(
  selector: 'login-page',
  styleUrls: ['login_page_component.css'],
  templateUrl: 'login_page_component.html',
  directives: [
    NgModel,
    MaterialButtonComponent,
    NgForm,
    formDirectives,
    NgControl,
  ],
)
class LoginPage {
  _LoginInfo info = _LoginInfo();
  final AuthenticationManagerBloc _authenticationManager;
  LoginPage(this._authenticationManager);
  void login() {
    _authenticationManager.add(LoginFromEmailAuthEvent(email: info.email, password: info.password));
  }
  void onGoogle() {
    _authenticationManager.add(GoogleLoginAuthEvent());
  }
}

class _LoginInfo {
  String email;
  String password;
}