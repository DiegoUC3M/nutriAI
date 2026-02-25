import 'package:flutter/material.dart';
import 'ejercicios_screen.dart';

class EjercicioDetalleScreen extends StatelessWidget {
  final Ejercicio ejercicio;

  const EjercicioDetalleScreen({super.key, required this.ejercicio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ejercicio.nombre),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera con icono y músculo
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.fitness_center,
                  size: 48,
                  color: Colors.deepPurple,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Chip(
                label: Text(
                  ejercicio.musculo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 24),

            // Descripción
            _SeccionTitulo(titulo: 'Descripción'),
            const SizedBox(height: 8),
            Text(
              ejercicio.descripcion,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),

            // Ejecución
            _SeccionTitulo(titulo: 'Cómo ejecutarlo'),
            const SizedBox(height: 8),
            Text(
              ejercicio.ejecucion,
              style: const TextStyle(fontSize: 16, height: 1.8),
            ),
            const SizedBox(height: 24),

            // Series recomendadas
            _SeccionTitulo(titulo: 'Series recomendadas'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer, color: Colors.deepPurple),
                  const SizedBox(width: 12),
                  Text(
                    ejercicio.series,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para los títulos de cada sección
class _SeccionTitulo extends StatelessWidget {
  final String titulo;
  const _SeccionTitulo({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Text(
      titulo,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
    );
  }
}
