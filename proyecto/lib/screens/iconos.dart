import 'package:proyecto/screens/screens.dart';

class Iconos extends StatelessWidget {
  const Iconos({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    drawer: const NavegacionDrawer(),
    appBar: AppBar(title: const Text('Iconos'), backgroundColor: Colors.blue),
    body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.alarm, size: 40, color: Colors.red),
          SizedBox(width: 20), // Space between icons
          Icon(Icons.star, size: 40, color: Colors.yellow),
          SizedBox(width: 20), // Space between icons
          Icon(Icons.person, size: 40, color: Colors.green),
          SizedBox(width: 20), // Space between icons
          Icon(Icons.settings, size: 40, color: Colors.blue),
          SizedBox(width: 20), // Space between icons
          Icon(Icons.pets, size: 40, color: Colors.purple),
        ],
      ),
    ),
  );
}
