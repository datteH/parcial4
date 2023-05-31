import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parcial4_2565882012/models/destino.dart';

class DestinosPage extends StatelessWidget {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference destinosCollection =
      FirebaseFirestore.instance.collection('destinos');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Destinos'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: destinosCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error al obtener los destinos');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Text('No hay destinos');
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['nombre']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditarDestinoScreen(
                              destinoId: document.id,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        eliminarDestino(document.id);
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
            MaterialPageRoute(builder: (context) => AgregarDestinoScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void eliminarDestino(String destinoId) async {
    try {
      await destinosCollection.doc(destinoId).delete();
      print('Destino eliminado exitosamente');
    } catch (error) {
      print('Error al eliminar el destino: $error');
    }
  }
}

class AgregarDestinoScreen extends StatefulWidget {
  @override
  _AgregarDestinoScreenState createState() => _AgregarDestinoScreenState();
}

class _AgregarDestinoScreenState extends State<AgregarDestinoScreen> {
  TextEditingController nombreController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference destinosCollection =
      FirebaseFirestore.instance.collection('destinos');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Destino'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                agregarDestino();
              },
              child: Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }

  void agregarDestino() async {
    try {
      String nombre = nombreController.text;
      if (nombre.isEmpty) {
        print('Por favor, ingrese el nombre del destino');
        return;
      }
      DocumentReference documentReference = await destinosCollection.add({
        'nombre': nombre,
      });
      print('Destino agregado exitosamente. ID: ${documentReference.id}');
    } catch (error) {
      print('Error al agregar el destino: $error');
    }
  }
}

class EditarDestinoScreen extends StatefulWidget {
  final String destinoId;

  EditarDestinoScreen({required this.destinoId});

  @override
  _EditarDestinoScreenState createState() => _EditarDestinoScreenState();
}

class _EditarDestinoScreenState extends State<EditarDestinoScreen> {
  TextEditingController nombreController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference destinosCollection =
      FirebaseFirestore.instance.collection('destinos');

  @override
  void initState() {
    super.initState();
    obtenerDestino();
  }

  void obtenerDestino() async {
    try {
      DocumentSnapshot documentSnapshot =
          await destinosCollection.doc(widget.destinoId).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        String nombre = data['nombre'];
        nombreController.text = nombre;
      }
    } catch (error) {
      print('Error al obtener el destino: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Destino'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                editarDestino();
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  void editarDestino() async {
    try {
      String nombre = nombreController.text;
      if (nombre.isEmpty) {
        print('Por favor, ingrese el nombre del destino');
        return;
      }
      await destinosCollection.doc(widget.destinoId).update({
        'nombre': nombre,
      });

      print('Destino actualizado exitosamente');
    } catch (error) {
      print('Error al editar el destino: $error');
    }
  }
}
