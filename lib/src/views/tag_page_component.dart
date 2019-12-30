import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:seaside_blocs/bloc/stream_manager.dart';
import 'package:seaside_blocs/model/content.dart';
import 'package:seaside_web/src/components/content_card_component.dart';
import 'package:seaside_web/src/navigation/route_paths.dart';

@Component(
  selector: 'tag-page',
  styleUrls: ['tag_page_component.css'],
  templateUrl: 'tag_page_component.html',
  directives: [
    NgFor,
    ContentCard
  ],
)
class TagPage implements OnActivate, OnInit {
  StreamManagerBloc _streamManager;
  TagPage(this._streamManager);

  Map<ContentType, Iterable<Content>> typeContentMap = {};

  String tag;

  void updateFromIterable(Iterable<Content> contents) {
    if (contents == null)
      return;
    final Iterator<Content> iter = contents.iterator;
    Map<ContentType, List<Content>> typeContentMap = {};
    while (iter.moveNext()) {
      final Content current = iter.current;
      if (typeContentMap.containsKey(current.type)) {
        final List currentIter = typeContentMap[current.type];
        currentIter.add(current);
      } else {
        typeContentMap[current.type] = [current];
      }
    }
    this.typeContentMap = typeContentMap;
  }

  void ngOnInit() {
    updateFromIterable(_streamManager.state.tagContentMap[tag]);
    _streamManager.listen((BaseFirebaseStreamState state) {
      updateFromIterable(state.tagContentMap[tag]);
    });
  }

  @override
  void onActivate(_, RouterState current) async {
    tag = getId(current.parameters);
    //if (tag != null) hero = await (_heroService.get(id))
  }
}
