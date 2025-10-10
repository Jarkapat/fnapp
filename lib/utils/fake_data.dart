import 'package:faker/faker.dart';
import '../models/car.dart';

List<Car> generateFakeCars(int count) {
  var faker = Faker();
  return List.generate(count, (i) {
    return Car(
      id: '',
      brand: faker.vehicle.make(),
      model: faker.vehicle.model(),
      year: faker.date.dateTimeBetween(DateTime(2000), DateTime(2025)).year,
    );
  });
}
