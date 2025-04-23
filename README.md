# reactive_data_set

A simple yet powerful in-memory data manager for Flutter, inspired by Delphi's `TDataSet`.

`ReactiveDataSet<T>` provides a reactive, mutable, and easily sortable/filterable list structure that integrates seamlessly with native Flutter widgets like `ValueListenableBuilder`. It’s built to support common data manipulation use-cases in a clean and reusable way.

---

## ✨ Features

- ✅ Generic, type-safe data holder (`ReactiveDataSet<T>`)
- 🔄 Reactive UI updates using `ValueNotifier<List<T>>`
- 🧹 Non-destructive filtering and sorting
- ➕ Insert, ✏️ update, ❌ delete, 🔁 reset, 🧽 clear operations
- 🔒 Maintains original data intact while presenting filtered/sorted views
- 🧩 Native Flutter-only (no external state management required)

---

## 🧠 Delphi `TDataSet` Inspiration

This package takes inspiration from Delphi's classic `TDataSet` component.

> 💡 Unlike `TDataSet`, which was database-bound, `ReactiveDataSet` is purely in-memory and UI-friendly, perfect for modern reactive UIs. It embraces the spirit of data-awareness while staying lightweight and native.

---

## 🚀 Getting Started

### 1. Add the package

```bash
flutter pub add reactive_data_set
```

---

### 2. Define your data model

```dart
class Person {
  final String name;
  final int age;

  Person(this.name, this.age);
}
```

---

### 3. Create and use the data set

```dart
final dataSet = ReactiveDataSet<Person>([
  Person('Alice', 30),
  Person('Bob', 25),
]);
```

---

### 4. Bind to the UI

```dart
ValueListenableBuilder<List<Person>>(
  valueListenable: dataSet.dataListenable,
  builder: (context, people, _) {
    return ListView.builder(
      itemCount: people.length,
      itemBuilder: (_, index) => Text(people[index].name),
    );
  },
);
```

---

## ⚙️ API Overview

```dart
ReactiveDataSet<T>(
  [List<T>? initialData]
)

// Mutations
void insert(T item)
void delete(int index)
void update(int index, T updatedItem)

// Sorting & Filtering
void sort(Comparable Function(T) selector, {bool ascending = true})
void filter(bool Function(T) predicate)
void reset()
void clear()

// Access
List<T> get data
ValueNotifier<List<T>> get dataListenable
```

---

## 🛣️ Roadmap (Future Ideas)

- ⏪ Undo/Redo stack for revertible operations
- 📦 Batched updates/transactions
- 🔍 Pagination and search helpers
- 🔗 Nested dataset support (parent/child relationships)
- 🧾 JSON serialization helpers

---

## 🛠 Contributing

Feel free to open issues or pull requests for bugs, improvements, or new features. The goal is to keep it simple, fast, and native.

Built with ❤️ by a former Delphi developer for modern Flutter apps.

---

## 📄 License

MIT License. Use it freely in personal and commercial projects.
