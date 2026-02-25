import 'package:flutter/material.dart';
import 'ejercicios_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gym App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _MenuCard(
              titulo: 'Ejercicios',
              icono: Icons.fitness_center,
              color: const Color.fromRGBO(103, 58, 183, 1),
              onTap: () {
                // Navigator.push lleva al usuario a otra pantalla
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EjerciciosScreen(),
                  ),
                );
              },
            ),
            // Aquí puedes añadir más cards en el futuro
            // _MenuCard(titulo: 'Rutinas', icono: Icons.list, ...),
          ],
        ),
      ),
    );
  }
}

// Widget reutilizable para cada card del menú
class _MenuCard extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.titulo,
    required this.icono,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color, color.withValues(alpha: 0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icono, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                titulo,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
