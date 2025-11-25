import 'package:proyecto/screens/screens.dart';
// Importa Google Fonts para aplicar tipografías personalizadas
import 'package:google_fonts/google_fonts.dart';

class ImagenRepresentativa extends StatelessWidget {
  const ImagenRepresentativa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavegacionDrawer(),
      appBar: AppBar(title: const Text('Imagen Representativa')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagen representativa
            const CircleAvatar(
              radius: 160,
              backgroundImage: AssetImage('assets/images/thisisfine.jpg'),
            ),
            const SizedBox(height: 40),
            Text(
              'Nicolás Agustín Massaccesi',
              style: GoogleFonts.cookie(fontSize: 48),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
