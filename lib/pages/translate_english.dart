import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:clipboard/clipboard.dart';

void main() {
  runApp(MaterialApp(
    home: translate_english(),
  ));
}

class translate_english extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<translate_english> {
  GoogleTranslator translator = new GoogleTranslator();

  String out = "placeholder";
  String inputtext = "placeholder";
  final lang = TextEditingController();

  void trans() {
    translator.translate(lang.text, to: 'en').then((output) {

      setState(() {
        out =
            output.text; //placing the translated text to the String to be used
      });
      print(out);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Translate"),
      ),
      body: Container(
        child: Center(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: lang,
                  onChanged: (value) {
                    setState(() {
                      inputtext = value;
                    });
                  }
                ),
                ElevatedButton(
                  child: Text(
                    "Translate now",

                  ),
                  onPressed: () async{
                    trans();
                    // Add translation to Firestore
                    final FirebaseFirestore firestore = FirebaseFirestore.instance;
                    await firestore.collection('translations').add({
                    'originalText': inputtext,
                     'translatedText': out,
                       'timestamp': FieldValue.serverTimestamp(),
                      });



  },
  ),
  Text('Translated Text: $out'),
  ElevatedButton(
  child: const Text('Copy to Clipboard'),
  onPressed: () {
  FlutterClipboard.copy(out).then((result) {
  const snackBar = SnackBar(
  content: Text('Copied to Clipboard!'),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
  });
  },
  ),


                 //translated string
              ],
            )),
      ),
    );
  }
}

