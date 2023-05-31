import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parcial4_2565882012/utils/app_routes.dart';
import 'package:parcial4_2565882012/views/clientes/clientes_page.dart';
import 'package:parcial4_2565882012/views/reservas/reservas_page.dart';
import 'package:parcial4_2565882012/views/vuelos/vuelos_page.dart';
import 'package:parcial4_2565882012/views/aviones/aviones_page.dart';
import 'package:parcial4_2565882012/views/destinos/destinos_page.dart';
import 'package:parcial4_2565882012/views/horarios/horarios_page.dart';
import 'package:parcial4_2565882012/views/accion/reservar_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parcial 4 2565882012',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => HomeScreen(),
        AppRoutes.clientes: (context) => ClientesPage(),
        AppRoutes.reservas: (context) => ReservasPage(),
        AppRoutes.vuelos: (context) => VuelosPage(),
        AppRoutes.aviones: (context) => AvionesPage(),
        AppRoutes.destinos: (context) => DestinosPage(),
        AppRoutes.horarios: (context) => HorariosPage(),
        AppRoutes.reservar: (context) => reservar(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parcial 4 - 2565882012'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          children: [
            Column(
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.clientes);
                  },
                  icon: Icon(Icons.person),
                  label: Text('Clientes'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    primary: Colors.white,
                    padding: EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                SizedBox(height: 10.0), // Espacio vertical
              ],
            ),
            Column(
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.reservas);
                  },
                  icon: Icon(Icons.event_available),
                  label: Text('Reservas'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    primary: Colors.white,
                    padding: EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                SizedBox(height: 10.0), // Espacio vertical
              ],
            ),
            Column(
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.vuelos);
                  },
                  icon: Icon(Icons.flight),
                  label: Text('Vuelos'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    primary: Colors.white,
                    padding: EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                SizedBox(height: 10.0), // Espacio vertical
              ],
            ),
            Column(
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.aviones);
                  },
                  icon: Icon(Icons.airplanemode_active),
                  label: Text('Aviones'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    primary: Colors.white,
                    padding: EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                SizedBox(height: 10.0), // Espacio vertical
              ],
            ),
            Column(
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.destinos);
                  },
                  icon: Icon(Icons.location_on),
                  label: Text('Destinos'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    primary: Colors.white,
                    padding: EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                SizedBox(height: 10.0), // Espacio vertical
              ],
            ),
            Column(
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.horarios);
                  },
                  icon: Icon(Icons.access_time),
                  label: Text('Horarios'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    primary: Colors.white,
                    padding: EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                SizedBox(height: 10.0), // Espacio vertical
              ],
            ),
            /*Column(
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.reservar);
                  },
                  icon: Icon(Icons.access_time),
                  label: Text('Reservar'),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 243, 33, 33),
                    primary: Colors.white,
                    padding: EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                SizedBox(height: 10.0), // Espacio vertical
              ],
            ),*/
            // Agrega aquí los botones para las vistas adicionales
          ],
        ),
      ),
    );
  }
}
