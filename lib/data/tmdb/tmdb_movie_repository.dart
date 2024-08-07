import 'package:dio/dio.dart';
import 'package:flix_id/data/repositories/movie_repository.dart';
import 'package:flix_id/domain/entities/actor.dart';
import 'package:flix_id/domain/entities/movie.dart';
import 'package:flix_id/domain/entities/movie_detail.dart';
import 'package:flix_id/domain/entities/result.dart';

class TmdbMovieRepository implements MovieRepository {
  final Dio? _dio;
  final String _accesstoken =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5NzZhOGJkYWVkOTllYjQ2ODgyOTFiODhiZTQ3MTY0YiIsIm5iZiI6MTcyMDYxNDc3NS45OTY5MTEsInN1YiI6IjVhMjYxMDkyMGUwYTI2NGNiZTBlM2JiNSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.CVYXxl3Cfkmv1Qwoam0_QiA-U0Tcio4qkqNfPCIcAqA";

  late final Options _options = Options(headers: {
    "Authorization": "Bearer $_accesstoken",
    "accept": "application/json"
  });

  TmdbMovieRepository({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Future<Result<List<Actor>>> getActors({required int id}) async {
    try {
      final response = await _dio!
          .get("https://api.themoviedb.org/3/movie/$id/credits?language=en-US");

      final cast = List<Map<String, dynamic>>.from(response.data["cast"]);

      return Result.success(cast.map((e) => Actor.fromJSON(e)).toList());
    } on DioException catch (e) {
      return Result.failed(e.message ?? "Failed to get actors");
    }
  }

  @override
  Future<Result<MovieDetail>> getDetail({required int id}) async {
    try {
      final response = await _dio!
          .get("https://api.themoviedb.org/3/movie/${id}?language=en-US");

      return Result.success(MovieDetail.fromJSON(response.data));
    } on DioException catch (e) {
      return Result.failed(e.message ?? "Failed to get detail");
    }
  }

  @override
  Future<Result<List<Movie>>> getNowPlaying({int page = 1}) =>
      _getMovies(_MovieCategory.nowPlaying);

  @override
  Future<Result<List<Movie>>> getUpcoming({int page = 1}) =>
      _getMovies(_MovieCategory.upcoming);

  Future<Result<List<Movie>>> _getMovies(_MovieCategory category,
      {int page = 1}) async {
    try {
      final response = await _dio!.get(
          "https://api.themoviedb.org/3/movie/${category.toString()}?language=en-US&page=$page",
          options: _options);
      final results = List<Map<String, dynamic>>.from(response.data["results"]);

      return Result.success(results.map((e) => Movie.fromJSON(e)).toList());
    } on DioException catch (e) {
      return Result.failed("${e.message}");
    }
  }
}

enum _MovieCategory {
  nowPlaying("now_playing"),
  upcoming("upcoming");

  final String _category;

  const _MovieCategory(String category) : _category = category;

  @override
  String toString() => _category;
}
