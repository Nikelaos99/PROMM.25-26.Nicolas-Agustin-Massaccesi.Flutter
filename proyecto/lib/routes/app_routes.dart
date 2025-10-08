import 'package:proyecto/screens/screens.dart';

class AppRoutes {
  // Definir nombres para las rutas
  static const String home = '/';
  static const String fotosFila = '/fotos_fila';
  static const String fotosColumna = '/fotos_columna';
  static const String iconos = '/iconos';
  static const String piramide = '/piramide';
  static const String textos = '/textos';

  // Mapa de rutas
  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
    fotosFila: (context) => const FotosEnFila(),
    fotosColumna: (context) => const FotosEnColumna(),
    iconos: (context) => const Iconos(),
    piramide: (context) => const Piramide(),
    textos: (context) => const Textos(),
  };
}
