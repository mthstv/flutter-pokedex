import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "helpers/string_extension.dart";

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const Pokedex(title: 'Pokédex'),
    );
  }
}

class Pokedex extends StatefulWidget {
  const Pokedex({super.key, required this.title});

  final String title;

  @override
  State<Pokedex> createState() => _PokedexState();
}

class _Pokemon {
  int _number = 0;
  String _name = '';
  String _sprite = '';
  List _types = [];

  void _setPokemonData(int number, String name, String sprite, List types) {
    _number = number;
    _name = name;
    _sprite = sprite;
    _types = types;
  }

  String _getPokemonData() {
    String numberValue = "Number: ${_number.toString()}";
    String nameValue = "Name: ${_name.capitalize()}";
    String typeValue = "Types: ${_types[0]['type']['name']}";
    String secondaryTypeValue = (_types.length > 1 ? ' & ${_types[1]['type']['name']}' : '');

    return '$numberValue\n$nameValue\n\n$typeValue$secondaryTypeValue';
  }
}

class _PokedexState extends State<Pokedex> {
  TextEditingController userSearchInput = TextEditingController();
  _Pokemon pokemon = _Pokemon();

  void _getPokemon() async {
    String searchString = userSearchInput.text;
    String url = 'https://pokeapi.co/api/v2/pokemon/$searchString';

    http.Response response;
    response = await http.get(Uri.parse(url));

    Map<String, dynamic> pokemonData = json.decode(response.body);

    setState(() {
      pokemon._setPokemonData(
        pokemonData['id'],
        pokemonData['name'],
        pokemonData['sprites']['front_default'],
        pokemonData['types']
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Search for a Pokémon by number or name'
              ),
              style: TextStyle(fontSize: 15),
              controller: userSearchInput,
            ),
            ElevatedButton(
              onPressed: _getPokemon,
              child: Text('Search', style: TextStyle(fontSize: 15))
            ),
            Image(
              image: NetworkImage(pokemon._sprite),
            ),
            Text(pokemon._getPokemonData()),
          ],
        ),
      ),
    );
  }
}
