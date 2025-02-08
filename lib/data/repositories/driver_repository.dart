import '../service/api/api_services.dart';

class DriverRepository {
  DriverRepository._instantiate();
  static final DriverRepository instance = DriverRepository._instantiate();

  Future<dynamic> getDriverTrips() async {
    var data = await ApiServices.instance.getDriverRides();
    return data;
  }

  Future<dynamic> getDriverDeliveries() async {
    var data = await ApiServices.instance.getDriverDeliveries();
    return data;
  }

  Future<dynamic> getDrivers() async {
    var data = await ApiServices.instance.getDrivers();
    return data;
  }
}
