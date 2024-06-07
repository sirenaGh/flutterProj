import 'package:dio/dio.dart';
import 'package:weather_app/feature/home/model/city_model.dart';
import 'package:weather_app/feature/home/model/weather_model.dart';

// الزا قصي عوزران
abstract class IHomeService {
  final Dio dio;
  IHomeService(this.dio);
// get Weather Condition
  Future<WeatherModel?> fetchWeatherByCityName(String? lat, String? lon);
  Future<String?> getCityNameByCurrentLocation();
// get City List
  Future<List<CityModel>?> fetchCityItems();
}
