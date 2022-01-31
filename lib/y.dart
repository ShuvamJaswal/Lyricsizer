// import 'package:dio/dio.dart';

// final _dio = Dio();
// CancelToken abc = CancelToken();
// Future<void> makeSearchQuery(String searchTerm) async {
//   abc.cancel();
//   abc = CancelToken();
//   return _dio.get(searchTerm, cancelToken: abc).then((value) {
//     print(value);
//   }).catchError((e) {
//     if (CancelToken.isCancel(e)) {}
//   });
// }

// or new Dio with a BaseOptions instance.
import 'package:dio/dio.dart';

var options = BaseOptions(
  baseUrl: 'https://www.xx.com/api',
  connectTimeout: 5000,
  receiveTimeout: 3000,
);
Dio dio = Dio(BaseOptions(
  baseUrl: 'https://www.xx.com/api',
));
void main() async {
  //print(dio.options.baseUrl);
//   makeSearchQuery("https://reqres.in/api/products/3");

//   //makeSearchQuery("https://reqres.in/api/products/3");
}
