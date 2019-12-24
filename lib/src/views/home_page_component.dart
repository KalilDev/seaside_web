import 'package:angular/angular.dart';
import 'package:angular_bloc/angular_bloc.dart';
import 'package:angular_components/angular_components.dart';
import 'package:seaside_blocs/model/author.dart';
import 'package:seaside_blocs/model/content.dart';
import 'package:seaside_web/src/components.dart';
import 'package:seaside_blocs/bloc/favorites_manager.dart';
import 'package:seaside_blocs/bloc/stream_manager.dart';
import 'package:seaside_blocs/bloc/authentication_manager.dart';
import 'package:seaside_web/src/components/author_card_component.dart';
import 'package:seaside_web/src/components/content_card_component.dart';

@Component(
  selector: 'home-page',
  styleUrls: ['home_page_component.css'],
  templateUrl: 'home_page_component.html',
  directives: [
    MaterialButtonComponent,
    NgIf,
    NgFor,
    ContentCard,
    AuthorCard
  ],
  pipes: [
    BlocPipe
  ]
)
class HomePage implements OnInit{
  final FavoritesManagerBloc _favoritesManager;
  final StreamManagerBloc streamManager;
  final AuthenticationManagerBloc _authenticationManager;
  HomePage(this._favoritesManager, this.streamManager, this._authenticationManager);

  String currentUserID(AuthenticationManagerState state) => (state as AuthenticatedAuthenticationManagerState).userID;
  
  int currentPage = 0;
  void pageChange(int i) => currentPage = i;

  @override
  void ngOnInit() {
  }
}
