/// #[flatten] *Example*
/// [ref link]: https://google.com
/// ```dart
///  var a = [[1, 2, 3], ['a', 'b', 'c'], [true, false, true]];
///  var b = flatten(a);
///  print(b); // Prints: [1, 2, 3, a, b, c, true, false, true]
/// ```
/// ```html
/// <h1>HTML is magical!</h1>
/// ```

List<T> flatten<T>(Iterable<Iterable<T>> list) =>
    [for (var sublist in list) ...sublist];

///[flattenDeep] Example
/// var a = [[1, [[2], 3]], [[['a']], 'b', 'c'], [true, false, [true]]];
/// var b = flattenDeep(a);
/// print(b) // Prints: [1, 2, 3, a, b, c, true, false, true]

List<T> flattenDeep<T>(Iterable<dynamic> list) => [
  for (var element in list)
    if (element is! Iterable) element else ...flattenDeep(element),
];