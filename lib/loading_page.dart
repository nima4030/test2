
import 'package:flutter/material.dart';
import 'package:wordle/game_page.dart';
import 'package:wordle/generator.dart';
import 'package:wordle/validation_provider.dart';
import 'dart:developer' as developer;

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key, required this.dicName, required this.wordLen, required this.maxChances, required this.gameMode}) : super(key: key);

  final String dicName;
  final int wordLen;
  final int maxChances;
  final int gameMode;

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  Future<Map<String, List<String>>> _loadDatabase({required String dicName, required int wordLen, required int gameMode}) async {

    var dataBase = await generateQuestionSet(dicName: dicName, wordLen: wordLen);
    if(ValidationProvider.validationDatabase.isEmpty) {
      ValidationProvider.validationDatabase = await generateDictionary();
    }
    return dataBase;
  }

  @override 
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadDatabase(dicName: widget.dicName, wordLen: widget.wordLen, gameMode: widget.wordLen),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return GamePage(database: snapshot.data as Map<String, List<String>>, wordLen: widget.wordLen, maxChances: widget.maxChances, gameMode: widget.gameMode);
        }
        else {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(
                      color: Colors.teal[400],
                      strokeWidth: 4.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Text('Loading Libraries', style: TextStyle(color: Colors.teal[400], fontWeight: FontWeight.bold, fontSize: 25.0),),
                  ),
                ]
              ),
            ),
          );
        }
      },
    );
  }
}


