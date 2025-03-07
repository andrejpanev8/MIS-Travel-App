import 'interface/HasFilterProperties.dart';

class FilterService {
  FilterService._internal();
  static final FilterService instance = FilterService._internal();
  factory FilterService() => instance;

  List<T> filterByStartCity<T extends HasFilterProperties>(
      List<T> items, String startCity) {
    return items
        .where((item) =>
            item.startCity.toLowerCase().contains(startCity.toLowerCase()))
        .toList();
  }

  List<T> filterByEndCity<T extends HasFilterProperties>(
      List<T> items, String endCity) {
    return items
        .where((item) =>
            item.endCity.toLowerCase().contains(endCity.toLowerCase()))
        .toList();
  }

  List<T> filterByStartTime<T extends HasFilterProperties>(
      List<T> items, DateTime startTime) {
    return items.where((item) => item.startTime.isAfter(startTime)).toList();
  }
}
