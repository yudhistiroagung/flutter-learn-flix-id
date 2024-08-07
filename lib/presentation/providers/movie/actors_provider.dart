import 'package:flix_id/domain/entities/actor.dart';
import 'package:flix_id/domain/entities/result.dart';
import 'package:flix_id/domain/usecases/get_actors/get_actors.dart';
import 'package:flix_id/domain/usecases/get_actors/get_actors_params.dart';
import 'package:flix_id/presentation/providers/usecases/get_actors_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'actors_provider.g.dart';

@Riverpod()
Future<List<Actor>> actors(ActorsRef ref, {required int movieId}) async {
  GetActors getActors = ref.read(getActorsProvider);

  final result = await getActors(GetActorsParams(movieId: movieId));

  return switch (result) {
    Success(value: final actors) => actors,
    Failed(message: _) => const []
  };
}
