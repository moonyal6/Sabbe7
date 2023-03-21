import 'package:flutter/material.dart';
import 'package:language_builder/language_builder.dart';

import '../../../../main.dart';
import '../../../../shared/constants/text_constants/turkish_text_constants.dart';


void showErrorDialog(BuildContext context, {String? text, String? title}){
  Map<String, dynamic> _pageText = LanguageBuilder.texts!['@auth_pages']['@error_dialog'];

  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: Color(0xff1c1a1a),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18)
      ),
      title:  Text('${title ?? _pageText['title']}'),
      content: Text(text ?? _pageText['content']) ,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(_pageText['button']),
        ),
      ],
    ),
  );
}