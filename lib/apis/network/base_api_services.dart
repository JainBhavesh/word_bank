abstract class BaseApiServices {
  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  Future<dynamic> getApi(String, url);
  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
  Future<dynamic> postApi(dynamic data, String, url);
}
