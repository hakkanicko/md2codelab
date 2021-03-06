import 'dart:convert';
import 'package:html/dom.dart';

class SingleParsingInfo {
  Map metadata;
  List<Map> documentsForSearch;

  SingleParsingInfo(this.metadata,this.documentsForSearch);
}

/// Model wrapper for the
/// html content related to the markdown content
class MdDocument {
  final String htmlContent;

  MdDocument(this.htmlContent);
}

/// Model related to
/// [google codelab definition](https://github.com/googlecodelabs/codelab-components/blob/master/google-codelab.html)
class Codelab {
  final String metadata;

  /// Codelab title
  final String title;

  /// Steps of the codelab
  final List<Step> steps;

  final List<StepSearch> stepSearch;

  /// Feedback URL for the codelab bug repors.
  String feedbackLink;

  Codelab(this.metadata, this.title, this.steps, this.stepSearch);

  @override
  String toString() => """
  {
    "metadata": "$metadata",
    "title": "$title",
    "steps": $steps,
    "stepSearch": $stepSearch,
    "feedbackLink": $feedbackLink
  }
  """;
}

/// Model related to
/// [google codelab step definition](https://github.com/googlecodelabs/codelab-components/blob/master/google-codelab-step.html).
class Step {

  String order;

  /// Title of this step.
  String label = '';

  /// How long, on average, it takes to complete the step.
  String duration = '0';

  /// Indicate if it is the last of the codelab.
  var isLast = false;

  /// The content as HTMLElement
  Element content = new Element.html("<br/>");

  Step(this.label);

  @override
  String toString() => """
  {
    "order": "$order",
    "label": "$label",
    "duration": "$duration",
    "content": "${content.innerHtml}",
    "isLast": "$isLast",
  }
  """;

  StepSearch getStepSearch(String codelab, String outputFileName) {
    return new StepSearch(codelab, order, label, outputFileName, jsonEncode("${content.innerHtml}"));
  }
}

class StepSearch {
  String codelab;
  String order;
  String title;
  String content;
  String outputFileName;
  String path = "";

  StepSearch(this.codelab, this.order, this.title, this.outputFileName, this.content);

  Map toJson() => {
        'codelab': this.codelab,
        'order': this.order,
        'title': this.title,
        'content': this.content,
        'path': "md/$outputFileName#${int.parse(order) - 1}",
      };

  @override
  String toString() => """
  {
    "codelab": "$codelab",
    "order": "$order",
    "title": "$title",
    "content": "$content",
    "outputFileName": "$outputFileName",
    "path": "$path",
  }
  """;
}
