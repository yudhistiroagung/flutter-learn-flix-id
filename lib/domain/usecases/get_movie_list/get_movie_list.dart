import 'package:flix_id/data/repositories/movie_repository.dart';
import 'package:flix_id/domain/entities/movie.dart';
import 'package:flix_id/domain/entities/result.dart';
import 'package:flix_id/domain/usecases/get_movie_list/get_movie_list_params.dart';
import 'package:flix_id/domain/usecases/usecase.dart';

class GetMovieList implements Usecase<Result<List<Movie>>, GetMovieListParams> {
  final MovieRepository _movieRepository;

  GetMovieList({required MovieRepository movieRepository})
      : _movieRepository = movieRepository;

  @override
  Future<Result<List<Movie>>> call(GetMovieListParams params) async {
    final result = switch (params.category) {
      MovieListCategory.nowPlaying =>
        await _movieRepository.getNowPlaying(page: params.page),
      MovieListCategory.upcoming =>
        await _movieRepository.getUpcoming(page: params.page)
    };

    return switch (result) {
      Success(value: final movies) => Result.success(movies),
      Failed(:final message) => Result.failed(message),
    };
  }
}
