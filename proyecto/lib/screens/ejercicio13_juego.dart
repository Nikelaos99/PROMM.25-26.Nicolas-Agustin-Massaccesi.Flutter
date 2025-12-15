import 'dart:async';
import 'dart:math';
import 'package:proyecto/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Juego extends StatelessWidget {
  const Juego({super.key});

  @override
  Widget build(BuildContext context) {
    return const JuegoAux();
  }
}

class JuegoAux extends StatefulWidget {
  const JuegoAux({super.key});

  @override
  _JuegoState createState() => _JuegoState();
}

class _JuegoState extends State<JuegoAux> {
  int _puntos = 0;
  Random _random = Random();
  Offset _posicionImagen = Offset.zero;
  Timer? _timer;
  int _tiempoRestante = 3;
  late String _imagenUrl;
  List<String> _mensajesPuntosPerdidos = [
    'Oh no!',
    'Ánimo!',
    'Ups!',
    'Vaya!',
    'Lo siento!',
  ];

  @override
  void initState() {
    super.initState();
    _imagenUrl = _generarUrlImagen();
    _cargarPuntos(); // Cargar puntuación guardada
    _iniciarJuego();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _moverImagen();
  }

  // Guardar puntuación en SharedPreferences
  Future<void> _guardarPuntos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('puntos', _puntos);
  }

  // Cargar puntuación desde SharedPreferences
  Future<void> _cargarPuntos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _puntos = prefs.getInt('puntos') ?? 0; // Si no existe, arranca en 0
    });
  }

  void _iniciarJuego() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _tiempoRestante -= 1;
        if (_tiempoRestante <= 0) {
          _puntos -= 2;
          _guardarPuntos(); // Guardar cada vez que cambie

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: Text(
                  _mensajesPuntosPerdidos[_random.nextInt(
                    _mensajesPuntosPerdidos.length,
                  )],
                ),
              ),
            ),
          );

          _moverImagen();
          _tiempoRestante = 3;
        }
      });
    });
  }

  void _moverImagen() {
    setState(() {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      double offsetX, offsetY;

      do {
        offsetX = _random.nextDouble() * (screenWidth - 100);
        offsetY = _random.nextDouble() * (screenHeight - 150);
      } while ((offsetX < 150 && offsetY < 150) ||
          (offsetX > screenWidth - 150 && offsetY < 150) ||
          (offsetX > screenWidth - 100) ||
          (offsetY > screenHeight - 100));

      _posicionImagen = Offset(offsetX, offsetY);
      _imagenUrl = _generarUrlImagen();
    });
  }

  String _generarUrlImagen() {
    return 'https://picsum.photos/seed/${_random.nextInt(1000)}/100';
  }

  void _imagenPulsada() {
    setState(() {
      _puntos += 1;
      _guardarPuntos(); // Guardar cada vez que sume puntos
      _moverImagen();
      _tiempoRestante = 3;

      switch (_puntos) {
        case 5:
          _mostrarMensaje('¡Bravo! Has alcanzado 5 puntos 🌟');
          break;
        case 20:
          _mostrarMensaje('¡Impresionante! 20 puntos 🚀');
          break;
        case 50:
          _mostrarMensaje('¡Increíble! 50 puntos 🏅');
          break;
        case 100:
          _mostrarMensaje('¡Felicidades! 100 puntos 💯');
          break;
        case 500:
          _mostrarMensaje('¡Impresionante! 500 puntos 🏆🌟');
          break;
        case 1000:
          _mostrarMensaje('¡Asombroso! 1000 puntos 🌟🏆');
          break;
      }
    });
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Center(child: Text(mensaje))));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavegacionDrawer(),
      appBar: AppBar(
        title: const Text('Juego de Imágenes'),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.redAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            left: _posicionImagen.dx,
            top: _posicionImagen.dy,
            child: GestureDetector(
              onTap: _imagenPulsada,
              child: Image.network(_imagenUrl, width: 100, height: 100),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Puntos: $_puntos',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Tiempo: $_tiempoRestante',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
