import 'package:pocketbase/pocketbase.dart';
import '../models/car.dart';

class PocketBaseService {
  final pb = PocketBase('http://127.0.0.1:8090'); // เปลี่ยนตาม IP ของคุณ

  Future<List<Car>> getCars() async {
    final records = await pb.collection('cars').getFullList();
    return records.map((r) => Car.fromJson(r.toJson())).toList();
  }

  Future<void> addCar(Car car) async {
    await pb.collection('cars').create(body: car.toJson());
  }

  Future<void> updateCar(String id, Car car) async {
    await pb.collection('cars').update(id, body: car.toJson());
  }

  Future<void> deleteCar(String id) async {
    await pb.collection('cars').delete(id);
  }
}
