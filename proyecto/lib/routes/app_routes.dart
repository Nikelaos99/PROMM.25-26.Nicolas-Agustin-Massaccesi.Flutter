import 'package:proyecto/screens/screens.dart';

class AppRoutes {
  // Definir nombres para las rutas
  static const String home = '/';
  static const String fotosFila = '/fotos_fila';
  static const String fotosColumna = '/fotos_columna';
  static const String iconos = '/iconos';

  // Mapa de rutas
  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
    fotosFila: (context) => const FotosEnFila(),
    fotosColumna: (context) => const FotosEnColumna(),
    iconos: (context) => const Iconos(),
  };
}
