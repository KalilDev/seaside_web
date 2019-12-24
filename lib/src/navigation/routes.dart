import 'package:angular_router/angular_router.dart';

import 'route_paths.dart';
import 'package:seaside_web/src/views/author_page_component.template.dart' as author_page;
import 'package:seaside_web/src/views/content_page_component.template.dart' as content_page;
import 'package:seaside_web/src/views/edit_author_page_component.template.dart' as edit_author_page;
import 'package:seaside_web/src/views/edit_content_page_component.template.dart' as edit_content_page;
import 'package:seaside_web/src/views/home_page_component.template.dart' as home_page;
import 'package:seaside_web/src/views/settings_page_component.template.dart' as settings_page;
import 'package:seaside_web/src/views/tag_page_component.template.dart' as tag_page;
export 'route_paths.dart';

class Routes {
  static final home = RouteDefinition(
    routePath: RoutePaths.home,
    component: home_page.HomePageNgFactory,
  );

  static final settings = RouteDefinition(
    routePath: RoutePaths.settings,
    component: settings_page.SettingsPageNgFactory,
  );

  static final content = RouteDefinition(
    routePath: RoutePaths.content,
    component: content_page.ContentPageNgFactory,
  );

  static final editText = RouteDefinition(
    routePath: RoutePaths.editText,
    component: edit_content_page.EditContentPageNgFactory,
  );

  static final createText = RouteDefinition(
    routePath: RoutePaths.createText,
    component: edit_content_page.EditContentPageNgFactory,
  );

  static final author = RouteDefinition(
    routePath: RoutePaths.author,
    component: author_page.AuthorPageNgFactory,
  );

  static final editAuthor = RouteDefinition(
    routePath: RoutePaths.author,
    component: edit_author_page.EditAuthorPageNgFactory,
  );

  static final tag = RouteDefinition(
    routePath: RoutePaths.tag,
    component: tag_page.TagPageNgFactory,
  );

  static final all = <RouteDefinition>[
    home,
    settings,
    content,
    editText,
    createText,
    author,
    editAuthor,
    tag,
    RouteDefinition.redirect(
      path: '',
      redirectTo: RoutePaths.home.toUrl(),
    ),
  ];
}
