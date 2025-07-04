import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TestApiScreen extends StatefulWidget {
  @override
  _TestApiScreenState createState() => _TestApiScreenState();
}

class _TestApiScreenState extends State<TestApiScreen> {
  String _result = 'Presiona el botón para probar';
  bool _loading = false;

  Future<void> _testProductos() async {
    setState(() {
      _loading = true;
      _result = 'Cargando...';
    });

    try {
      final uri = Uri.parse('http://localhost:8080/api/inventario/productos');
      print('🔍 Probando: $uri');
      
      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });

      print('📡 Status: ${response.statusCode}');
      print('🔧 Headers: ${response.headers}');
      print('📋 Body: ${response.body}');

      setState(() {
        _result = '''
Status: ${response.statusCode}
Headers: ${response.headers}
Body: ${response.body}
''';
      });
    } catch (e) {
      print('❌ Error: $e');
      setState(() {
        _result = 'Error: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test API')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _loading ? null : _testProductos,
              child: _loading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Probar API Productos'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _result,
                    style: TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
