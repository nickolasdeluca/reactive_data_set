import 'package:flutter/material.dart';
import 'package:reactive_data_set/reactive_data_set.dart';

void main() {
  runApp(const MyApp());
}

class Person {
  final String name;
  final int age;

  Person(this.name, this.age);

  Person copyWith({String? name, int? age}) {
    return Person(name ?? this.name, age ?? this.age);
  }

  @override
  String toString() => 'Person(name: $name, age: $age)';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReactiveDataSet Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PersonListScreen(),
    );
  }
}

class PersonListScreen extends StatefulWidget {
  const PersonListScreen({super.key});

  @override
  State<PersonListScreen> createState() => _PersonListScreenState();
}

class _PersonListScreenState extends State<PersonListScreen> {
  final ReactiveDataSet<Person> dataSet = ReactiveDataSet([
    Person('Alice', 30),
    Person('Bob', 25),
    Person('Charlie', 35),
  ]);

  void _toggleAge(int index) {
    final person = dataSet.data[index];
    final updated = person.copyWith(age: person.age + 1);
    dataSet.update(index, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ReactiveDataSet Example')),
      body: ValueListenableBuilder<List<Person>>(
        valueListenable: dataSet.dataListenable,
        builder: (context, people, _) {
          return ListView.builder(
            itemCount: people.length,
            itemBuilder: (context, index) {
              final person = people[index];
              return ListTile(
                title: Text(person.name),
                subtitle: Text('Age: ${person.age}'),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _toggleAge(index),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => dataSet.insert(Person('New Person', 20)),
        child: const Icon(Icons.add),
      ),
    );
  }
}
