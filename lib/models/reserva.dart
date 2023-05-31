import 'package:cloud_firestore/cloud_firestore.dart';

class Reserva {
  String cliente;
  String estado;
  String vuelo;

  Reserva({required this.cliente, required this.estado, required this.vuelo});

  factory Reserva.fromSnapshot(DocumentSnapshot snapshot) {
    return Reserva(
      cliente: snapshot['cliente'],
      estado: snapshot['estado'],
      vuelo: snapshot['vuelo'],
    );
  }
}
