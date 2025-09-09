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

    group('getByIndex', () {
      test('returns item at valid index', () {
        final person = dataSet.getByIndex(0);
        expect(person, isNotNull);
        expect(person!.name, 'Alice');
        expect(person.age, 30);
      });

      test('returns item at last valid index', () {
        final person = dataSet.getByIndex(2);
        expect(person, isNotNull);
        expect(person!.name, 'Charlie');
        expect(person.age, 35);
      });

      test('returns null for negative index', () {
        final person = dataSet.getByIndex(-1);
        expect(person, isNull);
      });

      test('returns null for index out of bounds', () {
        final person = dataSet.getByIndex(10);
        expect(person, isNull);
      });

      test('returns null for index equal to length', () {
        final person = dataSet.getByIndex(3);
        expect(person, isNull);
      });

      test('works with empty dataset', () {
        final emptyDataSet = ReactiveDataSet<Person>([]);
        final person = emptyDataSet.getByIndex(0);
        expect(person, isNull);
      });
    });

    group('getWhere', () {
      test('returns matching items', () {
        final result = dataSet.getWhere((p) => p.age >= 30);
        expect(result.length, 2);
        expect(result.any((p) => p.name == 'Alice'), true);
        expect(result.any((p) => p.name == 'Charlie'), true);
        expect(result.any((p) => p.name == 'Bob'), false);
      });

      test('returns single matching item', () {
        final result = dataSet.getWhere((p) => p.name == 'Bob');
        expect(result.length, 1);
        expect(result.first.name, 'Bob');
        expect(result.first.age, 25);
      });

      test('returns empty list when no matches', () {
        final result = dataSet.getWhere((p) => p.age > 100);
        expect(result, isEmpty);
      });

      test('returns all items when all match', () {
        final result = dataSet.getWhere((p) => p.age > 0);
        expect(result.length, 3);
      });

      test('works with empty dataset', () {
        final emptyDataSet = ReactiveDataSet<Person>([]);
        final result = emptyDataSet.getWhere((p) => true);
        expect(result, isEmpty);
      });

      test('works with filtered dataset', () {
        dataSet.filter((p) => p.age >= 30);
        final result = dataSet.getWhere((p) => p.age == 35);
        expect(result.length, 1);
        expect(result.first.name, 'Charlie');
      });
    });

    group('getFirstWhere', () {
      test('returns first matching item', () {
        final person = dataSet.getFirstWhere((p) => p.age >= 30);
        expect(person, isNotNull);
        expect(person!.name, 'Alice');
        expect(person.age, 30);
      });

      test('returns specific matching item', () {
        final person = dataSet.getFirstWhere((p) => p.name == 'Bob');
        expect(person, isNotNull);
        expect(person!.name, 'Bob');
        expect(person.age, 25);
      });

      test('returns null when no match found', () {
        final person = dataSet.getFirstWhere((p) => p.age > 100);
        expect(person, isNull);
      });

      test('returns first item when multiple matches exist', () {
        // Add another person with age >= 30 to test it returns the first one
        dataSet.insert(Person('Eve', 32));
        final person = dataSet.getFirstWhere((p) => p.age >= 30);
        expect(person, isNotNull);
        expect(
          person!.name,
          'Alice',
        ); // Should be Alice (first in original order)
      });

      test('works with empty dataset', () {
        final emptyDataSet = ReactiveDataSet<Person>([]);
        final person = emptyDataSet.getFirstWhere((p) => true);
        expect(person, isNull);
      });

      test('works with filtered dataset', () {
        dataSet.filter((p) => p.age >= 30);
        final person = dataSet.getFirstWhere((p) => p.age == 35);
        expect(person, isNotNull);
        expect(person!.name, 'Charlie');
      });

      test('works with sorted dataset', () {
        dataSet.sort(
          (p) => p.age,
        ); // Sort by age ascending: Bob(25), Alice(30), Charlie(35)
        final person = dataSet.getFirstWhere((p) => p.age >= 30);
        expect(person, isNotNull);
        expect(
          person!.name,
          'Alice',
        ); // Alice should be first among those >= 30
      });
    });
  });
}
