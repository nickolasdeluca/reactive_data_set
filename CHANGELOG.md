# Changelog

## 0.0.3

* Added new query methods for safe data access:
  * `getByIndex(int index)` - Returns item at specified index or null if out of bounds
  * `getWhere(bool Function(T) predicate)` - Returns all items matching the given predicate
  * `getFirstWhere(bool Function(T) predicate)` - Returns first item matching predicate or null if none found
* Updated README with usage examples for new query methods
* Added comprehensive test coverage for new methods

## 0.0.2

* Added example

## 0.0.1

* Initial release of `reactive_data_set`.
* Supports in-memory storage of generic data.
* Built-in sorting, filtering, insert, update, delete.
* Integrated `ValueNotifier` for reactive Flutter UI support.
