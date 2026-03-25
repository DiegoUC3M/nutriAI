import 'dart:ui';

/// Translates data-level strings (food names, allergens, groups, meal slots, etc.)
/// from the canonical Spanish form to the device locale.
String tr(String text, Locale locale) {
  if (locale.languageCode != 'en') return text;
  return _en[text] ?? text;
}

/// Translates a formatted meal-item name, e.g. "Pollo a la plancha (150g)".
String trMealItem(String name, Locale locale) {
  if (locale.languageCode != 'en') return name;

  // Extract "(Xg)" suffix
  final match = RegExp(r'\s*\((\d+g)\)$').firstMatch(name);
  String core = name;
  String suffix = '';
  if (match != null) {
    core = name.substring(0, match.start);
    suffix = ' (${match.group(1)})';
  }

  // Try to split by cooking method
  for (final entry in _cookingMethods.entries) {
    if (core.endsWith(' ${entry.key}')) {
      final foodName = core.substring(0, core.length - entry.key.length - 1);
      return '${_en[foodName] ?? foodName} ${entry.value}$suffix';
    }
  }

  return '${_en[core] ?? core}$suffix';
}

// ─── Cooking methods ─────────────────────────────────────────────

const _cookingMethods = <String, String>{
  'a la plancha': 'grilled',
  'al horno': 'baked',
  'a la parrilla': 'barbecued',
  'salteado': 'sautéed',
  'al vapor': 'steamed',
};

// ─── All data-level translations (Spanish → English) ─────────────

