import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TokenController extends GetxController {
  static TokenController get to => Get.find();

  final _token = ''.obs;

  String get token => _token.value;

  @override
  void onInit() {
    // Retrieve token from storage on initialization
    _token.value = GetStorage().read('token') ?? '';
    super.onInit();
  }

  // Method to set and save the token
  void setToken(String token) {
    _token.value = token;
    GetStorage().write('token', token);
  }

  // Method to clear the token
  void clearToken() {
    _token.value = '';
    GetStorage().remove('token');
  }
}
