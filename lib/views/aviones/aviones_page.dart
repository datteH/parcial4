import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parcial4_2565882012/models/avion.dart';

class AvionesPage extends StatelessWidget {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference avionesCollection =
      FirebaseFirestore.instance.collection('aviones');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aviones'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: avionesCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error al obtener los aviones');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Text('No hay aviones');
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['marca']),
                subtitle: Text(data['estado']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditarAvionScreen(
                              avionId: document.id,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        eliminarAvion(document.id);
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AgregarAvionScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void eliminarAvion(String avionId) async {
    try {
      await avionesCollection.doc(avionId).delete();
      print('Avión eliminado exitosamente');
    } catch (error) {
      print('Error al eliminar el avión: $error');
    }
  }
}

class AgregarAvionScreen extends StatefulWidget {
  @override
  _AgregarAvionScreenState createState() => _AgregarAvionScreenState();
}

class _AgregarAvionScreenState extends State<AgregarAvionScreen> {
  TextEditingController estadoController = TextEditingController();
  TextEditingController marcaController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference avionesCollection =
      FirebaseFirestore.instance.collection('aviones');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Avión'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: estadoController,
              decoration: InputDecoration(
                labelText: 'Estado',
              ),
            ),
            TextFormField(
              controller: marcaController,
              decoration: InputDecoration(
                labelText: 'Marca',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                agregarAvion();
              },
              child: Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }

  void agregarAvion() async {
    try {
      String estado = estadoController.text;
      String marca = marcaController.text;
      if (estado.isEmpty || marca.isEmpty) {
        print('Por favor, complete todos los campos');
        return;
      }
      DocumentReference documentReference = await avionesCollection.add({
        'estado': estado,
        'marca': marca,
      });

      print('Avión agregado exitosamente con el ID: ${documentReference.id}');
      estadoController.clear();
      marcaController.clear();
    } catch (error) {
      print('Error al agregar el avión: $error');
    }
  }
}

class EditarAvionScreen extends StatefulWidget {
  final String avionId;

  EditarAvionScreen({required this.avionId});

  @override
  _EditarAvionScreenState createState() => _EditarAvionScreenState();
}

class _EditarAvionScreenState extends State<EditarAvionScreen> {
  TextEditingController estadoController = TextEditingController();
  TextEditingController marcaController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference avionesCollection =
      FirebaseFirestore.instance.collection('aviones');

  @override
  void initState() {
    super.initState();
    obtenerDatosAvion();
  }

  void obtenerDatosAvion() async {
    try {
      DocumentSnapshot documentSnapshot =
          await avionesCollection.doc(widget.avionId).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        estadoController.text = data['estado'];
        marcaController.text = data['marca'];
      } else {
        print('No se encontró el avión');
      }
    } catch (error) {
      print('Error al obtener los datos del avión: $error');
    }
  }

  void actualizarAvion() async {
    try {
      String estado = estadoController.text;
      String marca = marcaController.text;
      if (estado.isEmpty || marca.isEmpty) {
        print('Por favor, complete todos los campos');
        return;
      }
      await avionesCollection.doc(widget.avionId).update({
        'estado': estado,
        'marca': marca,
      });

      print('Avión actualizado exitosamente');
      Navigator.pop(context);
    } catch (error) {
      print('Error al actualizar el avión: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Avión'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: estadoController,
              decoration: InputDecoration(
                labelText: 'Estado',
              ),
            ),
            TextFormField(
              controller: marcaController,
              decoration: InputDecoration(
                labelText: 'Marca',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                actualizarAvion();
              },
              child: Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
