import 'package:proyecto/screens/screens.dart';
import 'package:proyecto/screens/instagram/instagram_top.dart';
import 'package:proyecto/screens/instagram/instagram_middle.dart';
import 'package:proyecto/screens/instagram/instagram_bottom.dart';

class Instagram extends StatelessWidget {
  const Instagram({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    endDrawer: const NavegacionDrawer(),
    backgroundColor:
        Colors.white, // Para mantener el diseño de instagram original
    appBar: AppBar(
      backgroundColor:
          Colors.white, // Para mantener el diseño de instagram original
      iconTheme: IconThemeData(color: Colors.black),
      title: const Row(
        children: [
          Text('gatogatonson', style: TextStyle(color: Colors.black)),
          Icon(Icons.keyboard_arrow_down_rounded),
        ],
      ),
    ),
    body: const Column(
      children: [
        InstagramTop(), // Parte superior
        InstagramMiddle(), // Parte media
        InstagramBottom(), // Parte inferior
      ],
    ),
  );
}
