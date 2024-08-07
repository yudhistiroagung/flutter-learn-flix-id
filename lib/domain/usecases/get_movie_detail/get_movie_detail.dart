import 'package:flix_id/data/repositories/movie_repository.dart';
import 'package:flix_id/domain/entities/movie_detail.dart';
import 'package:flix_id/domain/entities/result.dart';
import 'package:flix_id/domain/usecases/get_movie_detail/get_movie_detail_params.dart';
import 'package:flix_id/domain/usecases/usecase.dart';

class GetMovieDetail
    implements Usecase<Result<MovieDetail>, GetMovieDetailParams> {
  final MovieRepository _movieRepository;

  GetMovieDetail({required MovieRepository movieRepository})
      : _movieRepository = movieRepository;

  @override
  Future<Result<MovieDetail>> call(GetMovieDetailParams params) async {
    return _movieRepository.getDetail(id: params.movieId);
  }
}
