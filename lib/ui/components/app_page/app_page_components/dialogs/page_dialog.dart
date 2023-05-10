import 'package:flutter/material.dart';
import 'package:language_builder/language_builder.dart';


class PageDialog extends StatelessWidget {
  PageDialog({required this.title, this.content, this.actions, this.contentText});

  final String title;
  final Widget? content;
  final String? contentText;
  final List<Widget>? actions;

  static void showErrorDialog(BuildContext context,
      {String? errorText, String? title})
  {
    final Map<String, dynamic> _pageText = LanguageBuilder
        .texts!['@auth_pages']['@error_dialog'];

    showDialog<String>(
      context: context,
      builder: (BuildContext context) =>
          PageDialog(
            title: title ?? _pageText['title'],
            content: Text(errorText ?? _pageText['content']),
          )
    );
  }


  static void showPageDialog(BuildContext context,
      {String? contentText, Widget? content, String? title, List<Widget>? actions})
  {
    final Map<String, dynamic> _pageText = LanguageBuilder
        .texts!['@auth_pages']['@error_dialog'];

    showDialog<String>(
        context: context,
        builder: (BuildContext context) =>
            PageDialog(
              title: title ?? _pageText['title'],
              content: content,
              contentText: contentText ?? _pageText['content'],
              actions: actions,
            )
    );
  }


  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> _pageText = LanguageBuilder
        .texts!['@auth_pages']['@error_dialog'];

    return AlertDialog(
      title: Text(title),
      content: content ?? Text(contentText!),
      backgroundColor: Color(0xff1c1a1a),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18)
      ),
      actions: actions ?? <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(_pageText['button']),
        ),
      ],
    );
  }
}





