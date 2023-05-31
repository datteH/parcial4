import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parcial4_2565882012/models/vuelo.dart';

class VuelosPage extends StatefulWidget {
  @override
  _VuelosScreenState createState() => _VuelosScreenState();
}

class _VuelosScreenState extends State<VuelosPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference vuelosCollection =
      FirebaseFirestore.instance.collection('vuelos');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Vuelos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: vuelosCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error al obtener los vuelos');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          List<QueryDocumentSnapshot> vuelos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: vuelos.length,
            itemBuilder: (context, index) {
              final vuelo = vuelos[index];

              return ListTile(
                title: Text(vuelo['avion']),
                subtitle: Text(vuelo['destinos']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        editarVuelo(vuelo.id);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        eliminarVuelo(vuelo.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AgregarVueloScreen()),
          );
        },
      ),
    );
  }

  void eliminarVuelo(String vueloId) async {
    try {
      await vuelosCollection.doc(vueloId).delete();
      print('Vuelo eliminado exitosamente');
    } catch (error) {
      print('Error al eliminar el vuelo: $error');
    }
  }

  void editarVuelo(String vueloId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarVueloScreen(vueloId: vueloId),
      ),
    );
  }
}

class AgregarVueloScreen extends StatefulWidget {
  @override
  _AgregarVueloScreenState createState() => _AgregarVueloScreenState();
}

class _AgregarVueloScreenState extends State<AgregarVueloScreen> {
  TextEditingController avionController = TextEditingController();
  TextEditingController destinosController = TextEditingController();
  TextEditingController disponibilidadController = TextEditingController();
  TextEditingController tipoVueloController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference vuelosCollection =
      FirebaseFirestore.instance.collection('vuelos');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Vuelo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: avionController,
              decoration: InputDecoration(
                labelText: 'Avión',
              ),
            ),
            TextFormField(
              controller: destinosController,
              decoration: InputDecoration(
                labelText: 'Destinos',
              ),
            ),
            TextFormField(
              controller: disponibilidadController,
              decoration: InputDecoration(
                labelText: 'Disponibilidad',
              ),
            ),
            TextFormField(
              controller: tipoVueloController,
              decoration: InputDecoration(
                labelText: 'Tipo de Vuelo',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                agregarVuelo();
              },
              child: Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }

  void agregarVuelo() async {
    try {
      await vuelosCollection.add({
        'avion': avionController.text,
        'destinos': destinosController.text,
        'disponibilidad': disponibilidadController.text,
        'tipo_vuelo': tipoVueloController.text,
      });
      Navigator.pop(context);
      print('Vuelo agregado exitosamente');
    } catch (error) {
      print('Error al agregar el vuelo: $error');
    }
  }
}

class EditarVueloScreen extends StatefulWidget {
  final String vueloId;

  EditarVueloScreen({required this.vueloId});

  @override
  _EditarVueloScreenState createState() => _EditarVueloScreenState();
}

class _EditarVueloScreenState extends State<EditarVueloScreen> {
  TextEditingController avionController = TextEditingController();
  TextEditingController destinosController = TextEditingController();
  TextEditingController disponibilidadController = TextEditingController();
  TextEditingController tipoVueloController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference vuelosCollection =
      FirebaseFirestore.instance.collection('vuelos');

  @override
  void initState() {
    super.initState();
    obtenerVuelo();
  }

  void obtenerVuelo() async {
    try {
      DocumentSnapshot snapshot =
          await vuelosCollection.doc(widget.vueloId).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      avionController.text = data['avion'];
      destinosController.text = data['destinos'];
      disponibilidadController.text = data['disponibilidad'];
      tipoVueloController.text = data['tipo_vuelo'];
    } catch (error) {
      print('Error al obtener el vuelo: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Vuelo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: avionController,
              decoration: InputDecoration(
                labelText: 'Avión',
              ),
            ),
            TextFormField(
              controller: destinosController,
              decoration: InputDecoration(
                labelText: 'Destinos',
              ),
            ),
            TextFormField(
              controller: disponibilidadController,
              decoration: InputDecoration(
                labelText: 'Disponibilidad',
              ),
            ),
            TextFormField(
              controller: tipoVueloController,
              decoration: InputDecoration(
                labelText: 'Tipo de Vuelo',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                editarVuelo();
              },
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }

  void editarVuelo() async {
    try {
      await vuelosCollection.doc(widget.vueloId).update({
        'avion': avionController.text,
        'destinos': destinosController.text,
        'disponibilidad': disponibilidadController.text,
        'tipo_vuelo': tipoVueloController.text,
      });
      Navigator.pop(context);
      print('Vuelo actualizado exitosamente');
    } catch (error) {
      print('Error al editar el vuelo: $error');
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Vuelos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VuelosPage(),
    );
  }
}