const _en = <String, String>{
  // ── Food names ─────────────────────────────────────────────
  // Meats
  'Pollo': 'Chicken',
  'Pavo': 'Turkey',
  'Ternera': 'Beef',
  'Cerdo': 'Pork',
  'Conejo': 'Rabbit',
  'Cordero': 'Lamb',
  'Pechuga de pato': 'Duck breast',
  // Fish
  'Salmón': 'Salmon',
  'Atún': 'Tuna',
  'Merluza': 'Hake',
  'Sardinas': 'Sardines',
  'Lubina': 'Sea bass',
  'Bacalao': 'Cod',
  'Emperador': 'Swordfish',
  // Shellfish
  'Gambas': 'Shrimp',
  'Calamares': 'Squid',
  'Pulpo': 'Octopus',
  'Sepia': 'Cuttlefish',
  'Mejillones': 'Mussels',
  'Chirlas': 'Clams',
  // Eggs
  'Huevos': 'Eggs',
  'Claras de huevo': 'Egg whites',
  // Legumes
  'Lentejas': 'Lentils',
  'Garbanzos': 'Chickpeas',
  'Alubias': 'Beans',
  'Tofu': 'Tofu',
  'Tempeh': 'Tempeh',
  'Habas': 'Fava beans',
  // Cereals / Tubers
  'Arroz': 'Rice',
  'Pasta': 'Pasta',
  'Pan integral': 'Whole wheat bread',
  'Avena': 'Oats',
  'Patata': 'Potato',
  'Boniato': 'Sweet potato',
  'Quinoa': 'Quinoa',
  'Cuscús': 'Couscous',
  'Maíz': 'Corn',
  'Tortillas': 'Tortillas',
  'Arroz integral': 'Brown rice',
  'Pasta integral': 'Whole wheat pasta',
  'Pan de centeno': 'Rye bread',
  // Nuts
  'Almendras': 'Almonds',
  'Nueces': 'Walnuts',
  'Pistachos': 'Pistachios',
  'Anacardos': 'Cashews',
  'Mantequilla de cacahuete': 'Peanut butter',
  'Avellanas': 'Hazelnuts',
  // Seeds
  'Pipas de calabaza': 'Pumpkin seeds',
  'Semillas de chía': 'Chia seeds',
  'Semillas de lino': 'Flaxseeds',
  'Tahini': 'Tahini',
  // Oils / Fats
  'Aceite de oliva': 'Olive oil',
  'Aguacate': 'Avocado',
  'Aceitunas': 'Olives',
  // Vegetables
  'Brócoli': 'Broccoli',
  'Espinacas': 'Spinach',
  'Tomate': 'Tomato',
  'Pepino': 'Cucumber',
  'Zanahoria': 'Carrot',
  'Calabacín': 'Zucchini',
  'Pimiento': 'Bell pepper',
  'Cebolla': 'Onion',
  'Lechuga': 'Lettuce',
  'Champiñones': 'Mushrooms',
  'Judías verdes': 'Green beans',
  'Espárragos': 'Asparagus',
  'Coliflor': 'Cauliflower',
  'Berenjena': 'Eggplant',
  'Alcachofa': 'Artichoke',
  'Remolacha': 'Beetroot',
  'Acelgas': 'Chard',
  'Col lombarda': 'Red cabbage',
  'Apio': 'Celery',
  'Setas': 'Wild mushrooms',
  'Guisantes': 'Peas',
  'Maíz dulce': 'Sweet corn',
  // Fruits
  'Plátano': 'Banana',
  'Manzana': 'Apple',
  'Naranja': 'Orange',
  'Fresas': 'Strawberries',
  'Arándanos': 'Blueberries',
  'Kiwi': 'Kiwi',
  'Piña': 'Pineapple',
  'Mango': 'Mango',
  'Uvas': 'Grapes',
  'Pera': 'Pear',
  'Sandía': 'Watermelon',
  'Melón': 'Melon',
  'Papaya': 'Papaya',
  'Granada': 'Pomegranate',
  'Higos': 'Figs',
  'Melocotón': 'Peach',
  'Mandarina': 'Tangerine',
  'Cerezas': 'Cherries',
  'Frambuesas': 'Raspberries',
  // Dairy
  'Yogur griego': 'Greek yogurt',
  'Leche desnatada': 'Skim milk',
  'Queso fresco': 'Fresh cheese',
  'Requesón': 'Cottage cheese',
  'Queso cottage': 'Cottage cheese',
  'Yogur natural': 'Plain yogurt',
  'Leche entera': 'Whole milk',
  'Leche semi': 'Semi-skimmed milk',
  'Kéfir': 'Kefir',

  // ── Allergen tags ──────────────────────────────────────────
  'Frutos secos': 'Nuts',
  'Gluten': 'Gluten',
  'Huevo': 'Egg',
  'Lactosa': 'Lactose',
  'Mariscos': 'Shellfish',
  'Pescado': 'Fish',
  'Soja': 'Soy',
  'Frutas': 'Fruits',
  // 'Apio' already mapped above as vegetable name → Celery
  'Semillas': 'Seeds',

  // ── Display group titles ───────────────────────────────────
  'Carnes y huevos': 'Meats and eggs',
  'Pescados': 'Fish',
  // 'Mariscos' already mapped above → Shellfish
  'Legumbres': 'Legumes',
  'Cereales y tubérculos': 'Cereals and tubers',
  'Verduras': 'Vegetables',
  // 'Frutas' already mapped above → Fruits
  'Lácteos': 'Dairy',
  // 'Frutos secos' already mapped above → Nuts
  // 'Semillas' already mapped above → Seeds

  // ── Shopping category labels ───────────────────────────────
  '🥩 Proteínas': '🥩 Proteins',
  '🥛 Lácteos': '🥛 Dairy',
  '🌾 Carbohidratos': '🌾 Carbohydrates',
  '🥬 Verduras y frutas': '🥬 Vegetables and fruits',
  '🥑 Grasas saludables': '🥑 Healthy fats',
  '🧴 Suplementos y otros': '🧴 Supplements and others',

  // ── Meal slot names ────────────────────────────────────────
  'Desayuno': 'Breakfast',
  'Almuerzo': 'Lunch',
  'Cena': 'Dinner',
  'Merienda': 'Snack',
  'Media mañana': 'Morning snack',
  'Pre-cena': 'Pre-dinner',
};
