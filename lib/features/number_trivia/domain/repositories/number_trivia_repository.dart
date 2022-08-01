import 'package:clean_architecture_project/features/core/error/Failures.dart';
import 'package:clean_architecture_project/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';

abstract class NumberTriviaRepository {
 Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
 Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}