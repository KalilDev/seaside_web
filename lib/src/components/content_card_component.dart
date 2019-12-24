import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:seaside_web/src/components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:seaside_blocs/model.dart';
import 'package:seaside_web/src/navigation/route_paths.dart';
@Component(
  selector: 'content-card',
  styleUrls: ['content_card_component.css'],
  templateUrl: 'content_card_component.html',
  directives: [
    NgIf,
    NgClass,

  ],
)
class ContentCard {
  final Router _router;
  ContentCard(this._router);

  @Input()
  Content content;
  bool get showTitle => content.title != null;
  bool get showText => content.text != null;
  bool get showImage => content.backgroundImage != null;
  bool get isHidden => content.isVisible == false; // Protect against null
  String _contentUrl(String id) =>
      RoutePaths.content.toUrl(parameters: {idParam: '$id'});

  void onClick() {
      _router.navigate(_contentUrl(content.contentID));
  }
}
