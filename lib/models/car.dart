class Car {
  String id;
  String brand;
  String model;
  int year;

  Car({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "brand": brand,
      "model": model,
      "year": year,
    };
  }
}
