import '../models/user.dart';
import '../service/api/api_services.dart';
import '../services/user_service.dart';

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

  // Check this here, either try-catch in service or here in case of failure to fetch
  Future<UserModel> getDriverWithId(String id) async {
    UserModel? user = await UserService().getUserById(id);
    return user!;
  }
}
