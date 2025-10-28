// lib/data/smart_mart_items_data.dart
import 'package:grocery_stores/models/deal.dart';
import 'package:grocery_stores/models/main_item.dart';

class mainItemsData {
  static final List<mainItem> items = [
    // Fresh Fruit
    mainItem(
      brandId: '1',
      id: '1',
      name: 'Fresh Apples',
      nameKu: 'سێوی تازە',
      category: 'Fresh Fruit',
      categoryKu: 'میوەی تازە',
      price: 2000,
      imageUrl: 'https://i.ibb.co/ZRrG2TDx/apples.png',
      description: 'Crisp, sweet red apples - 1kg',
      descriptionKu: 'سێوی سوور شیرین و وشک - ١ کیلۆ',
      hasDiscount: true,
      discountPercentage: 20.0,
      adId: '1',
          
    ),
    mainItem(
      brandId: '1',
      id: '2',
      name: 'Bananas',
      nameKu: 'مۆز',
      category: 'Fresh Fruit',
      categoryKu: 'میوەی تازە',
      price: 1500,
      imageUrl:
          'https://i.ibb.co/QFWJxLFY/banana.png',
      description: 'Sweet ripe bananas - per bunch',
      descriptionKu: 'مۆزی شیرین و گەیشتوو - هەر دەستەیەک',
      bulkOffer: 'Buy 5 Get 1',
      bulkOfferKu: 'پێنج بکڕە یەکێک بەخۆڕایی وەربگرە',
      adId: '1',
    ),
    mainItem(
      brandId: '1',
      id: '3',
      name: 'Oranges',
      nameKu: 'پرتەقاڵ',
      category: 'Fresh Fruit',
      categoryKu: 'میوەی تازە',
      price: 2500,
      imageUrl:
          'https://images.unsplash.com/photo-1547514701-42782101795e?w=300',
      description: 'Juicy naval oranges - 1kg',
      descriptionKu: 'پرتەقاڵی ئاوەدار - ١ کیلۆ',
    ),
    mainItem(
      brandId: '2',
      id: '4',
      name: 'Strawberries',
      nameKu: 'تووفرەنگ',
      category: 'Fresh Fruit',
      categoryKu: 'میوەی تازە',
      price: 4000,
      imageUrl:
          'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=300',
      description: 'Sweet fresh strawberries - 500g',
      descriptionKu: 'تووفرەنگی تازە و شیرین - ٥٠٠ گرام',
    ),
    mainItem(
      brandId: '3',
      id: '5',
      name: 'Grapes',
      nameKu: 'ترێ',
      category: 'Fresh Fruit',
      categoryKu: 'میوەی تازە',
      price: 3500,
      imageUrl:
          'https://images.unsplash.com/photo-1537640538966-79f369143b8f?w=300',
      description: 'Red seedless grapes - 500g',
      descriptionKu: 'ترێی سوور بێ تۆو - ٥٠٠ گرام',
    ),
    mainItem(
      brandId: '1',
      id: '6',
      name: 'Pineapple',
      nameKu: 'ئەناناس',
      category: 'Fresh Fruit',
      categoryKu: 'میوەی تازە',
      price: 4500,
      imageUrl:
          'https://images.unsplash.com/photo-1550258987-190a2d41a8ba?w=300',
      description: 'Sweet tropical pineapple - 1 piece',
      descriptionKu: 'ئەناناسی گەرمسێری شیرین - یەک دانە',
    ),

    // Fresh Vegetables
    mainItem(
      brandId: '1',
      id: '7',
      name: 'Fresh Spinach',
      nameKu: 'ئەسپەناخی تازە',
      category: 'Fresh Vegetables',
      categoryKu: 'سەوزەی تازە',
      price: 2000,
      imageUrl:
          'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=300',
      description: 'Fresh baby spinach leaves - 200g',
      descriptionKu: 'گەڵای ئەسپەناخی منداڵانە - ٢٠٠ گرام',
    ),
    mainItem(
      brandId: '1',
      id: '8',
      name: 'Ripe Tomatoes',
      nameKu: 'تەماتەی گەیشتوو',
      category: 'Fresh Vegetables',
      categoryKu: 'سەوزەی تازە',
      price: 3000,
      imageUrl:
          'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=300',
      description: 'Vine-ripened tomatoes - 500g',
      descriptionKu: 'تەماتەی لەسەر دار گەیشتوو - ٥٠٠ گرام',
    ),
    mainItem(
      brandId: '4',
      id: '9',
      name: 'Carrots',
      nameKu: 'گەزەر',
      category: 'Fresh Vegetables',
      categoryKu: 'سەوزەی تازە',
      price: 1800,
      imageUrl:
          'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=300',
      description: 'Fresh organic carrots - 1kg',
      descriptionKu: 'گەزەری ئۆرگانیک تازە - ١ کیلۆ',
    ),
    mainItem(
      brandId: '1',
      id: '10',
      name: 'Bell Peppers',
      nameKu: 'بیبەری شیرین',
      category: 'Fresh Vegetables',
      categoryKu: 'سەوزەی تازە',
      price: 2500,
      imageUrl:
          'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=300',
      description: 'Mixed color bell peppers - 3 pack',
      descriptionKu: 'بیبەری شیرینی ڕەنگ جیاواز - پاکێتی ٣ دانە',
    ),
    mainItem(
      brandId: '1',
      id: '11',
      name: 'Broccoli',
      nameKu: 'بڕۆکۆلی',
      category: 'Fresh Vegetables',
      categoryKu: 'سەوزەی تازە',
      price: 2200,
      imageUrl:
          'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?w=300',
      description: 'Fresh green broccoli - 1 head',
      descriptionKu: 'بڕۆکۆلی سەوزی تازە - یەک سەر',
    ),
    mainItem(
      brandId: '1',
      id: '12',
      name: 'Cucumbers',
      nameKu: 'خیار',
      category: 'Fresh Vegetables',
      categoryKu: 'سەوزەی تازە',
      price: 1500,
      imageUrl:
          'https://images.unsplash.com/photo-1449300079323-02e209d9d3a6?w=300',
      description: 'Fresh cucumbers - 3 pieces',
      descriptionKu: 'خیاری تازە - ٣ دانە',
    ),

    // Dairy
    mainItem(
      brandId: '1',
      id: '13',
      name: 'Whole Milk',
      nameKu: 'شیری تەواو',
      category: 'Dairy',
      categoryKu: 'شیر و بەرهەمەکانی',
      price: 3000,
      imageUrl:
          'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=300',
      description: 'Fresh whole milk - 1L',
      descriptionKu: 'شیری تەواوی تازە - ١ لیتر',
    ),
    mainItem(
      brandId: '1',
      id: '14',
      name: 'Cheddar Cheese',
      nameKu: 'پەنیری چێدار',
      category: 'Dairy',
      categoryKu: 'شیر و بەرهەمەکانی',
      price: 4500,
      imageUrl:
          'https://images.unsplash.com/photo-1486297678162-eb2a19b0a32d?w=300',
      description: 'Aged cheddar cheese block - 400g',
      descriptionKu: 'پەنیری چێداری کۆن - ٤٠٠ گرام',
    ),
    mainItem(
      brandId: '5',
      id: '15',
      name: 'Greek Yogurt',
      nameKu: 'ماستی یۆنانی',
      category: 'Dairy',
      categoryKu: 'شیر و بەرهەمەکانی',
      price: 3500,
      imageUrl:
          'https://images.unsplash.com/photo-1571212515416-ffeec4f162e4?w=300',
      description: 'Natural Greek yogurt - 500g',
      descriptionKu: 'ماستی یۆنانی سروشتی - ٥٠٠ گرام',
    ),
    mainItem(
      brandId: '6',
      id: '16',
      name: 'Butter',
      nameKu: 'کەرە',
      category: 'Dairy',
      categoryKu: 'شیر و بەرهەمەکانی',
      price: 2800,
      imageUrl:
          'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?w=300',
      description: 'Unsalted butter - 250g',
      descriptionKu: 'کەرەی بێ خوێ - ٢٥٠ گرام',
    ),
    mainItem(
      brandId: '1',
      id: '17',
      name: 'Eggs',
      nameKu: 'هێلکە',
      category: 'Dairy',
      categoryKu: 'شیر و بەرهەمەکانی',
      price: 2500,
      imageUrl:
          'https://images.unsplash.com/photo-1518569656558-1f25e69d93d7?w=300',
      description: 'Free-range eggs - dozen',
      descriptionKu: 'هێلکەی مریشکی ئازاد - دوانزە دانە',
    ),

    // Meat & Poultry
    mainItem(
      brandId: '1',
      id: '18',
      name: 'Chicken Breast',
      nameKu: 'سنگی مریشک',
      category: 'Meat & Poultry',
      categoryKu: 'گۆشت و مریشک',
      price: 8000,
      imageUrl:
          'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=300',
      description: 'Boneless chicken breast - 1kg',
      descriptionKu: 'سنگی مریشکی بێ ئێسک - ١ کیلۆ',
    ),
    mainItem(
      brandId: '1',
      id: '19',
      name: 'Ground Beef',
      nameKu: 'گۆشتی ساییکراو',
      category: 'Meat & Poultry',
      categoryKu: 'گۆشت و مریشک',
      price: 9500,
      imageUrl:
          'https://images.unsplash.com/photo-1529692236671-f1f6cf9683ba?w=300',
      description: 'Lean ground beef - 500g',
      descriptionKu: 'گۆشتی ساییکراوی ناویان - ٥٠٠ گرام',
    ),
    mainItem(
      brandId: '2',
      id: '20',
      name: 'Salmon Fillet',
      nameKu: 'لەتە ماسی سالمۆن',
      category: 'Meat & Poultry',
      categoryKu: 'گۆشت و مریشک',
      price: 12000,
      imageUrl:
          'https://images.unsplash.com/photo-1574781330855-d0db0021a4c5?w=300',
      description: 'Fresh Atlantic salmon - 400g',
      descriptionKu: 'ماسی سالمۆنی ئەتڵەنتیک تازە - ٤٠٠ گرام',
    ),
    mainItem(
      brandId: '1',
      id: '21',
      name: 'Pork Chops',
      nameKu: 'پارچە گۆشتی بەراز',
      category: 'Meat & Poultry',
      categoryKu: 'گۆشت و مریشک',
      price: 7500,
      imageUrl:
          'https://images.unsplash.com/photo-1602470520998-f4a52199a3d6?w=300',
      description: 'Bone-in pork chops - 4 pieces',
      descriptionKu: 'پارچە گۆشتی بەرازی بە ئێسک - ٤ پارچە',
    ),

    // Bakery
    mainItem(
      brandId: '1',
      id: '22',
      name: 'Whole Wheat Bread',
      nameKu: 'نانی گەنمی تەواو',
      category: 'Bakery',
      categoryKu: 'نانەواخانە',
      price: 2500,
      imageUrl:
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300',
      description: 'Artisan whole wheat loaf - 600g',
      descriptionKu: 'نانی گەنمی تەواوی دەستکرد - ٦٠٠ گرام',
    ),
    mainItem(
      brandId: '1',
      id: '23',
      name: 'Croissants',
      nameKu: 'کڕۆیسان',
      category: 'Bakery',
      categoryKu: 'نانەواخانە',
      price: 3000,
      imageUrl:
          'https://images.unsplash.com/photo-1555507036-ab1f4038808a?w=300',
      description: 'Buttery croissants - 4 pack',
      descriptionKu: 'کڕۆیسانی کەرەیی - پاکێتی ٤ دانە',
    ),
    mainItem(
      brandId: '1',
      id: '24',
      name: 'Bagels',
      nameKu: 'بەیگڵ',
      category: 'Bakery',
      categoryKu: 'نانەواخانە',
      price: 3500,
      imageUrl:
          'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=300',
      description: 'Everything bagels - 6 pack',
      descriptionKu: 'بەیگڵی تێکەڵ - پاکێتی ٦ دانە',
    ),
    mainItem(
      brandId: '1',
      id: '25',
      name: 'Muffins',
      nameKu: 'مافین',
      category: 'Bakery',
      categoryKu: 'نانەواخانە',
      price: 4000,
      imageUrl:
          'https://images.unsplash.com/photo-1486427944299-d1955d23e34d?w=300',
      description: 'Blueberry muffins - 4 pack',
      descriptionKu: 'مافینی تووبەری شین - پاکێتی ٤ دانە',
    ),

    // Pantry Staples
    mainItem(
      brandId: '1',
      id: '26',
      name: 'Basmati Rice',
      nameKu: 'برنجی باسماتی',
      category: 'Pantry Staples',
      categoryKu: 'بنەڕەتەکانی ماڵەوە',
      price: 4500,
      imageUrl:
          'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300',
      description: 'Premium basmati rice - 2kg',
      descriptionKu: 'برنجی باسماتی فاخیر - ٢ کیلۆ',
    ),
    mainItem(
      brandId: '1',
      id: '27',
      name: 'Spaghetti Pasta',
      nameKu: 'پاستای ئیسپاگێتی',
      category: 'Pantry Staples',
      categoryKu: 'بنەڕەتەکانی ماڵەوە',
      price: 2000,
      imageUrl:
          'https://images.unsplash.com/photo-1551892374-ecf8050afcf2?w=300',
      description: 'Durum wheat spaghetti - 500g',
      descriptionKu: 'ئیسپاگێتی گەنمی ڕەق - ٥٠٠ گرام',
    ),
    mainItem(
      brandId: '1',
      id: '28',
      name: 'Olive Oil',
      nameKu: 'ڕووی زەیتوون',
      category: 'Pantry Staples',
      categoryKu: 'بنەڕەتەکانی ماڵەوە',
      price: 6000,
      imageUrl:
          'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300',
      description: 'Extra virgin olive oil - 500ml',
      descriptionKu: 'ڕووی زەیتوونی پاک - ٥٠٠ میلی لیتر',
    ),
    mainItem(
      brandId: '1',
      id: '29',
      name: 'Canned Tomatoes',
      nameKu: 'تەماتەی قوتووکراو',
      category: 'Pantry Staples',
      categoryKu: 'بنەڕەتەکانی ماڵەوە',
      price: 1800,
      imageUrl:
          'https://images.unsplash.com/photo-1544628162-1c4e3c0b91de?w=300',
      description: 'Whole peeled tomatoes - 400g can',
      descriptionKu: 'تەماتەی تەواو کەندراو - قوتووی ٤٠٠ گرام',
    ),
    mainItem(
      brandId: '1',
      id: '30',
      name: 'Black Beans',
      nameKu: 'لۆبیای ڕەش',
      category: 'Pantry Staples',
      categoryKu: 'بنەڕەتەکانی ماڵەوە',
      price: 1500,
      imageUrl:
          'https://images.unsplash.com/photo-1596040062121-6ec1ba605d1e?w=300',
      description: 'Organic black beans - 400g can',
      descriptionKu: 'لۆبیای ڕەشی ئۆرگانیک - قوتووی ٤٠٠ گرام',
    ),

    // Snacks
    mainItem(
      brandId: '1',
      id: '31',
      name: 'Potato Chips',
      nameKu: 'چیپسی پەتاتە',
      category: 'Snacks',
      categoryKu: 'خواردنی سووک',
      price: 2500,
      imageUrl:
          'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=300',
      description: 'Classic salted chips - 150g bag',
      descriptionKu: 'چیپسی خوێدار کلاسیک - کیسەی ١٥٠ گرام',
    ),
    mainItem(
      brandId: '1',
      id: '32',
      name: 'Mixed Nuts',
      nameKu: 'گوێزی تێکەڵ',
      category: 'Snacks',
      categoryKu: 'خواردنی سووک',
      price: 4500,
      imageUrl:
          'https://images.unsplash.com/photo-1508747703725-719777637510?w=300',
      description: 'Roasted mixed nuts - 300g',
      descriptionKu: 'گوێزی تێکەڵی بڕژاو - ٣٠٠ گرام',
    ),
    mainItem(
      brandId: '1',
      id: '33',
      name: 'Granola Bars',
      nameKu: 'گرانۆلا بار',
      category: 'Snacks',
      categoryKu: 'خواردنی سووک',
      price: 3500,
      imageUrl:
          'https://images.unsplash.com/photo-1560963805-6c64417e3413?w=300',
      description: 'Honey oat granola bars - 6 pack',
      descriptionKu: 'گرانۆلا باری هەنگوین و جۆ - پاکێتی ٦ دانە',
    ),
    mainItem(
      brandId: '1',
      id: '34',
      name: 'Pretzels',
      nameKu: 'پرێتزڵ',
      category: 'Snacks',
      categoryKu: 'خواردنی سووک',
      price: 2200,
      imageUrl:
          'https://images.unsplash.com/photo-1599490659213-e2b9527bd087?w=300',
      description: 'Salted mini pretzels - 200g',
      descriptionKu: 'پرێتزڵی بچووکی خوێدار - ٢٠٠ گرام',
    ),

    // Beverages
    mainItem(
      brandId: '1',
      id: '35',
      name: 'Orange Juice',
      nameKu: 'ئاوی پرتەقاڵ',
      category: 'Beverages',
      categoryKu: 'خواردنەوە',
      price: 3500,
      imageUrl:
          'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=300',
      description: 'Fresh orange juice - 1L',
      descriptionKu: 'ئاوی پرتەقاڵی تازە - ١ لیتر',
    ),
    mainItem(
      brandId: '1',
      id: '36',
      name: 'Coffee Beans',
      nameKu: 'دانەی قاوە',
      category: 'Beverages',
      categoryKu: 'خواردنەوە',
      price: 8000,
      imageUrl:
          'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=300',
      description: 'Arabica coffee beans - 500g',
      descriptionKu: 'دانەی قاوەی عەرەبی - ٥٠٠ گرام',
    ),
    mainItem(
      brandId: '1',
      id: '37',
      name: 'Green Tea',
      nameKu: 'چای سەوز',
      category: 'Beverages',
      categoryKu: 'خواردنەوە',
      price: 2500,
      imageUrl:
          'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=300',
      description: 'Premium green tea - 20 bags',
      descriptionKu: 'چای سەوزی فاخیر - ٢٠ کیسە',
    ),
    mainItem(
      brandId: '1',
      id: '38',
      name: 'Sparkling Water',
      nameKu: 'ئاوی گازدار',
      category: 'Beverages',
      categoryKu: 'خواردنەوە',
      price: 2000,
      imageUrl:
          'https://images.unsplash.com/photo-1523362628745-0c100150b504?w=300',
      description: 'Natural sparkling water - 500ml',
      descriptionKu: 'ئاوی گازداری سروشتی - ٥٠٠ میلی لیتر',
    ),

    // Frozen Foods
    mainItem(
      brandId: '1',
      id: '39',
      name: 'Frozen Berries',
      nameKu: 'تووبەری کەشکراو',
      category: 'Frozen Foods',
      categoryKu: 'خواردنی جەمدکراو',
      price: 4000,
      imageUrl:
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=300',
      description: 'Mixed frozen berries - 400g',
      descriptionKu: 'تووبەری کەشکراوی تێکەڵ - ٤٠٠ گرام',
    ),
    mainItem(
      brandId: '1',
      id: '40',
      name: 'Frozen Pizza',
      nameKu: 'پیزای کەشکراو',
      category: 'Frozen Foods',
      categoryKu: 'خواردنی جەمدکراو',
      price: 5500,
      imageUrl:
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=300',
      description: 'Margherita frozen pizza - 350g',
      descriptionKu: 'پیزای کەشکراوی مارگەریتا - ٣٥٠ گرام',
    ),
    mainItem(
      brandId: '1',
      id: '41',
      name: 'Ice Cream',
      nameKu: 'بەستەنی',
      category: 'Frozen Foods',
      categoryKu: 'خواردنی جەمدکراو',
      price: 4500,
      imageUrl:
          'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=300',
      description: 'Vanilla ice cream - 1L tub',
      descriptionKu: 'بەستەنی ڤانیلا - سەتڵی ١ لیتر',
    ),
    mainItem(
      brandId: '1',
      id: '42',
      name: 'Frozen Vegetables',
      nameKu: 'سەوزەی کەشکراو',
      category: 'Frozen Foods',
      categoryKu: 'خواردنی جەمدکراو',
      price: 2500,
      imageUrl:
          'https://images.unsplash.com/photo-1628773822503-930a7eaecf80?w=300',
      description: 'Mixed frozen vegetables - 500g',
      descriptionKu: 'سەوزەی کەشکراوی تێکەڵ - ٥٠٠ گرام',
    ),

    // Cleaning Supplies
    mainItem(
      brandId: '1',
      id: '43',
      name: 'Dish Soap',
      nameKu: 'سابوونی قاپ',
      category: 'Cleaning Supplies',
      categoryKu: 'کەلوپەلی پاککردنەوە',
      price: 2500,
      imageUrl:
          'https://images.unsplash.com/photo-1585761475483-02d5c23fffee?w=300',
      description: 'Liquid dish soap - 500ml',
      descriptionKu: 'سابوونی شلی قاپ - ٥٠٠ میلی لیتر',
    ),
    mainItem(
      brandId: '1',
      id: '44',
      name: 'All-Purpose Cleaner',
      nameKu: 'پاکەری گشتی',
      category: 'Cleaning Supplies',
      categoryKu: 'کەلوپەلی پاککردنەوە',
      price: 3000,
      imageUrl:
          'https://images.unsplash.com/photo-1583947215259-38e31be8751f?w=300',
      description: 'Multi-surface cleaner - 750ml',
      descriptionKu: 'پاکەری زۆر ڕووکار - ٧٥٠ میلی لیتر',
    ),
    mainItem(
      brandId: '1',
      id: '45',
      name: 'Laundry Detergent',
      nameKu: 'پاکەری جل',
      category: 'Cleaning Supplies',
      categoryKu: 'کەلوپەلی پاککردنەوە',
      price: 6500,
      imageUrl:
          'https://images.unsplash.com/photo-1582735689369-4fe89db7114c?w=300',
      description: 'Concentrated detergent - 2L',
      descriptionKu: 'پاکەری چڕکراوە - ٢ لیتر',
    ),

    // Personal Care
    mainItem(
      brandId: '1',
      id: '46',
      name: 'Toothpaste',
      nameKu: 'تووتپەیست',
      category: 'Personal Care',
      price: 2200,
      imageUrl:
          'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=300',
      description: 'Fluoride toothpaste - 100ml',
      descriptionKu: 'تووتپەیستی فلۆراید - ١٠٠ میلی لیتر',
    ),
    mainItem(
      brandId: '1',
      id: '47',
      name: 'Shampoo',
      nameKu: 'شامپۆ',
      category: 'Personal Care',
      price: 4500,
      imageUrl:
          'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=300',
      description: 'Moisturizing shampoo - 400ml',
      descriptionKu: 'شامپۆی نەمکەر - ٤٠٠ میلی لیتر',
    ),
    mainItem(
      brandId: '1',
      id: '48',
      name: 'Body Wash',
      nameKu: 'شووشتنی لەش',
      category: 'Personal Care',
      price: 3500,
      imageUrl:
          'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=300',
      description: 'Refreshing body wash - 250ml',
      descriptionKu: 'شووشتنی لەشی فێنکەر - ٢٥٠ میلی لیتر',
    ),

    // Health & Wellness
    mainItem(
      brandId: '1',
      id: '49',
      name: 'Multivitamins',
      nameKu: 'ڤیتامینی زۆرجۆر',
      category: 'Health & Wellness',
      price: 8000,
      imageUrl:
          'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=300',
      description: 'Daily multivitamin - 60 tablets',
      descriptionKu: 'ڤیتامینی زۆرجۆری ڕۆژانە - ٦٠ تابلێت',
    ),
    mainItem(
      brandId: '1',
      id: '50',
      name: 'Protein Powder',
      nameKu: 'تۆزی پرۆتین',
      category: 'Health & Wellness',
      price: 12000,
      imageUrl:
          'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=300',
      description: 'Whey protein powder - 1kg',
      descriptionKu: 'تۆزی پرۆتینی شیر - ١ کیلۆ',
    ),
    mainItem(
      brandId: '1',
      id: '46',
      name: 'Toothpaste',
      nameKu: 'تووتپەیست',
      category: 'Personal Care',
      categoryKu: 'چاودێری کەسی',
      price: 2200,
      imageUrl:
          'https://images.unsplash.com/photo-1556228578-8c89e6adf883?w=300',
      description: 'Fluoride toothpaste - 100ml',
      descriptionKu: 'تووتپەیستی فلۆراید - ١٠٠ میلی لیتر',
    ),
    mainItem(
      brandId: '1',
      id: '47',
      name: 'Shampoo',
      nameKu: 'شامپۆ',
      category: 'Personal Care',
      categoryKu: 'چاودێری کەسی',
      price: 4500,
      imageUrl:
          'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?w=300',
      description: 'Moisturizing shampoo - 400ml',
      descriptionKu: 'شامپۆی نەمکەر - ٤٠٠ میلی لیتر',
    ),
    mainItem(
      brandId: '1',
      id: '48',
      name: 'Body Wash',
      nameKu: 'شووشتنی لەش',
      category: 'Personal Care',
      categoryKu: 'چاودێری کەسی',
      price: 3500,
      imageUrl:
          'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=300',
      description: 'Refreshing body wash - 250ml',
      descriptionKu: 'شووشتنی لەشی فێنکەر - ٢٥٠ میلی لیتر',
    ),

    // Health & Wellness
    mainItem(
      brandId: '1',
      id: '49',
      name: 'Multivitamins',
      nameKu: 'ڤیتامینی زۆرجۆر',
      category: 'Health & Wellness',
      categoryKu: 'تەندروستی و خۆپاراستن',
      price: 8000,
      imageUrl:
          'https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=300',
      description: 'Daily multivitamin - 60 tablets',
      descriptionKu: 'ڤیتامینی زۆرجۆری ڕۆژانە - ٦٠ تابلێت',
    ),
    mainItem(
      brandId: '1',
      id: '50',
      name: 'Protein Powder',
      nameKu: 'تۆزی پرۆتین',
      category: 'Health & Wellness',
      categoryKu: 'تەندروستی و خۆپاراستن',
      price: 12000,
      imageUrl:
          'https://images.unsplash.com/photo-1593095948071-474c5cc2989d?w=300',
      description: 'Whey protein powder - 1kg',
      descriptionKu: 'تۆزی پرۆتینی شیر - ١ کیلۆ',
    ),
    // Additional items for categories that currently have no items

    // Dates
    mainItem(
      brandId: '1',
      id: '51',
      name: 'Medjool Dates',
      nameKu: 'خورمای مەجوول',
      category: 'Dates',
      categoryKu: 'خورما',
      price: 6000,
      imageUrl:
          'https://images.unsplash.com/photo-1577069861033-55d04cec4ef5?w=300',
      description: 'Premium Medjool dates - 500g',
      descriptionKu: 'خورمای مەجوولی فاخیر - ٥٠٠ گرام',
    ),

    mainItem(
      brandId: '1',
      id: '52',
      name: 'Deglet Noor Dates',
      nameKu: 'خورمای دەگلەت نوور',
      category: 'Dates',
      categoryKu: 'خورما',
      price: 4500,
      imageUrl:
          'https://images.unsplash.com/photo-1609501676725-7186f570511a?w=300',
      description: 'Sweet Deglet Noor dates - 400g',
      descriptionKu: 'خورمای شیرینی دەگلەت نوور - ٤٠٠ گرام',
    ),

    mainItem(
      brandId: '1',
      id: '53',
      name: 'Zahidi Dates',
      nameKu: 'خورمای زاهیدی',
      category: 'Dates',
      categoryKu: 'خورما',
      price: 3500,
      imageUrl:
          'https://images.unsplash.com/photo-1609501676725-7186f570511a?w=300',
      description: 'Golden Zahidi dates - 300g',
      descriptionKu: 'خورمای زێڕینی زاهیدی - ٣٠٠ گرام',
    ),

    // Sunflower Oils
    mainItem(
      brandId: '1',
      id: '54',
      name: 'Premium Sunflower Oil',
      nameKu: 'ڕووی گوڵەباخی فاخیر',
      category: 'Sunflower Oils',
      categoryKu: 'ڕۆنی گوڵەباخ',
      price: 8000,
      imageUrl:
          'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300',
      description: 'Cold-pressed sunflower oil - 1L',
      descriptionKu: 'ڕووی گوڵەباخی سارد گوشراو - ١ لیتر',
      adId: '1',
    ),

    mainItem(
      brandId: '1',
      id: '55',
      name: 'Refined Sunflower Oil',
      nameKu: 'ڕووی گوڵەباخی پاککراوە',
      category: 'Sunflower Oils',
      categoryKu: 'ڕۆنی گوڵەباخ',
      price: 6500,
      imageUrl:
          'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300',
      description: 'Refined sunflower cooking oil - 2L',
      descriptionKu: 'ڕووی چێشتلێنانی گوڵەباخی پاککراوە - ٢ لیتر',
    ),

    mainItem(
      brandId: '1',
      id: '56',
      name: 'Organic Sunflower Oil',
      nameKu: 'ڕووی گوڵەباخی ئۆرگانیک',
      category: 'Sunflower Oils',
      categoryKu: 'ڕۆنی گوڵەباخ',
      price: 9500,
      imageUrl:
          'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300',
      description: 'Organic sunflower oil - 750ml',
      descriptionKu: 'ڕووی گوڵەباخی ئۆرگانیک - ٧٥٠ میلی لیتر',
    ),

    // Olive Oils
    mainItem(
      brandId: '1',
      id: '57',
      name: 'Extra Virgin Olive Oil',
      nameKu: 'ڕووی زەیتوونی پاکی زیادە',
      category: 'Olive Oils',
      categoryKu: 'ڕۆنی زەیتوون',
      price: 12000,
      imageUrl:
          'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300',
      description: 'Premium extra virgin olive oil - 500ml',
      descriptionKu: 'ڕووی زەیتوونی پاکی زیادەی فاخیر - ٥٠٠ میلی لیتر',
    ),

    mainItem(
      brandId: '1',
      id: '58',
      name: 'Pure Olive Oil',
      nameKu: 'ڕووی زەیتوونی پاک',
      category: 'Olive Oils',
      categoryKu: 'ڕۆنی زەیتوون',
      price: 8500,
      imageUrl:
          'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300',
      description: 'Pure olive oil for cooking - 1L',
      descriptionKu: 'ڕووی زەیتوونی پاک بۆ چێشتلێنان - ١ لیتر',
    ),

    mainItem(
      brandId: '1',
      id: '59',
      name: 'Light Olive Oil',
      nameKu: 'ڕووی زەیتوونی سووک',
      category: 'Olive Oils',
      categoryKu: 'ڕۆنی زەیتوون',
      price: 7000,
      imageUrl:
          'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=300',
      description: 'Light olive oil - 750ml',
      descriptionKu: 'ڕووی زەیتوونی سووک - ٧٥٠ میلی لیتر',
    ),

    // Tomato Paste
    mainItem(
      brandId: '1',
      id: '60',
      name: 'Zeer Tomato Paste',
      nameKu: 'تۆماتە درۆشی زێر',
      category: 'Tomato Paste',
      categoryKu: 'تۆماتە درۆش',
      price: 3500,
      imageUrl:
          'https://images.unsplash.com/photo-1553395297-2b379c4a3be6?w=300',
      description: 'Zeer brand tomato paste - 800g',
      descriptionKu: 'تۆماتە درۆشی براندی زێر - ٨٠٠ گرام',
    ),

    mainItem(
      brandId: '1',
      id: '61',
      name: 'Premium Tomato Paste',
      nameKu: 'تۆماتە درۆشی فاخیر',
      category: 'Tomato Paste',
      categoryKu: 'تۆماتە درۆش',
      price: 4000,
      imageUrl:
          'https://images.unsplash.com/photo-1553395297-2b379c4a3be6?w=300',
      description: 'Premium concentrated tomato paste - 400g',
      descriptionKu: 'تۆماتە درۆشی چڕکراوەی فاخیر - ٤٠٠ گرام',
    ),

    mainItem(
      brandId: '1',
      id: '62',
      name: 'Organic Tomato Paste',
      nameKu: 'تۆماتە درۆشی ئۆرگانیک',
      category: 'Tomato Paste',
      categoryKu: 'تۆماتە درۆش',
      price: 4500,
      imageUrl:
          'https://images.unsplash.com/photo-1553395297-2b379c4a3be6?w=300',
      description: 'Organic tomato paste - 200g tube',
      descriptionKu: 'تۆماتە درۆشی ئۆرگانیک - تیوبی ٢٠٠ گرام',
    ),

    // Egg Products
    mainItem(
      brandId: '1',
      id: '63',
      name: 'Farm Fresh Eggs',
      nameKu: 'هێلکەی تازەی کێڵگە',
      category: 'Egges Products',
      categoryKu: 'بەرهەمەکانی هێلکە',
      price: 3000,
      imageUrl:
          'https://images.unsplash.com/photo-1518569656558-1f25e69d93d7?w=300',
      description: 'Farm fresh brown eggs - 12 pack',
      descriptionKu: 'هێلکەی قاوەیی تازەی کێڵگە - پاکێتی ١٢ دانە',
    ),

    mainItem(
      brandId: '1',
      id: '64',
      name: 'Organic Free-Range Eggs',
      nameKu: 'هێلکەی ئۆرگانیکی ئازاد',
      category: 'Egges Products',
      categoryKu: 'بەرهەمەکانی هێلکە',
      price: 4000,
      imageUrl:
          'https://images.unsplash.com/photo-1518569656558-1f25e69d93d7?w=300',
      description: 'Organic free-range eggs - 6 pack',
      descriptionKu: 'هێلکەی ئۆرگانیکی ئازاد - پاکێتی ٦ دانە',
    ),

    mainItem(
      brandId: '1',
      id: '65',
      name: 'Quail Eggs',
      nameKu: 'هێلکەی سلیو',
      category: 'Egges Products',
      categoryKu: 'بەرهەمەکانی هێلکە',
      price: 5000,
      imageUrl:
          'https://images.unsplash.com/photo-1518569656558-1f25e69d93d7?w=300',
      description: 'Fresh quail eggs - 20 pack',
      descriptionKu: 'هێلکەی سلیوی تازە - پاکێتی ٢٠ دانە',
    ),

    mainItem(
      brandId: '1',
      id: '66',
      name: 'Liquid Egg Whites',
      nameKu: 'سپێڵەی هێلکەی شل',
      category: 'Egges Products',
      categoryKu: 'بەرهەمەکانی هێلکە',
      price: 3500,
      imageUrl:
          'https://images.unsplash.com/photo-1518569656558-1f25e69d93d7?w=300',
      description: 'Pure liquid egg whites - 500ml',
      descriptionKu: 'سپێڵەی هێلکەی شلی پاک - ٥٠٠ میلی لیتر',
      adId: '1',
    ),
  ];

