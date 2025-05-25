class ApiEndPoints {
  // static final String baseUrlApiLocal = 'http://localhost:8080/';
  // static final String baseUrlGreedy = "http://localhost:5000/greedy_knapsack";

  static final String baseUrlApiLocal = 'http://192.168.0.101:8080/';
  static final String baseUrlGreedy = "http://192.168.0.101:5000/";

  static _AuthEndPoints authEndPoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String getBarang = 'barang';
  final String getBarangById = 'barang/';
  final String createBarang = 'barang';
  final String updateBarang = 'barang/';
  final String deleteBarang = 'barang/';

  final String kanpsack01 = 'greedy_knapsack';
  final String kanpsackFractional = 'fractional_knapsack';
}
