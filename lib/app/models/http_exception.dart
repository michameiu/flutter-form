

enum HttpMethod{
  GET,
  POST,
  PUT,
  PATCH,
}
extension MyEnumEx on HttpMethod {
  String toText() =>
      toString().split('.')[1].replaceAll('_', ' ');
}

class HttpException implements Exception {
  final String message;
  final int statusCode;
  HttpException(this.statusCode, this.message);

  @override
  String toString() {
    // TODO: implement toString
    return 'Code:$statusCode Message:$message';
  }

}