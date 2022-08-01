import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clean_architecture_project/features/core/error/Failures.dart';
import 'package:clean_architecture_project/features/core/usecases/usecase.dart';
import 'package:clean_architecture_project/features/core/util/input_converter.dart';
import 'package:clean_architecture_project/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../domain/usecases/get_concrete_number_trivia.dart';
import '../../domain/usecases/get_random_trivia.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';
const String INVALID_INPUT_FORMAT_FAILURE_MESSAGE =
    'Invalid Format Input - Must be a number';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomTrivia getRandomTrivia;
  final InputConverter inputValidator;

  NumberTriviaBloc(
      this.getConcreteNumberTrivia, this.getRandomTrivia, this.inputValidator)
      : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetTriviaForConcreteNumber) {
        emit(Loading());
        final inputEither =
            await inputValidator.stringToUnsignedInteger(event.numberString);

        await inputEither.fold((failure) {
          if(failure is InvalidFormatFailure){
            emit(Error(message: INVALID_INPUT_FORMAT_FAILURE_MESSAGE));
          }else if (failure is InvalidInputFailure){
            emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE));
          }
        }, (integer) async {
          final failureOrTrivia =
              await getConcreteNumberTrivia(Params(number: integer));

          failureOrTrivia.fold(
              (failure) => emit(Error(message: _mapFailureToMessage(failure))),
              (trivia) => emit(Loaded(trivia: trivia)));
        });
      } else if (event is GetTriviaForRandomNumber) {
        emit(Loading());
        final failureOrRandomTrivia = await getRandomTrivia(NoParams());

        failureOrRandomTrivia.fold((failure) => _mapFailureToMessage(failure),
            (trivia) => emit(Loaded(trivia: trivia)));
      }
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return "Unexpected error";
    }
  }
}
