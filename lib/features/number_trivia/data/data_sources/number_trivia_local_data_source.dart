import 'dart:convert';
import 'dart:math';

import 'package:clean_architecture_project/features/core/error/exceptions.dart';
import 'package:clean_architecture_project/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    sharedPreferences.setString(CACHED_NUMBER_TRIVIA, jsonEncode(triviaToCache.toJson()));
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() async {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if(jsonString != null){
    return  Future.value(
          NumberTriviaModel.fromJson(json.decode(jsonString)));
    }else {
      throw CacheException();
    }
  }
}
