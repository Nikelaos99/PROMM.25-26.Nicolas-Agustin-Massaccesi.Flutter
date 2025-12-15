import 'package:flutter/material.dart';

// Widget con estado que representa la parte inferior del perfil estilo Instagram
class InstagramBottom extends StatefulWidget {
  const InstagramBottom({super.key});

  @override
  State<InstagramBottom> createState() => InstagramBottomState();
}

class InstagramBottomState extends State<InstagramBottom> {
  bool muestraGrid =
      true; // Controla qué pestaña está activa (grid o perfil etiquetado)

  @override
  Widget build(BuildContext context) {
    // Colores dinámicos según el tema actual
    final Color textoColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    final Color iconoColor = Theme.of(context).iconTheme.color ?? Colors.black;
    final Color bordeColor = Theme.of(
      context,
    ).dividerColor; // color adaptado para bordes

    return SingleChildScrollView(
      child: Column(
        children: [
          // Historias destacadas (scroll horizontal)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SizedBox(
              height: 85,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  construirElementoHistoria(
                    'assets/images/instagram/nuevo.jpg',
                    'Nuevo',
                    textoColor,
                    bordeColor,
                  ),
                  construirElementoHistoria(
                    'assets/images/instagram/pilotando.jpg',
                    'Pilotando',
                    textoColor,
                    bordeColor,
                  ),
                  construirElementoHistoria(
                    'assets/images/instagram/francia.jpg',
                    'Francia',
                    textoColor,
                    bordeColor,
                  ),
                  construirElementoHistoria(
                    'assets/images/instagram/arquitectura.jpg',
                    'Arquitectura',
                    textoColor,
                    bordeColor,
                  ),
                  construirElementoHistoria(
                    'assets/images/instagram/retrato.jpg',
                    'Retratos',
                    textoColor,
                    bordeColor,
                  ),
                  construirElementoHistoria(
                    'assets/images/instagram/comida.jpg',
                    'Comida',
                    textoColor,
                    bordeColor,
                  ),
                  construirElementoHistoria(
                    'assets/images/instagram/coche.jpg',
                    'Coches',
                    textoColor,
                    bordeColor,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Sección de pestañas (grid y perfil etiquetado)
          DefaultTabController(
            length: 4,
            child: Column(
              children: [
                // Selector de pestañas
                TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.grid_on_rounded,
                        size: 30,
                        color: iconoColor,
                      ),
                    ), // Vista de cuadrícula
                    Tab(
                      icon: Icon(
                        Icons.person_pin_sharp,
                        size: 30,
                        color: iconoColor,
                      ),
                    ), // Vista de perfil etiquetado
                    Tab(
                      icon: Icon(
                        Icons.live_tv_rounded,
                        size: 30,
                        color: iconoColor,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.shopping_bag_outlined,
                        size: 30,
                        color: iconoColor,
                      ),
                    ),
                  ],
                  onTap: (index) {
                    setState(() {
                      muestraGrid = index == 0;
                    });
                  },
                ),
                const SizedBox(height: 8),

                // Contenido de cada pestaña
                SizedBox(
                  height: 220,
                  child: TabBarView(
                    children: [
                      // Vista en cuadrícula con 9 imágenes
                      GridView.count(
                        mainAxisSpacing: 2,
                        crossAxisSpacing: 2,
                        crossAxisCount: 3,
                        children: List.generate(9, (index) {
                          return Image.asset(
                            'assets/images/instagram/grid${index + 1}.jpg',
                            fit: BoxFit.cover,
                          );
                        }),
                      ),

                      // Vista alternativa con una imagen destacada
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/images/instagram/relax.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // Vista alternativa con una imagen destacada
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/images/instagram/relax.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // Vista alternativa con una imagen destacada
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/images/instagram/relax.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Barra de navegación inferior estilo Instagram
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.home_rounded, size: 40, color: iconoColor),
              Icon(Icons.search_rounded, size: 40, color: iconoColor),
              Icon(Icons.add_circle, size: 40, color: iconoColor),
              Icon(Icons.favorite_rounded, size: 40, color: iconoColor),

              // Foto de perfil como ícono final
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/instagram/retrato.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Método auxiliar para construir cada historia destacada
  Widget construirElementoHistoria(
    String rutaImagen,
    String etiqueta,
    Color textoColor,
    Color bordeColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(45),
              image: DecorationImage(
                image: AssetImage(rutaImagen),
                fit: BoxFit.cover,
              ),
              border: Border.all(color: bordeColor, width: 1), // borde dinámico
            ),
          ),
          Text(
            etiqueta,
            style: TextStyle(fontSize: 13, color: textoColor), // texto dinámico
          ),
        ],
      ),
    );
  }
}
