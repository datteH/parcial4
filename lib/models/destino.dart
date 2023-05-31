import 'package:cloud_firestore/cloud_firestore.dart';

class Destino {
  String nombre;

  Destino({required this.nombre});
  factory Destino.fromSnapshot(DocumentSnapshot snapshot) {
    return Destino(
      nombre: snapshot['nombre'],
    );
  }
}
