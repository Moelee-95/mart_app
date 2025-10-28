
import 'package:grocery_stores/models/store.dart';

class MainStoresData {
  static final List<Store> stores = [
    Store(
        id: '1',
        name: 'Family Market Downtown',
        nameKu: 'بازاڕی خێزانی ناوەڕاست',
        address: '123 Main St, City Center',
        addressKu: '١٢٣ شەقامی سەرەکی، ناوەندی شار',
        imageUrl: 'https://picsum.photos/id/1/200/200',
      ),
      Store(
        id: '2',
        name: 'Fresh Foods Mall',
        nameKu: 'پازاڕی خواردنە تازەکان',
        address: '456 Shopping Ave, Mall District',
        addressKu: '٤٥٦ شەقامی بازاڕ، ناوچەی مۆڵ',
        imageUrl: 'https://picsum.photos/id/2/200/200',
      ),
      Store(
        id: '3',
        name: 'Green Valley Supermarket',
        nameKu: 'سوپەرمارکێتی دۆڵی سەوز',
        address: '789 Valley Rd, Green District',
        addressKu: '٧٨٩ ڕێگای دۆڵ، ناوچەی سەوز',
        imageUrl: 'https://picsum.photos/id/3/200/200',
      ),
  ];
}