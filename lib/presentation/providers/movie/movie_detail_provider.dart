import 'package:flix_id/domain/entities/movie.dart';
import 'package:flix_id/domain/entities/movie_detail.dart';
import 'package:flix_id/domain/entities/result.dart';
import 'package:flix_id/domain/usecases/get_movie_detail/get_movie_detail.dart';
import 'package:flix_id/domain/usecases/get_movie_detail/get_movie_detail_params.dart';
import 'package:flix_id/presentation/providers/usecases/get_movie_detail_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movie_detail_provider.g.dart';

@Riverpod()
Future<MovieDetail?> movieDetail(MovieDetailRef ref,
    {required Movie movie}) async {
  GetMovieDetail getMovieDetail = ref.read(getMovieDetailProvider);

  final result = await getMovieDetail(GetMovieDetailParams(movieId: movie.id));

  return switch (result) {
    Success(value: final movieDetail) => movieDetail,
    Failed(message: _) => null
  };
}
