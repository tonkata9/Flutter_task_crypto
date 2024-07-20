import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Retrieve Text Input',
      home: MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final myController = TextEditingController();
  String _cryptoPrice = '';

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  Future<void> fetchCryptoPrice() async {
    final response = await http.post(
      Uri.parse('http://localhost:3001/crypto-price'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'symbol': myController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _cryptoPrice = data['price'].toString();
      });
    } else {
      setState(() {
        _cryptoPrice = 'Failed to load price';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Crypto Price Checker'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: myController,
                      decoration: const InputDecoration(
                        labelText: 'Enter crypto symbol',
                        hintText: 'for example, ETH',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 25),
                  FloatingActionButton(
                    onPressed: fetchCryptoPrice,
                    child: const Text('Enter'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_cryptoPrice.isNotEmpty)
                Text(
                  'Price: $_cryptoPrice USD',
                  style: const TextStyle(fontSize: 24),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
