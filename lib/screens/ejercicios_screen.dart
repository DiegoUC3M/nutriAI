import 'package:flutter/material.dart';

// Modelo de datos para un ejercicio
class Ejercicio {
  final String nombre;
  final String musculo;
  final IconData icono;

  const Ejercicio({
    required this.nombre,
    required this.musculo,
    required this.icono,
  });
}

// Lista de ejercicios de ejemplo
const List<Ejercicio> ejercicios = [
  Ejercicio(nombre: 'Press de banca', musculo: 'Pecho', icono: Icons.fitness_center),
  Ejercicio(nombre: 'Sentadilla', musculo: 'Piernas', icono: Icons.fitness_center),
  Ejercicio(nombre: 'Peso muerto', musculo: 'Espalda / Piernas', icono: Icons.fitness_center),
  Ejercicio(nombre: 'Dominadas', musculo: 'Espalda', icono: Icons.fitness_center),
  Ejercicio(nombre: 'Press militar', musculo: 'Hombros', icono: Icons.fitness_center),
  Ejercicio(nombre: 'Curl de bíceps', musculo: 'Bíceps', icono: Icons.fitness_center),
  Ejercicio(nombre: 'Extensión de tríceps', musculo: 'Tríceps', icono: Icons.fitness_center),
  Ejercicio(nombre: 'Zancadas', musculo: 'Piernas', icono: Icons.fitness_center),
  Ejercicio(nombre: 'Remo con barra', musculo: 'Espalda', icono: Icons.fitness_center),
  Ejercicio(nombre: 'Hip thrust', musculo: 'Glúteos', icono: Icons.fitness_center),
  Ejercicio(nombre: 'Fondos en paralelas', musculo: 'Pecho / Tríceps', icono: Icons.fitness_center),
  Ejercicio(nombre: 'Plancha', musculo: 'Core', icono: Icons.fitness_center),
];

class EjerciciosScreen extends StatelessWidget {
  const EjerciciosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicios'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: ejercicios.length,
        // separatedBuilder añade un divisor entre cada elemento
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final ejercicio = ejercicios[index];

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.deepPurple.withValues(alpha: 0.15),
              child: const Icon(Icons.fitness_center, color: Colors.deepPurple),
            ),
            title: Text(
              ejercicio.nombre,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(ejercicio.musculo),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Aquí en el futuro puedes navegar al detalle del ejercicio
            },
          );
        },
      ),
    );
  }
}
