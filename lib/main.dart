import 'package:flutter/material.dart';
import 'pokemon_stream.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon Stream Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PokemonStreamDemo(),
    );
  }
}

class PokemonStreamDemo extends StatefulWidget {
  @override
  _PokemonStreamDemoState createState() => _PokemonStreamDemoState();
}

class _PokemonStreamDemoState extends State<PokemonStreamDemo> {
  late PokemonStream pokemonStream;

  @override
  void initState() {
    super.initState();
    pokemonStream = PokemonStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pokémon Stream Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: pokemonStream.start,
              child: Text('Start Pokémon Stream'),
            ),
            ElevatedButton(
              onPressed: pokemonStream.pause,
              child: Text('Pause Stream'),
            ),
            ElevatedButton(
              onPressed: pokemonStream.resume,
              child: Text('Resume Stream'),
            ),
            ElevatedButton(
              onPressed: pokemonStream.cancel,
              child: Text('Cancel Stream'),
            ),
            ElevatedButton(
              onPressed: pokemonStream.filterNames,
              child: Text('Filter Pokémon Names'),
            ),
            ElevatedButton(
              onPressed: pokemonStream.transformNames,
              child: Text('Transform Pokémon Names'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    pokemonStream.cancel();
    super.dispose();
  }
}
