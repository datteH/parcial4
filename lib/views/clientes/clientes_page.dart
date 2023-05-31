import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parcial4_2565882012/models/cliente.dart';

class ClientesPage extends StatefulWidget {
  @override
  _ClientesScreenState createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference clientesCollection =
      FirebaseFirestore.instance.collection('clientes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Clientes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: clientesCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error al obtener los clientes');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          List<QueryDocumentSnapshot> clientes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: clientes.length,
            itemBuilder: (context, index) {
              final cliente = clientes[index];

              return ListTile(
                title: Text(cliente['nombre']),
                subtitle: Text(cliente['apellido']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        editarCliente(cliente.id);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        eliminarCliente(cliente.id);
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
            MaterialPageRoute(builder: (context) => AgregarClienteScreen()),
          );
        },
      ),
    );
  }

  void eliminarCliente(String clienteId) async {
    try {
      await clientesCollection.doc(clienteId).delete();
      print('Cliente eliminado exitosamente');
    } catch (error) {
      print('Error al eliminar el cliente: $error');
    }
  }

  void editarCliente(String clienteId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarClienteScreen(clienteId: clienteId),
      ),
    );
  }
}

class AgregarClienteScreen extends StatefulWidget {
  @override
  _AgregarClienteScreenState createState() => _AgregarClienteScreenState();
}

class _AgregarClienteScreenState extends State<AgregarClienteScreen> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController fechaNacimientoController = TextEditingController();
  TextEditingController sexoController = TextEditingController();
  TextEditingController tipoController = TextEditingController();
  TextEditingController usuarioController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference clientesCollection =
      FirebaseFirestore.instance.collection('clientes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Cliente'),
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
            TextFormField(
              controller: apellidoController,
              decoration: InputDecoration(
                labelText: 'Apellido',
              ),
            ),
            TextFormField(
              controller: fechaNacimientoController,
              decoration: InputDecoration(
                labelText: 'Fecha de Nacimiento',
              ),
            ),
            TextFormField(
              controller: sexoController,
              decoration: InputDecoration(
                labelText: 'Sexo',
              ),
            ),
            TextFormField(
              controller: tipoController,
              decoration: InputDecoration(
                labelText: 'Tipo',
              ),
            ),
            TextFormField(
              controller: usuarioController,
              decoration: InputDecoration(
                labelText: 'Usuario',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                agregarCliente();
              },
              child: Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }

  void agregarCliente() async {
    try {
      await clientesCollection.add({
        'nombre': nombreController.text,
        'apellido': apellidoController.text,
        'fecha_nacimiento': fechaNacimientoController.text,
        'sexo': sexoController.text,
        'tipo': tipoController.text,
        'usuario': usuarioController.text,
      });
      Navigator.pop(context);
      print('Cliente agregado exitosamente');
    } catch (error) {
      print('Error al agregar el cliente: $error');
    }
  }
}

class EditarClienteScreen extends StatefulWidget {
  final String clienteId;

  EditarClienteScreen({required this.clienteId});

  @override
  _EditarClienteScreenState createState() => _EditarClienteScreenState();
}

class _EditarClienteScreenState extends State<EditarClienteScreen> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController fechaNacimientoController = TextEditingController();
  TextEditingController sexoController = TextEditingController();
  TextEditingController tipoController = TextEditingController();
  TextEditingController usuarioController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference clientesCollection =
      FirebaseFirestore.instance.collection('clientes');

  @override
  void initState() {
    super.initState();
    obtenerCliente();
  }

  void obtenerCliente() async {
    try {
      DocumentSnapshot snapshot =
          await clientesCollection.doc(widget.clienteId).get();
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

      nombreController.text = data['nombre'];
      apellidoController.text = data['apellido'];
      fechaNacimientoController.text = data['fecha_nacimiento'];
      sexoController.text = data['sexo'];
      tipoController.text = data['tipo'];
      usuarioController.text = data['usuario'];
    } catch (error) {
      print('Error al obtener el cliente: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Cliente'),
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
            TextFormField(
              controller: apellidoController,
              decoration: InputDecoration(
                labelText: 'Apellido',
              ),
            ),
            TextFormField(
              controller: fechaNacimientoController,
              decoration: InputDecoration(
                labelText: 'Fecha de Nacimiento',
              ),
            ),
            TextFormField(
              controller: sexoController,
              decoration: InputDecoration(
                labelText: 'Sexo',
              ),
            ),
            TextFormField(
              controller: tipoController,
              decoration: InputDecoration(
                labelText: 'Tipo',
              ),
            ),
            TextFormField(
              controller: usuarioController,
              decoration: InputDecoration(
                labelText: 'Usuario',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                editarCliente();
              },
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }

  void editarCliente() async {
    try {
      await clientesCollection.doc(widget.clienteId).update({
        'nombre': nombreController.text,
        'apellido': apellidoController.text,
        'fecha_nacimiento': fechaNacimientoController.text,
        'sexo': sexoController.text,
        'tipo': tipoController.text,
        'usuario': usuarioController.text,
      });
      Navigator.pop(context);
      print('Cliente actualizado exitosamente');
    } catch (error) {
      print('Error al editar el cliente: $error');
    }
  }
}
