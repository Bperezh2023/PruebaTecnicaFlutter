import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'Imagenes.dart';

// Modelo de datos para el cliente
class Cliente {
  final String nombre;
  final String dpi;
  final String prestamo;
  final String fud;

  Cliente({
    required this.nombre,
    required this.dpi,
    required this.prestamo,
    required this.fud,
  });
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Clientes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  bool _loginError = false;

  Future<void> _iniciarSesion() async {
    if (_usuarioController.text == 'user' && _contrasenaController.text == 'password') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomePage()),
      );
    } else {
      setState(() {
        _loginError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesión'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usuarioController,
              decoration: InputDecoration(
                labelText: 'Usuario',
              ),
            ),
            TextField(
              controller: _contrasenaController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
              ),
            ),
            SizedBox(height: 10.0),
            if (_loginError)
              Text(
                'Usuario o contraseña incorrectos',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _iniciarSesion,
              child: Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Cliente> clientes = [];

  @override
  void initState() {
    super.initState();
    cargarClientes();
  }

  Future<void> cargarClientes() async {
    final String response = await rootBundle.loadString('assets/archivo.json');
    var jsonData = await json.decode(response);
    var tablaV = jsonData['tablav'];
    List<Cliente> listaClientes = [];
    for (var item in tablaV) {
      String nombre = item['NOMBRE_CLIENTE'];
      String dpi = item['DPI'];
      String prestamo = item['PRESTAMO'];
      String fud = item['FUD_CLIENTE'];

      Cliente cliente = Cliente(
        nombre: nombre,
        dpi: dpi,
        prestamo: prestamo,
        fud: fud,
      );

      listaClientes.add(cliente);
    }

    setState(() {
      clientes = listaClientes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Lista de Clientes'),
        actions: [
          IconButton(
            icon: Icon(Icons.slideshow),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (BuildContext context) => ImageCarouselPage()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: clientes.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(clientes[index].nombre),
            subtitle: Text('DPI: ${clientes[index].dpi}'),
            leading: IconButton(
              icon: Icon(Icons.account_box),
              onPressed: () {},
            ),
            onTap: () {
              // Mostrar ventana flotante con el detalle del cliente
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Detalle del Cliente'),
                    content: Container(
                      constraints: BoxConstraints(maxHeight: 300), // Ajusta la altura máxima según tus necesidades
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nombre: ${clientes[index].nombre}'),
                            Text('DPI: ${clientes[index].dpi}'),
                            Text('Préstamo: ${clientes[index].prestamo}'),
                            Text('FUD: ${clientes[index].fud}'),
                          ],
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Cerrar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
