import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:clean_architecture_project/features/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:clean_architecture_project/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {

  final http.Client client;
  NumberTriviaRemoteDataSourceImpl({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async => _getTriviaFromUrl(number.toString());


  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async => _getTriviaFromUrl("random");


  Future<NumberTriviaModel> _getTriviaFromUrl(String endpoint) async{
    var url =  Uri.parse('http://numbersapi.com/$endpoint');

    final response = await client.get(url, headers: {
      'Content-Type':'application/json'
    });

    if(response.statusCode == 200){
      return NumberTriviaModel.fromJson(json.decode(response.body));
    }else{
      throw ServerException();
    }
  }
}