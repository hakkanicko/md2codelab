import 'models.dart';
import 'package:html/parser.dart' as html5parser;
import 'package:html/dom.dart';
import 'package:intl/intl.dart';

/// Check if the given [node] is a duration
bool _isDuration(Element node) =>
    node.innerHtml.startsWith("<duration>") &&
    node.innerHtml.endsWith("</duration>");

/// Check if the given [node] is an info alert
bool _isAlertInfo(Element node) =>
    node.innerHtml.startsWith("<alert-info>") &&
    node.innerHtml.endsWith("</alert-info>");

/// Check if the given [node] is a warning alert
bool _isAlertWarning(Element node) =>
    node.innerHtml.startsWith("<alert-warning>") &&
    node.innerHtml.endsWith("</alert-warning>");

/// Check if the given [node] is a danger alert
bool _isAlertDanger(Element node) =>
    node.innerHtml.startsWith("<alert-danger>") &&
    node.innerHtml.endsWith("</alert-danger>");

/// Get the define duration form the given [innerHtml]
String _getDuration(String innerHtml) {
  DateFormat format = new DateFormat("H:mm");
  String text = innerHtml.replaceFirst("<duration>", "");
  text = text.replaceFirst("</duration>", "");

  DateTime datetime = format.parse(text.trim());
  return datetime.minute.toString();
}

/// Get the define info alert form the given [innerHtml]
String _getAlertInfo(String innerHtml) => """
  <div class="alert alert-primary flexbox-it" role="alert">
    <div> <span title="Note" class="oi oi-info oi-custom"></span></div>
    <div>$innerHtml</div>
  </div>
""";

/// Get the define warning alert form the given [innerHtml]
String _getAlertWarning(String innerHtml) => """
  <div class="alert alert-warning flexbox-it" role="alert">
    <div> <span title="Warning" class=" oi oi-warning oi-custom"></span></div>
    <div>$innerHtml</div>
  </div>
""";

/// Get the define danger alert form the given [innerHtml]
String _getAlertDanger(String innerHtml) => """
  <div class="alert alert-danger flexbox-it" role="alert">
    <div> <span title="Important" class=" oi oi-fire oi-custom"></span></div>
    <div>$innerHtml</div>
  </div>
""";

/// Parse the given [htmlContent] to a codelab
Codelab parse(String htmlContent) {
  Document document = html5parser.parse(htmlContent);
  Element body = document.body;

  int stepSize = body.querySelectorAll("h2").length;
  int index = 0;
  Step currentStep;
  List<Step> steps = [];

  body.nodes.forEach((node) {
    if (node is Element) {
      if (node.localName == "h2") {
        index++;
        currentStep = new Step(node.innerHtml);
        if (index == stepSize) {
          currentStep.isLast = true;
        }
        steps.add(currentStep);
      } else if (currentStep != null) {
        // Duration
        if (_isDuration(node)) {
          currentStep.duration = _getDuration(node.innerHtml);
        } else {
          // alert info
          if (_isAlertInfo(node)) {
            node.innerHtml = _getAlertInfo(node.innerHtml);
          }
          // alert warning
          if (_isAlertWarning(node)) {
            node.innerHtml = _getAlertWarning(node.innerHtml);
          }
          // alert danger
          if (_isAlertDanger(node)) {
            node.innerHtml = _getAlertDanger(node.innerHtml);
          }

          currentStep.content.append(node.clone(true));
        }
      }
    }
  });

  String title = body.querySelector("h1").innerHtml;

  return new Codelab(title, steps);
}