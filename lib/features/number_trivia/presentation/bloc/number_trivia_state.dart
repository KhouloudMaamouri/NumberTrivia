part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

class Empty extends NumberTriviaState {
  @override
  List<Object> get props => [];
}


class Loading extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class Loaded extends NumberTriviaState {
  @override
  List<Object> get props => [trivia];

    final NumberTrivia trivia;

    Loaded({required this.trivia});
}

class Error extends NumberTriviaState {
  @override
  List<Object> get props => [String];

  final String message;

  Error({required this.message});
}