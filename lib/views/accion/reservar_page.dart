import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parcial4_2565882012/models/destino.dart';

class reservar extends StatefulWidget {
  @override
  _ReservaFormPageState createState() => _ReservaFormPageState();
}

class _ReservaFormPageState extends State<reservar> {
  String selectedClientId = '';
  List<Map<String, dynamic>> clients = []; // Lista de clientes

  @override
  void initState() {
    super.initState();
    // Obtener la lista de clientes desde Firestore
    fetchClients();
  }

  Future<void> fetchClients() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('clientes').get();

    setState(() {
      // Convertir los documentos de clientes en una lista de mapas
      clients = snapshot.docs.map((DocumentSnapshot document) {
        return {
          'id': document.id,
          'nombre': document['nombre'],
          'apellido': document['apellido'],
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Reserva'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seleccione un cliente:',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 10.0),
            DropdownButtonFormField<String>(
              value: selectedClientId,
              onChanged: (String? newValue) {
                setState(() {
                  selectedClientId = newValue!;
                });
              },
              items: clients.map((client) {
                return DropdownMenuItem<String>(
                  value: client['id'],
                  child: Text('${client['nombre']} ${client['apellido']}'),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Realizar el guardado en la colección de reservas
                saveReserva();
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveReserva() async {
    // Validar que se haya seleccionado un cliente
    if (selectedClientId.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Seleccione un cliente'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      // Guardar la reserva en la colección de reservas
      await FirebaseFirestore.instance.collection('reservas').add({
        'idCliente': selectedClientId,
        // Agrega aquí los demás campos de la reserva
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Reserva guardada'),
            content: Text('La reserva se ha guardado exitosamente'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error al guardar la reserva'),
            content: Text(
                'Ocurrió un error al guardar la reserva. Por favor, inténtelo nuevamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
