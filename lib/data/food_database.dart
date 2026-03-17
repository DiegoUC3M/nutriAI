enum FoodCategory { protein, carb, fat, vegetable, fruit, dairy }

class FoodItem {
  final String name;
  final FoodCategory category;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;
  final int caloriesPer100g;
  final Set<String> allergenTags;
  final double defaultServingG;
  final String defaultUnit; // 'g', 'ml', 'ud'

  const FoodItem({
    required this.name,
    required this.category,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
    required this.caloriesPer100g,
    this.allergenTags = const {},
    this.defaultServingG = 100,
    this.defaultUnit = 'g',
  });

  double proteinForGrams(double g) => proteinPer100g * g / 100;
  double carbsForGrams(double g) => carbsPer100g * g / 100;
  double fatForGrams(double g) => fatPer100g * g / 100;
  int caloriesForGrams(double g) => (caloriesPer100g * g / 100).round();
}

// ─── Base de datos: valores por 100g cocidos/listos para comer ───

const foodDatabase = <FoodItem>[
  // ── Proteínas ──────────────────────────────────────────────
  FoodItem(name: 'Pollo',      category: FoodCategory.protein, proteinPer100g: 27.0, carbsPer100g: 0.0,  fatPer100g: 3.6,  caloriesPer100g: 143, defaultServingG: 150),
  FoodItem(name: 'Pavo',       category: FoodCategory.protein, proteinPer100g: 29.0, carbsPer100g: 0.0,  fatPer100g: 1.0,  caloriesPer100g: 127, defaultServingG: 150),
  FoodItem(name: 'Ternera',    category: FoodCategory.protein, proteinPer100g: 26.0, carbsPer100g: 0.0,  fatPer100g: 8.0,  caloriesPer100g: 176, defaultServingG: 150),
  FoodItem(name: 'Cerdo',      category: FoodCategory.protein, proteinPer100g: 25.0, carbsPer100g: 0.0,  fatPer100g: 10.0, caloriesPer100g: 190, defaultServingG: 150),
  FoodItem(name: 'Salmón',     category: FoodCategory.protein, proteinPer100g: 20.0, carbsPer100g: 0.0,  fatPer100g: 13.0, caloriesPer100g: 208, allergenTags: {'Pescado'}, defaultServingG: 150),
  FoodItem(name: 'Atún',       category: FoodCategory.protein, proteinPer100g: 23.0, carbsPer100g: 0.0,  fatPer100g: 5.0,  caloriesPer100g: 137, allergenTags: {'Pescado'}, defaultServingG: 150),
  FoodItem(name: 'Merluza',    category: FoodCategory.protein, proteinPer100g: 17.0, carbsPer100g: 0.0,  fatPer100g: 0.7,  caloriesPer100g: 74,  allergenTags: {'Pescado'}, defaultServingG: 180),
  FoodItem(name: 'Huevos',     category: FoodCategory.protein, proteinPer100g: 13.0, carbsPer100g: 1.1,  fatPer100g: 11.0, caloriesPer100g: 155, allergenTags: {'Huevo'}, defaultServingG: 120, defaultUnit: 'ud'),
  FoodItem(name: 'Tofu',       category: FoodCategory.protein, proteinPer100g: 8.0,  carbsPer100g: 1.9,  fatPer100g: 4.8,  caloriesPer100g: 76,  allergenTags: {'Soja'}, defaultServingG: 200),
  FoodItem(name: 'Tempeh',     category: FoodCategory.protein, proteinPer100g: 19.0, carbsPer100g: 9.4,  fatPer100g: 11.0, caloriesPer100g: 192, allergenTags: {'Soja'}, defaultServingG: 150),
  FoodItem(name: 'Lentejas',   category: FoodCategory.protein, proteinPer100g: 9.0,  carbsPer100g: 20.0, fatPer100g: 0.4,  caloriesPer100g: 116, defaultServingG: 180),
  FoodItem(name: 'Garbanzos',  category: FoodCategory.protein, proteinPer100g: 8.9,  carbsPer100g: 27.0, fatPer100g: 2.6,  caloriesPer100g: 164, defaultServingG: 180),
  FoodItem(name: 'Gambas',     category: FoodCategory.protein, proteinPer100g: 24.0, carbsPer100g: 0.2,  fatPer100g: 0.3,  caloriesPer100g: 99,  allergenTags: {'Mariscos'}, defaultServingG: 150),
  FoodItem(name: 'Sardinas',   category: FoodCategory.protein, proteinPer100g: 21.0, carbsPer100g: 0.0,  fatPer100g: 9.0,  caloriesPer100g: 169, allergenTags: {'Pescado'}, defaultServingG: 120),
  FoodItem(name: 'Conejo',          category: FoodCategory.protein, proteinPer100g: 21.0, carbsPer100g: 0.0,  fatPer100g: 3.5,  caloriesPer100g: 136, defaultServingG: 150),
  FoodItem(name: 'Cordero',         category: FoodCategory.protein, proteinPer100g: 25.0, carbsPer100g: 0.0,  fatPer100g: 14.0, caloriesPer100g: 230, defaultServingG: 150),
  FoodItem(name: 'Lubina',          category: FoodCategory.protein, proteinPer100g: 18.0, carbsPer100g: 0.0,  fatPer100g: 2.0,  caloriesPer100g: 97,  allergenTags: {'Pescado'}, defaultServingG: 180),
  FoodItem(name: 'Bacalao',         category: FoodCategory.protein, proteinPer100g: 18.0, carbsPer100g: 0.0,  fatPer100g: 0.7,  caloriesPer100g: 82,  allergenTags: {'Pescado'}, defaultServingG: 180),
  FoodItem(name: 'Pechuga de pato', category: FoodCategory.protein, proteinPer100g: 23.5, carbsPer100g: 0.0,  fatPer100g: 6.0,  caloriesPer100g: 159, defaultServingG: 150),
  FoodItem(name: 'Claras de huevo', category: FoodCategory.protein, proteinPer100g: 11.0, carbsPer100g: 0.7,  fatPer100g: 0.2,  caloriesPer100g: 52,  allergenTags: {'Huevo'}, defaultServingG: 150, defaultUnit: 'ud'),
  FoodItem(name: 'Alubias',         category: FoodCategory.protein, proteinPer100g: 8.7,  carbsPer100g: 21.0, fatPer100g: 0.5,  caloriesPer100g: 127, defaultServingG: 180),
  FoodItem(name: 'Calamares',       category: FoodCategory.protein, proteinPer100g: 17.0, carbsPer100g: 1.8,  fatPer100g: 1.4,  caloriesPer100g: 92,  allergenTags: {'Mariscos'}, defaultServingG: 150),

  // ── Carbohidratos ──────────────────────────────────────────
  FoodItem(name: 'Arroz',          category: FoodCategory.carb, proteinPer100g: 2.7,  carbsPer100g: 28.0, fatPer100g: 0.3,  caloriesPer100g: 130, defaultServingG: 150),
  FoodItem(name: 'Pasta',          category: FoodCategory.carb, proteinPer100g: 5.0,  carbsPer100g: 25.0, fatPer100g: 0.9,  caloriesPer100g: 131, allergenTags: {'Gluten'}, defaultServingG: 150),
  FoodItem(name: 'Pan integral',   category: FoodCategory.carb, proteinPer100g: 13.0, carbsPer100g: 41.0, fatPer100g: 3.5,  caloriesPer100g: 247, allergenTags: {'Gluten'}, defaultServingG: 60),
  FoodItem(name: 'Avena',          category: FoodCategory.carb, proteinPer100g: 13.0, carbsPer100g: 66.0, fatPer100g: 6.5,  caloriesPer100g: 389, allergenTags: {'Gluten'}, defaultServingG: 50),
  FoodItem(name: 'Patata',         category: FoodCategory.carb, proteinPer100g: 2.0,  carbsPer100g: 17.0, fatPer100g: 0.1,  caloriesPer100g: 77,  defaultServingG: 200),
  FoodItem(name: 'Boniato',        category: FoodCategory.carb, proteinPer100g: 1.6,  carbsPer100g: 20.0, fatPer100g: 0.1,  caloriesPer100g: 86,  defaultServingG: 200),
  FoodItem(name: 'Quinoa',         category: FoodCategory.carb, proteinPer100g: 4.4,  carbsPer100g: 21.0, fatPer100g: 1.9,  caloriesPer100g: 120, defaultServingG: 150),
  FoodItem(name: 'Cuscús',         category: FoodCategory.carb, proteinPer100g: 3.8,  carbsPer100g: 23.0, fatPer100g: 0.2,  caloriesPer100g: 112, allergenTags: {'Gluten'}, defaultServingG: 150),
  FoodItem(name: 'Maíz',           category: FoodCategory.carb, proteinPer100g: 3.3,  carbsPer100g: 19.0, fatPer100g: 1.5,  caloriesPer100g: 96,  defaultServingG: 150),
  FoodItem(name: 'Tortillas',      category: FoodCategory.carb, proteinPer100g: 8.0,  carbsPer100g: 44.0, fatPer100g: 7.0,  caloriesPer100g: 270, allergenTags: {'Gluten'}, defaultServingG: 50),
  FoodItem(name: 'Arroz integral',  category: FoodCategory.carb, proteinPer100g: 2.6,  carbsPer100g: 23.0, fatPer100g: 0.9,  caloriesPer100g: 111, defaultServingG: 150),
  FoodItem(name: 'Pasta integral',  category: FoodCategory.carb, proteinPer100g: 5.3,  carbsPer100g: 25.0, fatPer100g: 0.5,  caloriesPer100g: 124, allergenTags: {'Gluten'}, defaultServingG: 150),
  FoodItem(name: 'Pan de centeno',  category: FoodCategory.carb, proteinPer100g: 8.5,  carbsPer100g: 48.0, fatPer100g: 3.3,  caloriesPer100g: 259, allergenTags: {'Gluten'}, defaultServingG: 60),

  // ── Grasas saludables ──────────────────────────────────────
  FoodItem(name: 'Aceite de oliva',           category: FoodCategory.fat, proteinPer100g: 0.0,  carbsPer100g: 0.0,  fatPer100g: 100.0, caloriesPer100g: 884, defaultServingG: 15, defaultUnit: 'ml'),
  FoodItem(name: 'Aguacate',                  category: FoodCategory.fat, proteinPer100g: 2.0,  carbsPer100g: 8.5,  fatPer100g: 14.7,  caloriesPer100g: 160, defaultServingG: 80),
  FoodItem(name: 'Frutos secos',              category: FoodCategory.fat, proteinPer100g: 20.0, carbsPer100g: 21.0, fatPer100g: 49.0,  caloriesPer100g: 607, allergenTags: {'Frutos secos'}, defaultServingG: 30),
  FoodItem(name: 'Mantequilla de cacahuete',  category: FoodCategory.fat, proteinPer100g: 25.0, carbsPer100g: 20.0, fatPer100g: 50.0,  caloriesPer100g: 588, allergenTags: {'Cacahuetes'}, defaultServingG: 20),
  FoodItem(name: 'Semillas de chía',          category: FoodCategory.fat, proteinPer100g: 17.0, carbsPer100g: 42.0, fatPer100g: 31.0,  caloriesPer100g: 486, defaultServingG: 15),
  FoodItem(name: 'Almendras',                 category: FoodCategory.fat, proteinPer100g: 21.0, carbsPer100g: 22.0, fatPer100g: 49.0,  caloriesPer100g: 579, allergenTags: {'Frutos secos'}, defaultServingG: 30),
  FoodItem(name: 'Nueces',                    category: FoodCategory.fat, proteinPer100g: 15.0, carbsPer100g: 14.0, fatPer100g: 65.0,  caloriesPer100g: 654, allergenTags: {'Frutos secos'}, defaultServingG: 25),
  FoodItem(name: 'Semillas de lino',           category: FoodCategory.fat, proteinPer100g: 18.0, carbsPer100g: 29.0, fatPer100g: 42.0,  caloriesPer100g: 534, defaultServingG: 15),
  FoodItem(name: 'Pistachos',                  category: FoodCategory.fat, proteinPer100g: 20.0, carbsPer100g: 28.0, fatPer100g: 45.0,  caloriesPer100g: 560, allergenTags: {'Frutos secos'}, defaultServingG: 30),
  FoodItem(name: 'Anacardos',                  category: FoodCategory.fat, proteinPer100g: 18.0, carbsPer100g: 30.0, fatPer100g: 44.0,  caloriesPer100g: 553, allergenTags: {'Frutos secos'}, defaultServingG: 30),
  FoodItem(name: 'Tahini',                     category: FoodCategory.fat, proteinPer100g: 17.0, carbsPer100g: 21.0, fatPer100g: 48.0,  caloriesPer100g: 595, defaultServingG: 15),
  FoodItem(name: 'Aceitunas',                  category: FoodCategory.fat, proteinPer100g: 1.0,  carbsPer100g: 4.0,  fatPer100g: 15.0,  caloriesPer100g: 145, defaultServingG: 30),
  FoodItem(name: 'Pipas de calabaza',          category: FoodCategory.fat, proteinPer100g: 30.0, carbsPer100g: 11.0, fatPer100g: 49.0,  caloriesPer100g: 559, defaultServingG: 25),

  // ── Verduras ───────────────────────────────────────────────
  FoodItem(name: 'Brócoli',        category: FoodCategory.vegetable, proteinPer100g: 2.8, carbsPer100g: 7.0,  fatPer100g: 0.4, caloriesPer100g: 34,  defaultServingG: 150),
  FoodItem(name: 'Espinacas',      category: FoodCategory.vegetable, proteinPer100g: 2.9, carbsPer100g: 3.6,  fatPer100g: 0.4, caloriesPer100g: 23,  defaultServingG: 100),
  FoodItem(name: 'Tomate',         category: FoodCategory.vegetable, proteinPer100g: 0.9, carbsPer100g: 3.9,  fatPer100g: 0.2, caloriesPer100g: 18,  defaultServingG: 150),
  FoodItem(name: 'Pepino',         category: FoodCategory.vegetable, proteinPer100g: 0.7, carbsPer100g: 3.6,  fatPer100g: 0.1, caloriesPer100g: 15,  defaultServingG: 120),
  FoodItem(name: 'Zanahoria',      category: FoodCategory.vegetable, proteinPer100g: 0.9, carbsPer100g: 10.0, fatPer100g: 0.2, caloriesPer100g: 41,  defaultServingG: 120),
  FoodItem(name: 'Calabacín',      category: FoodCategory.vegetable, proteinPer100g: 1.2, carbsPer100g: 3.1,  fatPer100g: 0.3, caloriesPer100g: 17,  defaultServingG: 150),
  FoodItem(name: 'Pimiento',       category: FoodCategory.vegetable, proteinPer100g: 1.0, carbsPer100g: 6.0,  fatPer100g: 0.3, caloriesPer100g: 26,  defaultServingG: 130),
  FoodItem(name: 'Cebolla',        category: FoodCategory.vegetable, proteinPer100g: 1.1, carbsPer100g: 9.3,  fatPer100g: 0.1, caloriesPer100g: 40,  defaultServingG: 80),
  FoodItem(name: 'Lechuga',        category: FoodCategory.vegetable, proteinPer100g: 1.4, carbsPer100g: 2.9,  fatPer100g: 0.2, caloriesPer100g: 15,  defaultServingG: 80),
  FoodItem(name: 'Champiñones',    category: FoodCategory.vegetable, proteinPer100g: 3.1, carbsPer100g: 3.3,  fatPer100g: 0.3, caloriesPer100g: 22,  defaultServingG: 120),
  FoodItem(name: 'Judías verdes',  category: FoodCategory.vegetable, proteinPer100g: 1.8, carbsPer100g: 7.0,  fatPer100g: 0.1, caloriesPer100g: 31,  defaultServingG: 150),
  FoodItem(name: 'Espárragos',     category: FoodCategory.vegetable, proteinPer100g: 2.2, carbsPer100g: 3.9,  fatPer100g: 0.1, caloriesPer100g: 20,  defaultServingG: 150),
  FoodItem(name: 'Coliflor',       category: FoodCategory.vegetable, proteinPer100g: 1.9, carbsPer100g: 5.0,  fatPer100g: 0.3, caloriesPer100g: 25,  defaultServingG: 150),
  FoodItem(name: 'Berenjena',      category: FoodCategory.vegetable, proteinPer100g: 1.0, carbsPer100g: 6.0,  fatPer100g: 0.2, caloriesPer100g: 25,  defaultServingG: 150),
  FoodItem(name: 'Alcachofa',      category: FoodCategory.vegetable, proteinPer100g: 3.3, carbsPer100g: 11.0, fatPer100g: 0.2, caloriesPer100g: 47,  defaultServingG: 120),
  FoodItem(name: 'Remolacha',      category: FoodCategory.vegetable, proteinPer100g: 1.6, carbsPer100g: 10.0, fatPer100g: 0.2, caloriesPer100g: 43,  defaultServingG: 120),
  FoodItem(name: 'Acelgas',        category: FoodCategory.vegetable, proteinPer100g: 1.8, carbsPer100g: 3.7,  fatPer100g: 0.2, caloriesPer100g: 19,  defaultServingG: 150),
  FoodItem(name: 'Col lombarda',   category: FoodCategory.vegetable, proteinPer100g: 1.4, carbsPer100g: 7.4,  fatPer100g: 0.2, caloriesPer100g: 31,  defaultServingG: 120),
  FoodItem(name: 'Apio',           category: FoodCategory.vegetable, proteinPer100g: 0.7, carbsPer100g: 3.0,  fatPer100g: 0.2, caloriesPer100g: 14,  defaultServingG: 100),

  // ── Frutas ─────────────────────────────────────────────────
  FoodItem(name: 'Plátano',    category: FoodCategory.fruit, proteinPer100g: 1.1, carbsPer100g: 23.0, fatPer100g: 0.3, caloriesPer100g: 89,  defaultServingG: 120, defaultUnit: 'ud'),
  FoodItem(name: 'Manzana',    category: FoodCategory.fruit, proteinPer100g: 0.3, carbsPer100g: 14.0, fatPer100g: 0.2, caloriesPer100g: 52,  defaultServingG: 180, defaultUnit: 'ud'),
  FoodItem(name: 'Naranja',    category: FoodCategory.fruit, proteinPer100g: 0.9, carbsPer100g: 12.0, fatPer100g: 0.1, caloriesPer100g: 47,  defaultServingG: 200, defaultUnit: 'ud'),
  FoodItem(name: 'Fresas',     category: FoodCategory.fruit, proteinPer100g: 0.7, carbsPer100g: 7.7,  fatPer100g: 0.3, caloriesPer100g: 32,  defaultServingG: 150),
  FoodItem(name: 'Arándanos',  category: FoodCategory.fruit, proteinPer100g: 0.7, carbsPer100g: 14.0, fatPer100g: 0.3, caloriesPer100g: 57,  defaultServingG: 100),
  FoodItem(name: 'Kiwi',       category: FoodCategory.fruit, proteinPer100g: 1.1, carbsPer100g: 15.0, fatPer100g: 0.5, caloriesPer100g: 61,  defaultServingG: 150, defaultUnit: 'ud'),
  FoodItem(name: 'Piña',       category: FoodCategory.fruit, proteinPer100g: 0.5, carbsPer100g: 13.0, fatPer100g: 0.1, caloriesPer100g: 50,  defaultServingG: 150),
  FoodItem(name: 'Mango',      category: FoodCategory.fruit, proteinPer100g: 0.8, carbsPer100g: 15.0, fatPer100g: 0.4, caloriesPer100g: 60,  defaultServingG: 150),
  FoodItem(name: 'Uvas',       category: FoodCategory.fruit, proteinPer100g: 0.7, carbsPer100g: 18.0, fatPer100g: 0.2, caloriesPer100g: 69,  defaultServingG: 120),
  FoodItem(name: 'Pera',       category: FoodCategory.fruit, proteinPer100g: 0.4, carbsPer100g: 15.0, fatPer100g: 0.1, caloriesPer100g: 57,  defaultServingG: 180, defaultUnit: 'ud'),
  FoodItem(name: 'Sandía',     category: FoodCategory.fruit, proteinPer100g: 0.6, carbsPer100g: 7.6,  fatPer100g: 0.2, caloriesPer100g: 30,  defaultServingG: 200),
  FoodItem(name: 'Melón',      category: FoodCategory.fruit, proteinPer100g: 0.8, carbsPer100g: 8.2,  fatPer100g: 0.2, caloriesPer100g: 34,  defaultServingG: 200),
  FoodItem(name: 'Papaya',     category: FoodCategory.fruit, proteinPer100g: 0.5, carbsPer100g: 11.0, fatPer100g: 0.3, caloriesPer100g: 43,  defaultServingG: 150),
  FoodItem(name: 'Granada',    category: FoodCategory.fruit, proteinPer100g: 1.7, carbsPer100g: 19.0, fatPer100g: 1.2, caloriesPer100g: 83,  defaultServingG: 120, defaultUnit: 'ud'),
  FoodItem(name: 'Higos',      category: FoodCategory.fruit, proteinPer100g: 0.8, carbsPer100g: 19.0, fatPer100g: 0.3, caloriesPer100g: 74,  defaultServingG: 100),
  FoodItem(name: 'Melocotón',  category: FoodCategory.fruit, proteinPer100g: 0.9, carbsPer100g: 10.0, fatPer100g: 0.3, caloriesPer100g: 39,  defaultServingG: 170, defaultUnit: 'ud'),
  FoodItem(name: 'Mandarina',  category: FoodCategory.fruit, proteinPer100g: 0.8, carbsPer100g: 13.0, fatPer100g: 0.3, caloriesPer100g: 53,  defaultServingG: 150, defaultUnit: 'ud'),
  FoodItem(name: 'Cerezas',    category: FoodCategory.fruit, proteinPer100g: 1.1, carbsPer100g: 16.0, fatPer100g: 0.2, caloriesPer100g: 63,  defaultServingG: 120),

  // ── Lácteos ────────────────────────────────────────────────
  FoodItem(name: 'Yogur griego',    category: FoodCategory.dairy, proteinPer100g: 10.0, carbsPer100g: 3.6,  fatPer100g: 5.0,  caloriesPer100g: 97,  allergenTags: {'Lactosa'}, defaultServingG: 170, defaultUnit: 'ud'),
  FoodItem(name: 'Leche desnatada', category: FoodCategory.dairy, proteinPer100g: 3.4,  carbsPer100g: 5.0,  fatPer100g: 0.1,  caloriesPer100g: 34,  allergenTags: {'Lactosa'}, defaultServingG: 250, defaultUnit: 'ml'),
  FoodItem(name: 'Queso fresco',    category: FoodCategory.dairy, proteinPer100g: 11.0, carbsPer100g: 3.3,  fatPer100g: 8.0,  caloriesPer100g: 174, allergenTags: {'Lactosa'}, defaultServingG: 80),
  FoodItem(name: 'Requesón',        category: FoodCategory.dairy, proteinPer100g: 11.0, carbsPer100g: 3.4,  fatPer100g: 4.3,  caloriesPer100g: 98,  allergenTags: {'Lactosa'}, defaultServingG: 100),
  FoodItem(name: 'Queso cottage',   category: FoodCategory.dairy, proteinPer100g: 11.0, carbsPer100g: 3.4,  fatPer100g: 4.3,  caloriesPer100g: 98,  allergenTags: {'Lactosa'}, defaultServingG: 100),
  FoodItem(name: 'Yogur natural',   category: FoodCategory.dairy, proteinPer100g: 5.0,  carbsPer100g: 7.0,  fatPer100g: 0.7,  caloriesPer100g: 56,  allergenTags: {'Lactosa'}, defaultServingG: 125, defaultUnit: 'ud'),
];

final Map<String, FoodItem> foodByName = {
  for (final f in foodDatabase) f.name: f,
};

/// Lista de nombres de alimentos por categoría (derivada de la BD).
List<String> foodNamesFor(FoodCategory category) =>
    foodDatabase.where((f) => f.category == category).map((f) => f.name).toList();

/// Todas las etiquetas de alérgenos presentes en la base de datos.
final List<String> allAllergenTags = () {
  final tags = <String>{};
  for (final f in foodDatabase) {
    tags.addAll(f.allergenTags);
  }
  return tags.toList()..sort();
}();

/// Mapa de categoría a etiqueta de la lista de compra.
String shoppingLabel(FoodCategory cat) => switch (cat) {
  FoodCategory.protein => '🥩 Proteínas',
  FoodCategory.dairy => '🥛 Lácteos',
  FoodCategory.carb => '🌾 Carbohidratos',
  FoodCategory.vegetable || FoodCategory.fruit => '🥬 Verduras y frutas',
  FoodCategory.fat => '🥑 Grasas saludables',
};
