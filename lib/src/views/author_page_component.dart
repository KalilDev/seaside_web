import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:seaside_blocs/bloc/stream_manager.dart';
import 'package:seaside_blocs/model/author.dart';
import 'package:seaside_blocs/model/content.dart';
import 'package:seaside_web/src/components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:seaside_web/src/components/author_card_component.dart';
import 'package:seaside_web/src/components/content_card_component.dart';
import 'package:seaside_web/src/navigation/route_paths.dart';

@Component(
  selector: 'author-page',
  styleUrls: ['author_page_component.css'],
  templateUrl: 'author_page_component.html',
  directives: [
    ContentCard,
    NgIf,
    NgFor
  ],
)
class AuthorPage implements OnActivate, OnInit {
  StreamManagerBloc _streamManager;
  AuthorPage(this._streamManager);

  BaseFirebaseStreamState _currentState;
  String _authorID;

  @Input('authorID')
  set authorID(String id) => updateState(authorID: id);

  Map<ContentType, Iterable<Content>> typeContentMap = {};
  Author author;

  bool get showAuthorCard => author != null;

  void updateState({String authorID, BaseFirebaseStreamState state}) {
    if (state != null) {
      _currentState = state;
      if (_authorID == null) {
        // Welp, can't do anything.
        return;
      }
      author = _currentState.idAuthorMap[_authorID];
      typeContentMap = _currentState.authorIDContentMap[_authorID];
    }
    if (authorID != null) {
      _authorID = authorID;
      if (_currentState == null) {
        // Welp, can't do anything.
        return;
      }
      author = _currentState.idAuthorMap[_authorID];
    }
  }

  @override
  void ngOnInit() {
    updateState(state: _streamManager.state);
    _streamManager.listen((BaseFirebaseStreamState state)=>updateState(state: state));
  }

  @override
  void onActivate(_, RouterState current) async {
    updateState(authorID: getId(current.parameters));
  }
}
