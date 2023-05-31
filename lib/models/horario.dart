import 'package:cloud_firestore/cloud_firestore.dart';

class Horario {
  String hora_vuelo;

  Horario({required this.hora_vuelo});
  factory Horario.fromSnapshot(DocumentSnapshot snapshot) {
    return Horario(
      hora_vuelo: snapshot['hora_vuelo'],
    );
  }
}
