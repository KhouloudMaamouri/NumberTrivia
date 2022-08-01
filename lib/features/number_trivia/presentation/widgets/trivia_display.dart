import 'package:clean_architecture_project/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter/cupertino.dart';

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia mNumberTrivia;

  const TriviaDisplay({
    Key? key,
    required this.mNumberTrivia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: <Widget>[
          Text(
            mNumberTrivia.number.toString(),
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  mNumberTrivia.text,
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
