import 'package:flutter/foundation.dart';

/// A reactive, in-memory dataset manager for Flutter applications.
///
/// Inspired by Delphi's TDataSet, this class allows manipulation of
/// in-memory data with support for operations like sorting, filtering,
/// inserting, updating, and deleting, while maintaining the original data.
///
/// The class provides a [ValueNotifier] interface for the working data,
/// making it easy to bind to Flutter widgets like [ValueListenableBuilder].
class ReactiveDataSet<T> extends ChangeNotifier {
  final List<T> _originalData = [];
  List<T> _workingData = [];

  /// Exposes the current working data as a [ValueNotifier] for UI binding.
  final ValueNotifier<List<T>> dataListenable = ValueNotifier([]);

  /// Creates a new [ReactiveDataSet] with optional initial data.
  ReactiveDataSet([List<T>? initialData]) {
    if (initialData != null) {
      _originalData.addAll(initialData);
      _workingData = List<T>.from(_originalData);
      _notify();
    }
  }

  /// Returns an unmodifiable view of the current working data.
  List<T> get data => List.unmodifiable(_workingData);

  /// Retrieves the item at the specified [index] from the working data.
  /// Returns null if the index is out of bounds.
  T? getByIndex(int index) {
    if (index < 0 || index >= _workingData.length) return null;
    return _workingData[index];
  }

  /// Retrieves all items from the working data that satisfy the given [predicate].
  /// Returns an empty list if no items match the condition.
  List<T> getWhere(bool Function(T item) predicate) {
    return _workingData.where(predicate).toList();
  }

  /// Retrieves the first item from the working data that satisfies the given [predicate].
  /// Returns null if no item matches the condition.
  T? getFirstWhere(bool Function(T item) predicate) {
    try {
      return _workingData.firstWhere(predicate);
    } catch (e) {
      return null;
    }
  }

  /// Adds a new item to both the original and working datasets.
  void insert(T item) {
    _originalData.add(item);
    _workingData.add(item);
    _notify();
  }

  /// Removes the item at [index] from both the original and working datasets.
  void delete(int index) {
    if (index < 0 || index >= _workingData.length) return;
    final item = _workingData[index];
    _originalData.remove(item);
    _workingData.removeAt(index);
    _notify();
  }

  /// Updates the item at [index] in both the working and original datasets.
  void update(int index, T updatedItem) {
    if (index < 0 || index >= _workingData.length) return;
    final originalIndex = _originalData.indexOf(_workingData[index]);
    if (originalIndex != -1) {
      _originalData[originalIndex] = updatedItem;
    }
    _workingData[index] = updatedItem;
    _notify();
  }

  /// Sorts the working dataset by the value returned from [keySelector].
  /// Set [ascending] to `false` to sort in descending order.
  void sort(Comparable Function(T item) keySelector, {bool ascending = true}) {
    _workingData.sort((a, b) {
      final aKey = keySelector(a);
      final bKey = keySelector(b);
      return ascending ? aKey.compareTo(bKey) : bKey.compareTo(aKey);
    });
    _notify();
  }

  /// Filters the working dataset to include only items that satisfy [predicate].
  void filter(bool Function(T item) predicate) {
    _workingData = _originalData.where(predicate).toList();
    _notify();
  }

  /// Resets the working dataset to match the original dataset.
  void reset() {
    _workingData = List<T>.from(_originalData);
    _notify();
  }

  /// Clears both the original and working datasets.
  void clear() {
    _originalData.clear();
    _workingData.clear();
    _notify();
  }

  /// Notifies listeners of changes and updates [dataListenable].
  void _notify() {
    dataListenable.value = List.unmodifiable(_workingData);
    notifyListeners();
  }
}
