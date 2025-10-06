import 'package:proyecto/screens/screens.dart';

import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Home')),
    drawer: const NavegacionDrawer(),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Nicolás Massaccesi',
            style: GoogleFonts.lobster(fontSize: 32, color: Colors.black),
          ),
          Text(
            'https://github.com/Nikelaos99/PROMM.25-26.Nicolas-Agustin-Massaccesi.Flutter',
            style: GoogleFonts.roboto(fontSize: 24, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
