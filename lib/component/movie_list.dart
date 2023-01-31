import 'package:flutter/material.dart';
import 'http_helper.dart';
import 'movie_detail.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  late String result;
  late HttpHelper helper;
  late int moviesCount;
  late List movies;
  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';
  Icon visibleIcon = const Icon(Icons.search);
  Widget searchBar = const Text('Movies');

  @override
  void initState() {
    helper = HttpHelper();
    initialize();
    super.initState();
  }

  Future search(text) async {
    movies = await helper.findMovies(text);
    setState(() {
      moviesCount = movies.length;
      movies = movies;
    });
  }

  Future initialize() async {
    moviesCount = 0;
    movies = [];
    helper = HttpHelper();
    List moviesFromAPI = [];
    moviesFromAPI = await helper.getUpcoming();
    setState(() {
      movies = moviesFromAPI;
      moviesCount = movies.length;
    });
  }

  Future topMovieList() async {
    moviesCount = 0;
    movies = [];
    helper = HttpHelper();
    List moviesFromAPI = [];
    moviesFromAPI = await helper.topRated();
    setState(() {
      movies = moviesFromAPI;
      moviesCount = movies.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage image;
    return Scaffold(
        appBar: AppBar(title: searchBar, actions: <Widget>[
          IconButton(
            icon: visibleIcon,
            onPressed: () {
              setState(() {
                if (visibleIcon.icon == Icons.search) {
                  visibleIcon = const Icon(Icons.cancel);
                  searchBar = TextField(
                    textInputAction: TextInputAction.search,
                    onSubmitted: (String text) {
                      search(text);
                    },
                    decoration:
                        const InputDecoration(hintText: 'Ketik Kata Pencarian'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  );
                } else {
                  setState(() {
                    visibleIcon = const Icon(Icons.search);
                    searchBar = const Text('Daftar Film');
                  });
                }
              });
            },
          ),
        ]),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: const Text('Upcoming'),
                onTap: (() {
                  Navigator.pop(context);
                  setState(() {
                    visibleIcon = const Icon(Icons.search);
                    searchBar = const Text('Daftar Film');
                  });
                  initialize();
                }),
              ),
              ListTile(
                title: const Text('Cari'),
                onTap: (() {
                  Navigator.pop(context);
                  setState(() {
                    visibleIcon = const Icon(Icons.cancel);
                    searchBar = TextField(
                      autofocus: true,
                      onSubmitted: (String text) {
                        search(text);
                      },
                      decoration: const InputDecoration(
                          hintText: 'Ketik kata pencarian'),
                      textInputAction: TextInputAction.search,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    );
                  });
                }),
              ),
              ListTile(
                title: const Text('Top Rate'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    visibleIcon = const Icon(Icons.search);
                    searchBar = const Text("Daftar Film Rating Tinggi");
                  });
                  topMovieList();
                },
              )
            ],
          ),
        ),
        body: ListView.builder(
            // ignore: unnecessary_null_comparison
            itemCount: (moviesCount == null) ? 0 : moviesCount,
            itemBuilder: (BuildContext context, int position) {
              if (movies[position].posterPath != null) {
                image = NetworkImage(iconBase + movies[position].posterPath);
              } else {
                image = NetworkImage(defaultImage);
              }
              return Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: ListTile(
                    onTap: () {
                      MaterialPageRoute route = MaterialPageRoute(
                          builder: (_) => MovieDetail(movies[position]));
                      Navigator.push(context, route);
                    },
                    leading: CircleAvatar(
                      backgroundImage: image,
                    ),
                    title: Text(movies[position].title),
                    // ignore: prefer_interpolation_to_compose_strings
                    subtitle: Text(
                        // ignore: prefer_interpolation_to_compose_strings
                        '${'Released: ' + movies[position].releaseDate} - Vote: ${movies[position].voteAverage}'),
                  ));
            }));
  }
}
