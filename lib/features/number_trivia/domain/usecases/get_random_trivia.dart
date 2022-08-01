import 'package:clean_architecture_project/features/core/error/Failures.dart';
import 'package:clean_architecture_project/features/core/usecases/usecase.dart';
import 'package:clean_architecture_project/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_project/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class GetRandomTrivia implements UseCase<NumberTrivia, NoParams>{

  final NumberTriviaRepository repository;

  GetRandomTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams noParams) async {
    return await repository.getRandomNumberTrivia();
  }

}

