// Importa todas las pantallas necesarias desde el archivo centralizado de exports
import 'package:proyecto/screens/screens.dart';

class AppRoutes {
  // 🛣️ Definición de nombres constantes para las rutas
  // Estas constantes se usan para navegar entre pantallas de forma segura
  static const String home = '/'; // Ruta principal (pantalla de inicio)
  static const String fotosFila =
      '/fotos_fila'; // Pantalla que muestra fotos en una fila
  static const String fotosColumna =
      '/fotos_columna'; // Pantalla que muestra fotos en una columna
  static const String iconos = '/iconos'; // Pantalla con íconos personalizados
  static const String piramide =
      '/piramide'; // Pantalla con estructura tipo pirámide
  static const String textos = '/textos'; // Pantalla con estilos de texto
  static const String reto = '/reto'; // Pantalla de desafío o actividad
  static const String instagram = '/instagram'; // Pantalla estilo Instagram
  static const String contador =
      '/contador'; // Pantalla con contador interactivo
  static const String colores = '/colores_aleatorios';
  static const String juego =
      '/juego'; // Pantalla con juego de hacer clic en imagenes

  // 🗺️ Mapa de rutas que vincula cada nombre con su widget correspondiente
  // Este mapa se usa por Flutter para construir la pantalla cuando se navega a una ruta
  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
    fotosFila: (context) => const FotosEnFila(),
    fotosColumna: (context) => const FotosEnColumna(),
    iconos: (context) => const Iconos(),
    piramide: (context) => const Piramide(),
    textos: (context) => const Textos(),
    reto: (context) => const Reto(),
    instagram: (context) => const Instagram(),
    contador: (context) => const Contador(),
    colores: (context) => const RandomColors(),
    juego: (context) => const Juego(),
  };
}
