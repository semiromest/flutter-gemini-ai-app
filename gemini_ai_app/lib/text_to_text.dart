import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gemini_ai_app/apikey.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class TextToText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gemini Generative AI Demo'),
        ),
        body: MyGenerator(apiKey: Apiclass.apiKey),
      ),
    );
  }
}

class MyGenerator extends StatefulWidget {
  final String apiKey;

  MyGenerator({required this.apiKey});

  @override
  _MyGeneratorState createState() => _MyGeneratorState();
}

class _MyGeneratorState extends State<MyGenerator> {
  TextEditingController _textEditingController = TextEditingController();
  String _generatedText = '';
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: 'Promptu buraya girin...',
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _generateContent();
          },
          child: Text('Generate'),
        ),
        SizedBox(height: 20),
        if (_isGenerating)
          CircularProgressIndicator()
        else if (_generatedText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Generated Content: $_generatedText',
              style: TextStyle(fontSize: 12),
            ),
          ),
      ],
    );
  }

  Future<void> _generateContent() async {
    setState(() {
      _isGenerating = true;
    });

    final model = GenerativeModel(model: 'gemini-pro', apiKey: widget.apiKey);
    final content = [Content.text(_textEditingController.text)];
    final response = await model.generateContent(content);

    setState(() {
      _generatedText = response.text ?? "";
      _isGenerating = false;
    });
  }
}
