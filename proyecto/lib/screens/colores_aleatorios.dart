// Importa los recursos compartidos del proyecto (widgets, drawer, rutas, etc.)

import 'package:proyecto/screens/screens.dart';
import 'dart:math';
import 'dart:async';

/// Pantalla RandomColors adaptada al proyecto (usa Scaffold y NavegacionDrawer)
class RandomColors extends StatefulWidget {
  const RandomColors({super.key});

  @override
  State<RandomColors> createState() => _RandomColorsState();

  // Código original con nombre de State distinto (defectuoso):
  // @override
  // State<RandomColors> createState() => _RandomColors();
}

class _RandomColorsState extends State<RandomColors> {
  int points = 0;

  // Inicializaciones seguras para evitar errores de 'late' antes de asignar
  String randomName = 'azul';
  Color randomColor = const Color(0xFF0000FF);

  // Listas inmutables y tipadas
  final List<String> colorNames = const ['azul', 'verde', 'naranja'];
  final List<Color> colorHex = const [
    Color(0xFF0000FF),
    Color(0xFF00FF00),
    Color(0xFFFF914D),
  ];

  // Reutilizamos un Random
  final Random _rng = Random();

  // Guardamos el Timer para cancelarlo en dispose
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    getRandomColor();
    getRandomName();
    _startTimer();
  }

  // Código original que no guardaba el Timer (dejado comentado):
  // void timer() {
  //   Timer.periodic(const Duration(milliseconds: 1000), (timer) {
  //     getRandomColor();
  //     getRandomName();
  //     setState(() {});
  //   });
  // }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      getRandomColor();
      getRandomName();
      // Actualizamos estado una sola vez cuando cambian ambos valores
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Cancelamos el timer para evitar fugas de memoria
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavegacionDrawer(),
      appBar: AppBar(title: const Text('Random Colors')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Puntos: $points',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                onGiftTap(randomName, randomColor);
              },
              child: Column(
                children: [
                  Container(width: 120, color: randomColor, height: 120),
                  Text(
                    randomName,
                    style: TextStyle(
                      color: _preferContrastingTextColor(randomColor),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getRandomColor() {
    // Usamos el tamaño real de la lista para evitar errores si cambia la longitud
    final int randomNumber = _rng.nextInt(colorHex.length);
    randomColor = colorHex[randomNumber];

    // Código original (menos robusto, con valor fijo 3):
    // Random random = Random();
    // int randomNumber = random.nextInt(3);
    // randomColor = colorHex[randomNumber];
  }

  void getRandomName() {
    final int randomNumber = _rng.nextInt(colorNames.length);
    randomName = colorNames[randomNumber];

    // Código original (menos robusto, con valor fijo 3):
    // Random random = Random();
    // int randomNumber = random.nextInt(3);
    // randomName = colorNames[randomNumber];
  }

  String hexToStringConverter(Color hexColor) {
    // Convertimos color a string comparando con los valores conocidos
    if (hexColor == const Color(0xFF0000FF)) {
      return 'azul';
    } else if (hexColor == const Color(0xFF00FF00)) {
      return 'verde';
    } else {
      return 'naranja';
    }
  }

  void onGiftTap(String name, Color color) {
    final String colorToString = hexToStringConverter(color);
    if (name == colorToString) {
      points++;
    } else {
      points--;
    }
    setState(() {});
  }

  // Utilidad para escoger un color de texto con suficiente contraste
  Color _preferContrastingTextColor(Color background) {
    final double r = background.red / 255.0;
    final double g = background.green / 255.0;
    final double b = background.blue / 255.0;
    final double luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b;
    // Umbral ajustable (0..1). Si la luminancia es alta, texto negro; si baja, texto blanco.
    return luminance > 0.6 ? Colors.black : Colors.white;
  }
}
