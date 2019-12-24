import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:seaside_web/src/components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:seaside_web/src/navigation/route_paths.dart';

@Component(
  selector: 'content-page',
  styleUrls: ['content_page_component.css'],
  templateUrl: 'content_page_component.html',
  directives: [
  ],
)
class ContentPage implements OnActivate {
  String tag;
  @override
  void onActivate(_, RouterState current) async {
    tag = getId(current.parameters);
    //if (tag != null) hero = await (_heroService.get(id));
  }
}