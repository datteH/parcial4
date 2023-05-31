import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parcial4_2565882012/models/horario.dart';

class HorariosPage extends StatelessWidget {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference horariosCollection =
      FirebaseFirestore.instance.collection('horarios');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horarios'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: horariosCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error al obtener los horarios');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Text('No hay horarios');
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['hora_vuelo']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditarHorarioScreen(
                              horarioId: document.id,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        eliminarHorario(document.id);
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
            MaterialPageRoute(builder: (context) => AgregarHorarioScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void eliminarHorario(String horarioId) async {
    try {
      await horariosCollection.doc(horarioId).delete();
      print('Horario eliminado exitosamente');
    } catch (error) {
      print('Error al eliminar el horario: $error');
    }
  }
}

class AgregarHorarioScreen extends StatefulWidget {
  @override
  _AgregarHorarioScreenState createState() => _AgregarHorarioScreenState();
}

class _AgregarHorarioScreenState extends State<AgregarHorarioScreen> {
  TextEditingController horaVueloController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference horariosCollection =
      FirebaseFirestore.instance.collection('horarios');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Horario'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: horaVueloController,
              decoration: InputDecoration(
                labelText: 'Hora de Vuelo',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                agregarHorario();
              },
              child: Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }

  void agregarHorario() async {
    try {
      String horaVuelo = horaVueloController.text;
      if (horaVuelo.isEmpty) {
        print('Por favor, ingrese la hora de vuelo');
        return;
      }
      await horariosCollection.add({
        'hora_vuelo': horaVuelo,
      });

      print('Horario agregado exitosamente');
      Navigator.pop(context);
    } catch (error) {
      print('Error al agregar el horario: $error');
    }
  }
}

class EditarHorarioScreen extends StatefulWidget {
  final String horarioId;

  EditarHorarioScreen({required this.horarioId});

  @override
  _EditarHorarioScreenState createState() => _EditarHorarioScreenState();
}

class _EditarHorarioScreenState extends State<EditarHorarioScreen> {
  TextEditingController horaVueloController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference horariosCollection =
      FirebaseFirestore.instance.collection('horarios');

  @override
  void initState() {
    super.initState();
    cargarDatosHorario();
  }

  void cargarDatosHorario() async {
    try {
      DocumentSnapshot documentSnapshot =
          await horariosCollection.doc(widget.horarioId).get();

      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      String horaVuelo = data['hora_vuelo'];

      horaVueloController.text = horaVuelo;
    } catch (error) {
      print('Error al cargar los datos del horario: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Horario'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: horaVueloController,
              decoration: InputDecoration(
                labelText: 'Hora de Vuelo',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                editarHorario();
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  void editarHorario() async {
    try {
      String horaVuelo = horaVueloController.text;
      if (horaVuelo.isEmpty) {
        print('Por favor, ingrese la hora de vuelo');
        return;
      }
      await horariosCollection.doc(widget.horarioId).update({
        'hora_vuelo': horaVuelo,
      });

      print('Horario actualizado exitosamente');
      Navigator.pop(context);
    } catch (error) {
      print('Error al editar el horario: $error');
    }
  }
}