  // Today's deals - special pricing items
  static final List<mainItem> todaysDeals = [
    mainItem(
      brandId: '1',
      id: 'deal_1',
      name: 'Organic Strawberries',
      nameKu: 'فڕاولەی ئۆرگانیک',
      category: 'Fresh Fruit',
      price: 3000,
      imageUrl:
          'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=300',
      description: 'Sweet organic strawberries - 500g (was \$5.99)',
      descriptionKu: 'فڕاولەی ئۆرگانیک شیرین - ٥٠٠گ (پێشتر \$٥.٩٩ بوو)',
    ),
    mainItem(
      brandId: '1',
      id: 'deal_2',
      name: 'Avocados',
      nameKu: 'ئەڤۆکادۆ',
      category: 'Fresh Fruit',
      price: 4000,
      imageUrl:
          'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=300',
      description: 'Fresh avocados - 3 pack (was \$6.99)',
      descriptionKu: 'ئەڤۆکادۆی تازە - پاکێتی ٣ دانە (پێشتر \$٦.٩٩ بوو)',
    ),
    mainItem(
      brandId: '1',
      id: 'deal_3',
      name: 'Greek Yogurt Combo',
      nameKu: 'کۆمبۆی ماستی یۆنانی',
      category: 'Dairy',
      price: 5000,
      imageUrl:
          'https://images.unsplash.com/photo-1571212515416-ffeec4f162e4?w=300',
      description: 'Greek yogurt variety pack - 4x500g (was \$8.99)',
      descriptionKu:
          'پاکێتی چەشنەکانی ماستی یۆنانی - ٤×٥٠٠گ (پێشتر \$٨.٩٩ بوو)',
    ),
    mainItem(
      brandId: '1',
      id: 'deal_4',
      name: 'Artisan Bread',
      nameKu: 'نانی دەستکرد',
      category: 'Bakery',
      price: 2000,
      imageUrl:
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300',
      description: 'Fresh baked sourdough - 800g (was \$4.99)',
      descriptionKu: 'نانی تریشی تازە کراو - ٨٠٠گ (پێشتر \$٤.٩٩ بوو)',
    ),
    mainItem(
      brandId: '1',
      id: 'deal_5',
      name: 'Premium Coffee',
      nameKu: 'قاوەی پلە یەک',
      category: 'Beverages',
      price: 6000,
      imageUrl:
          'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=300',
      description: 'Single origin coffee beans - 500g (was \$12.99)',
      descriptionKu: 'دانەی قاوەی سەرچاوەی یەکجار - ٥٠٠گ (پێشتر \$١٢.٩٩ بوو)',
    ),
    mainItem(
      brandId: '1',
      id: 'deal_6',
      name: 'Frozen Meal Bundle',
      nameKu: 'کۆمەڵە خواردنی یەخکراو',
      category: 'Frozen Foods',
      price: 8000,
      imageUrl:
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=300',
      description: '3 premium frozen meals (was \$15.99)',
      descriptionKu: '٣ خواردنی یەخکراوی پلە یەک (پێشتر \$١٥.٩٩ بوو)',
    ),
    mainItem(
      brandId: '1',
      id: 'deal1_item1',
      name: 'Organic Apples',
      nameKu: 'سێوی ئۆرگانیک',
      category: 'Fruit & Vegetables',
      price: 2500,
      imageUrl:
          'https://images.unsplash.com/photo-1568702846914-96b305d2aaeb?w=200',
      description: 'Fresh organic apples',
      descriptionKu: 'سێوی ئۆرگانیک تازە',
      hasDiscount: true,
           discountPercentage: 50.0,
     
      dealID: 1,
    ),
    mainItem(
      brandId: '1',
      id: 'deal1_item2',
      name: 'Whole Grain Bread',
      nameKu: 'نانی دانەوێڵەی تەواو',
      category: 'Bakery',
      price: 12000,
      imageUrl:
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=200',
      description: 'Fresh whole grain bread',
      descriptionKu: 'نانی دانەوێڵەی تەواوی تازە',
      hasDiscount: true,
           discountPercentage: 44.0,
     
      dealID: 1,
    ),

    mainItem(
      brandId: '1',
      id: 'deal1_item3',
      name: 'Cleaning Spray',
      nameKu: 'سپرەی پاککردنەوە',
      category: 'Cleaning & Laundry',
      price: 1800,
      imageUrl:
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=200',
      description: 'Multi-purpose cleaning spray',
      descriptionKu: 'سپرەی پاککردنەوەی فرە مەبەست',
      hasDiscount: true,
           discountPercentage: 40.0,
     
      dealID: 1,
    ),

    // Items for "Freez & Kratus" deal (dealID: 2)
    mainItem(
      brandId: '1',
      id: 'deal2_item1',
      name: 'Ice Cream Vanilla',
      nameKu: 'بەستەنی ڤانیلا',
      category: 'Frozen Food',
      price: 3500,
      imageUrl:
          'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=200',
      description: 'Premium vanilla ice cream',
      descriptionKu: 'بەستەنی ڤانیلای پلە یەک',
      hasDiscount: true,
           discountPercentage: 30.0,
     
      dealID: 2,
    ),

    mainItem(
      brandId: '1',
      id: 'deal2_item2',
      name: 'Frozen Beverages Mix',
      nameKu: 'تێکەڵەی خواردنەوەی یەخکراو',
      category: 'Beverages',
      price: 2200,
      imageUrl:
          'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=200',
      description: 'Assorted frozen drink mixes',
      descriptionKu: 'تێکەڵەی جۆراوجۆری خواردنەوەی یەخکراو',
      hasDiscount: true,
           discountPercentage: 25.0,
     
      dealID: 2,
    ),

    mainItem(
      brandId: '1',
      id: 'deal2_item3',
      name: 'Frozen Pizza',
      nameKu: 'پیتزای یەخکراو',
      category: 'Frozen Food',
      price: 2800,
      imageUrl:
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=200',
      description: 'Delicious frozen pizza',
      descriptionKu: 'پیتزای یەخکراوی خۆشتام',
      hasDiscount: true,
           discountPercentage: 35.0,
     
      dealID: 2,
    ),
  ];

