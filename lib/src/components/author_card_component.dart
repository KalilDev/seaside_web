import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:seaside_blocs/model.dart';
import 'package:seaside_web/src/components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:seaside_web/src/navigation/route_paths.dart';
@Component(
  selector: 'author-card',
  styleUrls: ['author_card_component.css'],
  templateUrl: 'author_card_component.html',
  directives: [
    NgIf,
    NgClass,
    MaterialRippleComponent
  ],
)
class AuthorCard {
  final Router _router;
  AuthorCard(this._router);

  @Input()
  Author author;
  final String bioText = 'Biografia:';
  bool get showName => author.name != null;
  bool get showBio => author.bio != null;
  bool get showImage => author.imgUrl != null;
  bool get isHidden => author.isVisible == false; // Protect against null
  String _authorUrl(String id) =>
      RoutePaths.author.toUrl(parameters: {idParam: '$id'});

  void onClick() {
      _router.navigate(_authorUrl(author.id));
  }
}
