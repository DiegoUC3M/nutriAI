import 'package:flutter/material.dart';
import 'ejercicio_detalle_screen.dart';

// Modelo de datos para un ejercicio
class Ejercicio {
  final String nombre;
  final String musculo;
  final String descripcion;
  final String ejecucion;
  final String series;
  final IconData icono;

  const Ejercicio({
    required this.nombre,
    required this.musculo,
    required this.descripcion,
    required this.ejecucion,
    required this.series,
    required this.icono,
  });
}

// Lista de ejercicios con información detallada
const List<Ejercicio> ejercicios = [
  Ejercicio(
    nombre: 'Press de banca',
    musculo: 'Pecho',
    descripcion: 'Ejercicio compuesto que trabaja principalmente el pectoral mayor, tríceps y deltoides anterior.',
    ejecucion: '1. Acuéstate en el banco con los pies apoyados en el suelo.\n2. Agarra la barra con las manos algo más abiertas que el ancho de hombros.\n3. Baja la barra controladamente hasta el pecho.\n4. Empuja hacia arriba hasta extender los brazos.',
    series: '4 series x 8-12 repeticiones',
    icono: Icons.fitness_center,
  ),
  Ejercicio(
    nombre: 'Sentadilla',
    musculo: 'Piernas',
    descripcion: 'Ejercicio fundamental para cuádriceps, glúteos e isquiotibiales. Considerado el rey de los ejercicios de pierna.',
    ejecucion: '1. Coloca la barra sobre los trapecios.\n2. Pies a la anchura de los hombros, puntas ligeramente hacia fuera.\n3. Baja flexionando rodillas y caderas como si te sentaras.\n4. Baja hasta que los muslos estén paralelos al suelo.\n5. Sube empujando con los talones.',
    series: '4 series x 8-12 repeticiones',
    icono: Icons.fitness_center,
  ),
  Ejercicio(
    nombre: 'Peso muerto',
    musculo: 'Espalda / Piernas',
    descripcion: 'Ejercicio compuesto que trabaja toda la cadena posterior: espalda baja, glúteos, isquiotibiales y trapecios.',
    ejecucion: '1. Pies a la anchura de caderas, barra sobre los cordones.\n2. Agarra la barra con las manos a la anchura de hombros.\n3. Mantén la espalda recta y el pecho alto.\n4. Levanta la barra extendiendo caderas y rodillas a la vez.\n5. Baja de forma controlada.',
    series: '3 series x 5-8 repeticiones',
    icono: Icons.fitness_center,
  ),
  Ejercicio(
    nombre: 'Dominadas',
    musculo: 'Espalda',
    descripcion: 'Ejercicio con peso corporal que trabaja el dorsal ancho, bíceps y romboides.',
    ejecucion: '1. Agarra la barra con las palmas hacia fuera.\n2. Cuelga con los brazos extendidos.\n3. Tira hacia arriba hasta que la barbilla supere la barra.\n4. Baja de forma controlada.',
    series: '3 series x máximas repeticiones',
    icono: Icons.fitness_center,
  ),
  Ejercicio(
    nombre: 'Press militar',
    musculo: 'Hombros',
    descripcion: 'Ejercicio compuesto para los deltoides (hombros) y tríceps.',
    ejecucion: '1. De pie, agarra la barra a la altura de los hombros.\n2. Empuja la barra hacia arriba hasta extender los brazos.\n3. Baja controladamente hasta los hombros.\n4. Mantén el core activado durante todo el movimiento.',
    series: '4 series x 8-12 repeticiones',
    icono: Icons.fitness_center,
  ),
  Ejercicio(
    nombre: 'Curl de bíceps',
    musculo: 'Bíceps',
    descripcion: 'Ejercicio de aislamiento para los bíceps. Perfecto para desarrollar los brazos.',
    ejecucion: '1. De pie, sujeta la barra o mancuernas con los brazos extendidos.\n2. Flexiona los codos llevando el peso hacia los hombros.\n3. Aprieta el bíceps arriba.\n4. Baja de forma controlada sin mover los codos.',
    series: '3 series x 10-15 repeticiones',
    icono: Icons.fitness_center,
  ),
  Ejercicio(
    nombre: 'Extensión de tríceps',
    musculo: 'Tríceps',
    descripcion: 'Ejercicio de aislamiento para los tríceps, que representan 2/3 del brazo.',
    ejecucion: '1. Sujeta la cuerda o barra en la polea alta.\n2. Mantén los codos pegados al cuerpo.\n3. Extiende los brazos hacia abajo.\n4. Vuelve arriba de forma controlada.',
    series: '3 series x 10-15 repeticiones',
    icono: Icons.fitness_center,
  ),
  Ejercicio(
    nombre: 'Zancadas',
    musculo: 'Piernas',
    descripcion: 'Ejercicio unilateral que trabaja cuádriceps, glúteos y mejora el equilibrio.',
    ejecucion: '1. De pie con mancuernas en las manos.\n2. Da un paso largo hacia delante.\n3. Baja la rodilla trasera casi hasta el suelo.\n4. Empuja con el pie delantero para volver.\n5. Alterna piernas.',
    series: '3 series x 10-12 repeticiones por pierna',
    icono: Icons.fitness_center,
  ),
  Ejercicio(
    nombre: 'Remo con barra',
    musculo: 'Espalda',
    descripcion: 'Ejercicio compuesto para el dorsal ancho, romboides y trapecios.',
    ejecucion: '1. Inclínate hacia delante con la espalda recta (45°).\n2. Agarra la barra con las manos a la anchura de hombros.\n3. Tira de la barra hacia el abdomen.\n4. Aprieta los omoplatos arriba.\n5. Baja controladamente.',
    series: '4 series x 8-12 repeticiones',
    icono: Icons.fitness_center,
  ),
  Ejercicio(
    nombre: 'Hip thrust',
    musculo: 'Glúteos',
    descripcion: 'El mejor ejercicio para activar y desarrollar los glúteos.',
    ejecucion: '1. Apoya la espalda alta en un banco.\n2. Coloca la barra sobre la cadera.\n3. Pies a la anchura de hombros, rodillas a 90°.\n4. Empuja la cadera hacia arriba apretando los glúteos.\n5. Baja controladamente.',
    series: '4 series x 10-15 repeticiones',
    icono: Icons.fitness_center,
  ),
  Ejercicio(
    nombre: 'Fondos en paralelas',
    musculo: 'Pecho / Tríceps',
    descripcion: 'Ejercicio con peso corporal para pecho y tríceps. Inclinándote hacia delante trabajas más el pecho.',
    ejecucion: '1. Sujétate en las barras paralelas con los brazos extendidos.\n2. Baja flexionando los codos hasta 90°.\n3. Inclínate ligeramente hacia delante.\n4. Empuja hacia arriba hasta extender los brazos.',
    series: '3 series x máximas repeticiones',
    icono: Icons.fitness_center,
  ),
  Ejercicio(
    nombre: 'Plancha',
    musculo: 'Core',
    descripcion: 'Ejercicio isométrico que fortalece todo el core: abdominales, oblicuos y espalda baja.',
    ejecucion: '1. Apóyate sobre los antebrazos y las puntas de los pies.\n2. Mantén el cuerpo en línea recta de cabeza a talones.\n3. Activa el abdomen y no dejes caer la cadera.\n4. Mantén la posición el tiempo indicado.',
    series: '3 series x 30-60 segundos',
    icono: Icons.fitness_center,
  ),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EjercicioDetalleScreen(ejercicio: ejercicio),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
