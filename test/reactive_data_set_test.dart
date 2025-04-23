import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_data_set/reactive_data_set.dart';

class Person {
  String name;
  int age;

  Person(this.name, this.age);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Person &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          age == other.age;

  @override
  int get hashCode => name.hashCode ^ age.hashCode;

  @override
  String toString() => 'Person(name: $name, age: $age)';
}

void main() {
  group('ReactiveDataSet', () {
    late ReactiveDataSet<Person> dataSet;

    setUp(() {
      dataSet = ReactiveDataSet<Person>([
        Person('Alice', 30),
        Person('Bob', 25),
        Person('Charlie', 35),
      ]);
    });

    test('initializes correctly', () {
      expect(dataSet.data.length, 3);
    });

    test('inserts new item', () {
      dataSet.insert(Person('Diana', 28));
      expect(dataSet.data.length, 4);
      expect(dataSet.data.last.name, 'Diana');
    });

    test('deletes an item', () {
      dataSet.delete(1);
      expect(dataSet.data.length, 2);
      expect(dataSet.data.any((p) => p.name == 'Bob'), false);
    });

    test('updates an item', () {
      dataSet.update(0, Person('Alice', 31));
      expect(dataSet.data[0].age, 31);
    });

    test('sorts ascending by age', () {
      dataSet.sort((p) => p.age);
      expect(dataSet.data.first.name, 'Bob');
    });

    test('filters by age > 30', () {
      dataSet.filter((p) => p.age > 30);
      expect(dataSet.data.length, 1);
      expect(dataSet.data.first.name, 'Charlie');
    });

    test('reset restores original data', () {
      dataSet.filter((p) => p.age > 30);
      dataSet.reset();
      expect(dataSet.data.length, 3);
    });
  });
}
