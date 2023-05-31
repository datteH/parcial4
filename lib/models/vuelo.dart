import 'package:cloud_firestore/cloud_firestore.dart';

class Vuelo {
  String avion;
  String destino;
  String disponibilidad;
  String tipo_vuelo;

  Vuelo(
      {required this.avion,
      required this.destino,
      required this.disponibilidad,
      required this.tipo_vuelo});
  factory Vuelo.fromSnapshot(DocumentSnapshot snapshot) {
    return Vuelo(
      avion: snapshot['avion'],
      destino: snapshot['destino'],
      disponibilidad: snapshot['disponibilidad'],
      tipo_vuelo: snapshot['tipo_vuelo'],
    );
  }
}