  static List<Deal> deals = [
    Deal(
      id: 1,
      title: "Up to 50%",
      titleKu: "تا ٥٠٪",
      description: "Get up to 50% discount with this deal",
      descriptionKu: "بە ئەم دیلەوە تا ٥٠٪ داشکاندن وەربگرە",
      imageUrl: 'https://i.ibb.co/PGDt7jvN/1.png',
      bannerUrl:
          'https://images.unsplash.com/photo-1607082349566-187342175e2f?w=600',
    ),
    Deal(
      id: 2,
      title: "Sunflower Savers",
      titleKu: "داشکاندن زەیت",
      description: "Get up to 50% discount with this deal",
      descriptionKu: "بە ئەم دیلەوە تا ٥٠٪ داشکاندن وەربگرە",
      imageUrl: 'https://i.ibb.co/kVR573QC/2.png',
      bannerUrl: '',
    ),
    Deal(
      id: 3,
      title: "Frozen Finds",
      titleKu: "دۆزینەوەی قەشاکراو",
      description: "Get up to 50% discount with this deal",
      descriptionKu: "بە ئەم دیلەوە تا ٥٠٪ داشکاندن وەربگرە",
      imageUrl: 'https://i.ibb.co/DfVhBXF1/3.png',
      bannerUrl:
          'https://images.unsplash.com/photo-1607082349566-187342175e2f?w=600',
    ),
    Deal(
      id: 4,
      title: "Snaks",
      titleKu: "خواردنی سووک",
      description: "Get up to 50% discount with this deal",
      descriptionKu: "بە ئەم دیلەوە تا ٥٠٪ داشکاندن وەربگرە",
      imageUrl: 'https://i.ibb.co/vvT72kmr/4.png',
      bannerUrl:
          'https://images.unsplash.com/photo-1607082349566-187342175e2f?w=600',
    ),

    Deal(
      id: 5,
      title: "Bueaty Basket",
      titleKu: "سەبەتەی جوانی",
      description: "Get up to 50% discount with this deal",
      descriptionKu: "بە ئەم دیلەوە تا ٥٠٪ داشکاندن وەربگرە",
      imageUrl: 'https://i.ibb.co/8np8LXrx/7.png',
      bannerUrl:
          'https://images.unsplash.com/photo-1607082349566-187342175e2f?w=600',
    ),
    Deal(
      id: 6,
      title: "Bakery Blast",
      titleKu: "تەقینەوەی نانەواخانە",
      description: "Get up to 50% discount with this deal",
      descriptionKu: "بە ئەم دیلەوە تا ٥٠٪ داشکاندن وەربگرە",
      imageUrl: 'https://i.ibb.co/fdBtwWsX/8.png',
      bannerUrl:
          'https://images.unsplash.com/photo-1607082349566-187342175e2f?w=600',
    ),
    Deal(
      id: 7,
      title: "Baby Basics",
      titleKu: "بنەڕەتییەکانی منداڵ",
      description: "Get up to 50% discount with this deal",
      descriptionKu: "بە ئەم دیلەوە تا ٥٠٪ داشکاندن وەربگرە",
      imageUrl: 'https://i.ibb.co/xS6vH1GR/5.png',
      bannerUrl:
          'https://images.unsplash.com/photo-1607082349566-187342175e2f?w=600',
    ),
  ];
}
