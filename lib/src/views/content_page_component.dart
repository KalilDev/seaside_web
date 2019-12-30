import 'package:angular/angular.dart';
import 'package:angular/security.dart';
import 'package:angular_components/angular_components.dart';
import 'package:seaside_blocs/bloc/music_player.dart';
import 'package:seaside_blocs/bloc/stream_manager.dart';
import 'package:seaside_blocs/model/author.dart';
import 'package:seaside_blocs/model/content.dart';
import 'package:seaside_web/bloc/web_music_player_bloc.dart';
import 'package:seaside_web/src/components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:seaside_web/src/navigation/route_paths.dart';
import 'dart:async';

import 'package:seaside_web/src/utils/text_formatting_directive.dart';

@Component(
  selector: 'content-page',
  styleUrls: ['content_page_component.css'],
  templateUrl: 'content_page_component.html',
  directives: [
    NgIf,
    NgFor,
    TextFormattingDirective,
    SafeInnerHtmlDirective
  ],
  pipes: [
    DatePipe
  ]
)
class ContentPage implements OnActivate, OnInit {
  StreamManagerBloc _streamManager;
  DomSanitizationService _sanitizationService;
  ContentPage(this._streamManager, this._sanitizationService);

  BaseFirebaseStreamState _currentState;
  MusicPlayerBlocImpl musicPlayerBloc;
  StreamSubscription musicPlayerSubscription;
  MusicPlayerState playerState;
  String _contentID;

  bool get showMusicPlayer => content?.music != null;
  bool get showGallery => content?.imageUrl is Iterable;
  bool get showAuthorPage => content?.authorID != null;
  bool get showImage => content?.backgroundImage != null;
  bool get showDate => content?.date != null;
  bool get showText => content?.text != null;
  bool get showTitle => content?.title != null;

  SafeHtml get textHtml => _sanitizationService.bypassSecurityTrustHtml(formattedText(content.text));
  Content content;

  DateTime get datetime => DateTime.parse(content.date);

  void updateMusicPlayerListener() {
    musicPlayerSubscription?.cancel();
    musicPlayerSubscription = musicPlayerBloc.listen((MusicPlayerState state)=>playerState);
  }

  void updateState({String contentID, BaseFirebaseStreamState state}) {
    if (state != null) {
      _currentState = state;
      if (_contentID == null) {
        // Welp, can't do anything.
        return;
      }
      content = _currentState.idContentMap[_contentID];
    }
    if (contentID != null) {
      _contentID = contentID;
      if (_currentState == null) {
        // Welp, can't do anything.
        return;
      }
      content = _currentState.idContentMap[_contentID];
    }
    if (showMusicPlayer) {
      if (musicPlayerBloc?.musicUrl == content.music)
        return;
      musicPlayerBloc = MusicPlayerBlocImpl(content.music);
      updateMusicPlayerListener();
    }
  }

  @override
  void ngOnInit() {
    updateState(state: _streamManager.state);
    _streamManager.listen((BaseFirebaseStreamState state)=>updateState(state: state));
  }

  @override
  void onActivate(_, RouterState current) async {
    updateState(contentID: getId(current.parameters));
  }
}