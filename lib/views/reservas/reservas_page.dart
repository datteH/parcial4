import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parcial4_2565882012/models/reserva.dart';

class ReservasPage extends StatefulWidget {
  @override
  _ReservasScreenState createState() => _ReservasScreenState();
}

class _ReservasScreenState extends State<ReservasPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference reservasCollection =
      FirebaseFirestore.instance.collection('reservas');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Reservas'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: reservasCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error al obtener las reservas');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          List<QueryDocumentSnapshot> reservas = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reservas.length,
            itemBuilder: (context, index) {
              final reserva = reservas[index];

              return ListTile(
                title: Text(reserva['cliente']),
                subtitle: Text(reserva['estado']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        editarReserva(reserva.id);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        eliminarReserva(reserva.id);
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
            MaterialPageRoute(builder: (context) => AgregarReservaScreen()),
          );
        },
      ),
    );
  }

  void eliminarReserva(String reservaId) async {
    try {
      await reservasCollection.doc(reservaId).delete();
      print('Reserva eliminada exitosamente');
    } catch (error) {
      print('Error al eliminar la reserva: $error');
    }
  }

  void editarReserva(String reservaId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarReservaScreen(reservaId: reservaId),
      ),
    );
  }
}

class AgregarReservaScreen extends StatefulWidget {
  @override
  _AgregarReservaScreenState createState() => _AgregarReservaScreenState();
}

class _AgregarReservaScreenState extends State<AgregarReservaScreen> {
  TextEditingController clienteController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  TextEditingController vueloController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference reservasCollection =
      FirebaseFirestore.instance.collection('reservas');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Reserva'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: clienteController,
              decoration: InputDecoration(
                labelText: 'Cliente',
              ),
            ),
            TextFormField(
              controller: estadoController,
              decoration: InputDecoration(
                labelText: 'Estado',
              ),
            ),
            TextFormField(
              controller: vueloController,
              decoration: InputDecoration(
                labelText: 'Vuelo',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                agregarReserva();
              },
              child: Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }

  void agregarReserva() async {
    try {
      await reservasCollection.add({
        'cliente': clienteController.text,
        'estado': estadoController.text,
        'vuelo': vueloController.text,
      });
      Navigator.pop(context);
      print('Reserva agregada exitosamente');
    } catch (error) {
      print('Error al agregar la reserva: $error');
    }
  }
}

class EditarReservaScreen extends StatefulWidget {
  final String reservaId;

  EditarReservaScreen({required this.reservaId});

  @override
  _EditarReservaScreenState createState() => _EditarReservaScreenState();
}

class _EditarReservaScreenState extends State<EditarReservaScreen> {
  TextEditingController clienteController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  TextEditingController vueloController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference reservasCollection =
      FirebaseFirestore.instance.collection('reservas');

  @override
  void initState() {
    super.initState();
    obtenerReserva();
  }

  void obtenerReserva() async {
    try {
      DocumentSnapshot snapshot =
          await reservasCollection.doc(widget.reservaId).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      clienteController.text = data['cliente'];
      estadoController.text = data['estado'];
      vueloController.text = data['vuelo'];
    } catch (error) {
      print('Error al obtener la reserva: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Reserva'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: clienteController,
              decoration: InputDecoration(
                labelText: 'Cliente',
              ),
            ),
            TextFormField(
              controller: estadoController,
              decoration: InputDecoration(
                labelText: 'Estado',
              ),
            ),
            TextFormField(
              controller: vueloController,
              decoration: InputDecoration(
                labelText: 'Vuelo',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                editarReserva();
              },
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }

  void editarReserva() async {
    try {
      await reservasCollection.doc(widget.reservaId).update({
        'cliente': clienteController.text,
        'estado': estadoController.text,
        'vuelo': vueloController.text,
      });
      Navigator.pop(context);
      print('Reserva actualizada exitosamente');
    } catch (error) {
      print('Error al editar la reserva: $error');
    }
  }
}
