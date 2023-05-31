import 'package:cloud_firestore/cloud_firestore.dart';

class Avion {
  String estado;
  String marca;

  Avion({required this.estado, required this.marca});
  factory Avion.fromSnapshot(DocumentSnapshot snapshot) {
    return Avion(
      estado: snapshot['estado'],
      marca: snapshot['marca'],
    );
  }
}
