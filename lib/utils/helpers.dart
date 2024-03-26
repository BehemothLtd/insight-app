Map<String, List<String>> convertToSafeMap(Map<String, dynamic> originalMap) {
  Map<String, List<String>> safeMap = {};

  for (var entry in originalMap.entries) {
    if (entry.value is List<dynamic>) {
      // Ensure all items in the list are Strings.
      List<String>? stringList = _convertToListOfString(entry.value);
      if (stringList != null) {
        safeMap[entry.key] = stringList;
      } else {
        // Handle the case where the value could not be converted.
        // You might want to throw an exception, log an error, or simply skip the entry.
        print(
            'Warning: The key "${entry.key}" was skipped because the value is not a List<String>.');
      }
    } else {
      // Handle the case where the value is not a List.
      print(
          'Warning: The key "${entry.key}" was skipped because the value is not a List.');
    }
  }

  return safeMap;
}

List<String>? _convertToListOfString(dynamic value) {
  if (value is! List) return null;
  if (value.every((item) => item is String)) {
    return value.cast<String>();
  }
  return null;
}
