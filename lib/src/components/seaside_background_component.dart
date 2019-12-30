import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/utils/color/color.dart';
import 'package:seaside_web/src/components.dart';
import 'dart:html';
import 'dart:math' show pow;

double lerpDouble(num a, num b, double t) {
  if (a == null && b == null)
    return null;
  a ??= 0.0;
  b ??= 0.0;
  return a + (b - a) * t;
}

@Component(
  selector: 'seaside-background',
  styleUrls: ['seaside_background_component.css'],
  templateUrl: 'seaside_background_component.html',
  directives: [
  ],
)

class SeasideBackground implements OnInit {
  @ViewChild('backgroundHolder')
  DivElement backgroundHolder;

  CanvasRenderingContext2D context;
  
  @override
  void ngOnInit() {
    draw();
    // We need to redraw on resize and on color scheme change.
    window.onResize.listen((_)=>draw());
    window.matchMedia("(prefers-color-scheme: dark)").onChange.listen((_)=>draw());
  }

  void draw() {
    final isDark = window.matchMedia("(prefers-color-scheme: dark)").matches;
    final style = backgroundHolder.getComputedStyle();
    final background = Color.parse(style.getPropertyValue('--background-color').substring(1));
    final rawAccent = Color.parse(style.getPropertyValue('--secondary').substring(1));
    final accent = alphaBlend(rawAccent.withAlpha(isDark ? 80/255 : 100/255), background);
    // To draw the seaside waves we need to know the width and the height.
    final x = window.visualViewport.width.round();
    final y = window.visualViewport.height.round();
    // Good! now we have to draw each of the canvases.
    const int length = 4;
    for (int i=0; i<length; i++) {
      final canvas = backgroundHolder.children[i] as CanvasElement;
      // Code imported from background_painter.dart
      List<double> numbers =
          List<double>.generate(length + 1, (int i) => pow(1.2, i));
      final heightTotal = numbers.reduce((n1, n2) => n1 + n2);
      final partOfTotal =
          numbers.sublist(1, i + 2).reduce((n1, n2) => n1 + n2) / heightTotal;
      final color = Color.lerp(background, accent, partOfTotal);
      final basicHeight = y * partOfTotal;
      canvas.height = y;
      canvas.width = x;
      final context = canvas.context2D;
      context.setFillColorRgb(color.red, color.green, color.blue);
      final waveCount = length + 2 - i;
      final amplitudeCoefficient = 1 / (waveCount + (partOfTotal));
      final waveWidth = x / waveCount;
      final waveAmplitude = amplitudeCoefficient * waveWidth;
      print('i: $i x: $x y: $y basicHeight: $basicHeight waveWidth: $waveWidth waveAmplitude: $waveAmplitude');
      context..beginPath()..moveTo(0, basicHeight);
      for (int w = 0; w < waveCount; w++) {
        final tgtWidth = waveWidth * (w + 1);
        context.quadraticCurveTo(
            tgtWidth - waveWidth / 2,
            basicHeight + (w.isEven ? waveAmplitude : -waveAmplitude),
            tgtWidth,
            basicHeight);
      }
      context
        ..lineTo(x, y + y / 4)
        ..lineTo(0, y + y / 4)
        ..lineTo(0, basicHeight)
        ..closePath()
        ..fill();
    }
  }
}


/// Combine the foreground color as a transparent color over top
/// of a background color, and return the resulting combined color.
///
/// This uses standard alpha blending ("SRC over DST") rules to produce a
/// blended color from two colors. This can be used as a performance
/// enhancement when trying to avoid needless alpha blending compositing
/// operations for two things that are solid colors with the same shape, but
/// overlay each other: instead, just paint one with the combined color.
Color alphaBlend(Color foreground, Color background) {
  final int alpha = (foreground.alpha * 0xFF).round();
  if (alpha == 0x00) {
    // Foreground completely transparent.
    return background;
  }
  final int invAlpha = 0xff - alpha;
  int backAlpha = (background.alpha * 0xFF).round();
  if (backAlpha == 0xff) {
    // Opaque background case
    return Color.rgba(
      (alpha * foreground.red + invAlpha * background.red) ~/ 0xff,
      (alpha * foreground.green + invAlpha * background.green) ~/ 0xff,
      (alpha * foreground.blue + invAlpha * background.blue) ~/ 0xff,
      1.0
    );
  } else {
    // General case
    backAlpha = (backAlpha * invAlpha) ~/ 0xff;
    final int outAlpha = alpha + backAlpha;
    assert(outAlpha != 0x00);
    return Color.rgba(
      (foreground.red * alpha + background.red * backAlpha) ~/ outAlpha,
      (foreground.green * alpha + background.green * backAlpha) ~/ outAlpha,
      (foreground.blue * alpha + background.blue * backAlpha) ~/ outAlpha,
      outAlpha ~/ 0xFF,
    );
  }
}