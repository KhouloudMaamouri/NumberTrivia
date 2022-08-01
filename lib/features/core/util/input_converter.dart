import 'package:dartz/dartz.dart';

import '../error/Failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) throw InvalidInputFailure();
      return Right(integer);
    } on InvalidInputFailure {
      return Left(InvalidInputFailure());
    } on FormatException {
      return Left(InvalidFormatFailure());
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class InvalidFormatFailure extends Failure {
  @override
  List<Object?> get props => [];
}