import 'package:flix_id/data/repositories/movie_repository.dart';
import 'package:flix_id/domain/entities/actor.dart';
import 'package:flix_id/domain/entities/result.dart';
import 'package:flix_id/domain/usecases/get_actors/get_actors_params.dart';
import 'package:flix_id/domain/usecases/usecase.dart';

class GetActors implements Usecase<Result<List<Actor>>, GetActorsParams> {
  final MovieRepository _movieRepository;

  GetActors({required MovieRepository movieRepository})
      : _movieRepository = movieRepository;

  @override
  Future<Result<List<Actor>>> call(GetActorsParams params) async {
    return _movieRepository.getActors(id: params.movieId);
  }
}
