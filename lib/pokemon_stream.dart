import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PokemonStream {
  late Stream<int> _pokemonIdStream;
  bool _isPaused = false;
  bool _isUppercase = true;
  bool _isActive = true;
  final Set<String> _displayedNames = {};

  PokemonStream() {
    _pokemonIdStream = Stream.periodic(Duration(seconds: 1), (i) => i + 1)
        .asBroadcastStream();
  }


  Future<String> _fetchPokemonName(int id) async {
    final url = Uri.https('pokeapi.co', '/api/v2/pokemon/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['name'];
    } else {
      throw Exception("Failed to load Pokémon with id $id");
    }
  }

 
  StreamTransformer<int, String> _nameTransformer() {
    return StreamTransformer<int, String>.fromHandlers(
      handleData: (id, sink) async {
        if (_isActive) { 
          try {
            final name = await _fetchPokemonName(id);
            sink.add(_formatName(name));
          } catch (e) {
            sink.addError(e);
          }
        }
      },
    );
  }

  void start() {
    _isActive = true; 

    _pokemonIdStream
        .where((id) => !_isPaused && _isActive)
        .transform(_nameTransformer())
        .listen(
          (name) {
            if (!_displayedNames.contains(name)) {
              print("Pokémon: $name");
              _displayedNames.add(name);
            }
          },
          onError: (error) => print("Error: $error"),
          onDone: () => print("Stream finished"),
        );
  }

  void pause() {
    _isPaused = true;
    print("Stream paused");
  }

  void resume() {
    _isPaused = false;
    print("Stream resumed");
  }

  void cancel() {
    _isActive = false;
    print("Stream canceled");
  }

  void filterNames() {
    _isPaused = true;
    _displayedNames.clear();

    print("Filtering started...");

    _pokemonIdStream
        .where((id) => !_isPaused && _isActive)
        .transform(_nameTransformer())
        .where((name) {
          print("Checking Pokémon name: $name");
          return name.startsWith('p');
        })
        .listen(
          (name) {
            if (!_displayedNames.contains(name)) {
              print("Filtered Pokémon: $name");
              _displayedNames.add(name);
            }
          },
          onError: (error) => print("Error: $error"),
          onDone: () => print("Filter stream finished"),
        );
  }

  void transformNames() {
    _isUppercase = !_isUppercase;
    _displayedNames.clear();


    _pokemonIdStream
        .where((id) => !_isPaused && _isActive)
        .transform(_nameTransformer())
        .listen(
          (name) {
            if (!_displayedNames.contains(name)) {
              print("Pokémon: $name");
              _displayedNames.add(name);
            }
          },
          onError: (error) => print("Error: $error"),
          onDone: () => print("Stream finished"),
        );
  }

  String _formatName(String name) {
    return _isUppercase ? name.toUpperCase() : name.toLowerCase();
  }
}
