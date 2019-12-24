import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:seaside_web/src/components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:seaside_web/src/navigation/route_paths.dart';

@Component(
  selector: 'author-page',
  styleUrls: ['author_page_component.css'],
  templateUrl: 'author_page_component.html',
  directives: [
  ],
)
class AuthorPage implements OnActivate {
  String tag;
  @override
  void onActivate(_, RouterState current) async {
    tag = getId(current.parameters);
    //if (tag != null) hero = await (_heroService.get(id));
  }
}
