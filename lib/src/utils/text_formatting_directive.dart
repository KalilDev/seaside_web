import 'dart:html';

import 'package:angular/angular.dart';


Map<int, int> _iterate(List<Match> list) {
  final Map<int, int> periods = <int, int>{};
  int i = 0;
  while (i * 2 < list.length) {
    periods[list[i * 2].end] = list[(i * 2) + 1].start;
    i++;
  }
  return periods;
}

String formattedText(String _text) {
  final String text =
      _text.replaceAll('\^TAB', '').replaceAll('<', '');
  final RegExp italicRegex = RegExp(r'\_');
  final RegExp boldRegex = RegExp(r'\*');
  final RegExp strikeRegex = RegExp(r'\~');
  final RegExp monoRegex = RegExp(r'\`');

  final Map<int, int> italic = _iterate(italicRegex.allMatches(text).toList());
  final Map<int, int> bold = _iterate(boldRegex.allMatches(text).toList());
  final Map<int, int> strike = _iterate(strikeRegex.allMatches(text).toList());
  final Map<int, int> mono = _iterate(monoRegex.allMatches(text).toList());

  final Map<int, int> allMap = <int, int>{};
  if (italic != null) allMap.addAll(italic);
  if (bold != null) allMap.addAll(bold);
  if (strike != null) allMap.addAll(strike);
  if (mono != null) allMap.addAll(mono);

  final List<int> all = allMap.keys.toList();
  all.sort();

  String html = '';
  int spanBoundary = 0;
  int i = 0;

  do {
    if (all.length - 1 < i) {
      html+=text.substring(spanBoundary, text.length);
      return html.splitMapJoin('\^NL', onMatch: (_) => '', onNonMatch: (String s)=> '<p>' + s + '</p>');
    } else {
      final int startIdx = all[i];

      if (startIdx > spanBoundary) {
        html+=text.substring(spanBoundary, startIdx - 1);
      }

      if (italic.containsKey(startIdx)) {
        html+='<i>' + text.substring(startIdx, italic[startIdx]) + '</i>';
        spanBoundary = italic[startIdx] + 1;
      } else if (bold.containsKey(startIdx)) {
        html+='<b>' + text.substring(startIdx, bold[startIdx]) + '</b>';
        spanBoundary = bold[startIdx] + 1;
      } else if (strike.containsKey(startIdx)) {
        html+='<del>' + text.substring(startIdx, strike[startIdx]) + '</del>';
        spanBoundary = strike[startIdx] + 1;
      } else if (mono.containsKey(startIdx)) {
        final String monoText = text.substring(startIdx, mono[startIdx]);
        html+='<code>' + monoText + '</code>';
        spanBoundary = mono[startIdx] + 1;
      }
      i++;
    }
  } while (spanBoundary < text.length);
  // Ok, now we need to process the new paragraphs
  return html.splitMapJoin('\^NL', onMatch: (_) => '', onNonMatch: (String s) => '<p>' + s + '</p>');
}

@Directive(selector: '[formattedText]')
class TextFormattingDirective {
  @Input('formattedText')
  String marked;

  TextFormattingDirective(Element el) {
      if (marked == null)
        return;
      final html = formattedText(marked);
      el.setInnerHtml(html);
  }
}