import 'dart:html';

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
class HomePage implements OnInit {
  final FavoritesManagerBloc favoritesManager;
  final StreamManagerBloc streamManager;
  final AuthenticationManagerBloc authenticationManager;
  HomePage(this.favoritesManager, this.streamManager, this.authenticationManager);

  // Many
  Iterable<Author> authors;

  // Explore
  Map<ContentType, Iterable<Content>> typeContentMap;

  // You
  String currentUserName;
  String currentUserId;
  Author currentAuthor;
  Map<ContentType, Iterable<Content>> currentUserTypeContentMap;
  void logout() {
    authenticationManager.add(LogoutAuthEvent());
  }

  // Search
  Iterable<Content> contents;
  String searchQuery;
  List<Content> searchedContents = [];
  List<Author> searchedAuthors = [];
  void search(String query) {
    print(query);
    searchedAuthors = [];
    searchedContents = [];
    final queryIter = StreamManagerBloc.searchResults(query, contents, authors).iterator;
    while (queryIter.moveNext()) {
      final dynamic current = queryIter.current;
      if (current is Author) {
        searchedAuthors.add(current);
      }
      if (current is Content) {
        searchedContents.add(current);
      }
    }
    searchQuery = query;
  }

  int currentPage = 0;
  void pageChange(int i) => currentPage = i;

  void updateBlocStates({BaseFirebaseStreamState firebaseStreamState, AuthenticationManagerState authenticationManagerState}) {
    final firebaseState = firebaseStreamState ?? streamManager.state;
    final authenticationState = authenticationManagerState ?? authenticationManager.state;
    typeContentMap = firebaseState.typeContentMap ?? {};
    authors = firebaseState.authors ?? [];
    contents = firebaseState.contents ?? [];
    currentUserName = authenticationState is AuthenticatedAuthenticationManagerState ? authenticationState.userName : null;
    currentUserId = authenticationState is AuthenticatedAuthenticationManagerState ? authenticationState.userID : null;
    currentAuthor = currentUserId == null ? null : firebaseState.idAuthorMap[currentUserId];
    currentUserTypeContentMap = currentAuthor == null ? null : firebaseState.authorIDContentMap[currentUserId];
    if (searchQuery != null)
      search(searchQuery);
  }

  @override
  void ngOnInit() {
    // Initial State
    updateBlocStates();
    // Listen the BLoCs
    streamManager.listen((BaseFirebaseStreamState state) => updateBlocStates(firebaseStreamState: state));
    authenticationManager.listen((AuthenticationManagerState state) => updateBlocStates(authenticationManagerState: state));
  }
}
