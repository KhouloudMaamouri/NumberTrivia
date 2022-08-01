import 'package:clean_architecture_project/features/core/plateform/network_info.dart';
import 'package:clean_architecture_project/features/core/util/input_converter.dart';
import 'package:clean_architecture_project/features/number_trivia/data/repositories/number_trivia_impl.dart';
import 'package:clean_architecture_project/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_project/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_project/features/number_trivia/domain/usecases/get_random_trivia.dart';
import 'package:clean_architecture_project/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'features/core/usecases/usecase.dart';
import 'features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import "package:clean_architecture_project/features/number_trivia/domain/entities/number_trivia.dart";

final sl = GetIt.instance;

Future<void> init() async {
//! features - Number trivia
// Bloc
// (We register it as factory because if we have stream closed & we need call bloc another time
// we found that stream is closed or if we have a dispose logic we need put it to factory
  sl.registerFactory<NumberTriviaBloc>(() => NumberTriviaBloc(
      sl<GetConcreteNumberTrivia>(),
      sl<GetRandomTrivia>(),
      sl<InputConverter>()));

  // repository
  sl.registerLazySingleton<NumberTriviaRepository>(() => NumberTriviaImpl(
      localDataSource: sl(), remoteDataSource: sl(), networkInfo: sl()));

  // Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()),
  );

//! Core
  sl.registerLazySingleton<InputConverter>(() => InputConverter());

//! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl<DataConnectionChecker>()));
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());

  // useCases
  sl.registerLazySingleton<GetConcreteNumberTrivia>(
          () => GetConcreteNumberTrivia(sl<NumberTriviaRepository>()));
  sl.registerLazySingleton<GetRandomTrivia>(() => GetRandomTrivia(sl()));

}
