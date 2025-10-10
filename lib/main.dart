import 'package:flutter/material.dart';
import 'models/car.dart';
import 'services/pocketbase_service.dart';
import 'utils/fake_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Faker App',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: CarListPage(),
    );
  }
}

class CarListPage extends StatefulWidget {
  @override
  State<CarListPage> createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  final service = PocketBaseService();
  List<Car> cars = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadCars();
  }

  Future<void> loadCars() async {
    final data = await service.getCars();
    setState(() {
      cars = data;
      loading = false;
    });
  }

  Future<void> addFakeCar() async {
    final fakeCar = generateFakeCars(1).first;
    await service.addCar(fakeCar);
    loadCars();
  }

  Future<void> editCar(Car car) async {
    TextEditingController brandCtrl = TextEditingController(text: car.brand);
    TextEditingController modelCtrl = TextEditingController(text: car.model);
    TextEditingController yearCtrl = TextEditingController(text: car.year.toString());

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Car'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: brandCtrl, decoration: InputDecoration(labelText: 'Brand')),
            TextField(controller: modelCtrl, decoration: InputDecoration(labelText: 'Model')),
            TextField(controller: yearCtrl, decoration: InputDecoration(labelText: 'Year')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await service.updateCar(
                car.id,
                Car(
                  id: car.id,
                  brand: brandCtrl.text,
                  model: modelCtrl.text,
                  year: int.parse(yearCtrl.text),
                ),
              );
              Navigator.pop(context);
              loadCars();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Car List')),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cars.length,
              itemBuilder: (_, i) {
                final car = cars[i];
                return ListTile(
                  title: Text('${car.brand} ${car.model}'),
                  subtitle: Text('Year: ${car.year}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => editCar(car),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await service.deleteCar(car.id);
                          loadCars();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: addFakeCar,
        child: Icon(Icons.add),
      ),
    );
  }
}
