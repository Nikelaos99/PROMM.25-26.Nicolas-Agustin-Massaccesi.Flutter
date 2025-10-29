// Importa todas las pantallas definidas en el archivo screens.dart
import 'package:proyecto/screens/screens.dart';

// Función principal que inicia la aplicación Flutter
void main() {
  runApp(
    MaterialApp(
      // Oculta el banner de "debug" en la esquina superior derecha
      debugShowCheckedModeBanner: false,

      // Título de la aplicación (usado internamente por Android/iOS)
      title: "Mi aplicacion",

      // Ruta inicial al lanzar la app
      initialRoute: "/",

      // Mapa de rutas definidas en AppRoutes (debe estar en screens.dart)
      routes: AppRoutes.routes,

      // Callback para generar rutas dinámicas si no están en el mapa de rutas
      onGenerateRoute: (RouteSettings settings) {
        // Si la ruta no está definida, redirige a HomePage por defecto
        return MaterialPageRoute(builder: (BuildContext builder) => HomePage());
      },

      // Tema general de la aplicación
      theme: ThemeData(
        // Color de fondo por defecto para todos los Scaffold
        scaffoldBackgroundColor: Colors.grey.shade400,

        // Estilo para las AppBar (barra superior)
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade700, // Fondo azul oscuro
          foregroundColor: Colors.white, // Texto e íconos en blanco
        ),

        // Estilo de texto para títulos grandes
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
