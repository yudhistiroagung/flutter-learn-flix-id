enum MovieListCategory { nowPlaying, upcoming }

class GetMovieListParams {
  final int page;
  final MovieListCategory category;

  GetMovieListParams({this.page = 1, required this.category});
}
