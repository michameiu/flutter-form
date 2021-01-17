import 'dart:async';
import 'dart:convert';

import '../providers/auth.dart';
import 'package:http/http.dart' as http;

class InfiniteScrollModel<T> {
  final Function parseItemsFunction;
  final String url;
  final Auth auth;
  final pageSize;
  int _page = 1;
  Stream<List<T>> stream;
  bool hasMore;
  StreamController<List<dynamic>> _controller;
  bool _isLoading;
  List<dynamic> _data;

  InfiniteScrollModel(
      {this.parseItemsFunction, this.url, this.auth, this.pageSize}) {
    _data = List<dynamic>();
    _controller = StreamController<List<T>>.broadcast();
    _isLoading = false;
    stream = _controller.stream;
    hasMore = true;
    refresh();
  }

  Future<void> refresh() {
    return loadMore(clearCachedData: true);
  }

  Future<void> addData( List<dynamic> data){
    _controller.add(parseItemsFunction(_data));
  }


  Future<void> loadMore({bool clearCachedData = false}) {
    print("Getting the ");
    if (clearCachedData) {
      _page = 1;
      _data = List<dynamic>();
      hasMore = true;
    }
    if (_isLoading || !hasMore) {
      return Future.value();
    }

    _isLoading = true;
    var theurl = "${auth.baseApiUrl}/$url?page=$_page&page_size=$pageSize";
    print(theurl);
    return http.get(theurl, headers: auth.headers).then((res) {
      _isLoading = false;
      print(res.statusCode);
      if (res.statusCode != 200) {
        return;
      }
      var body = json.decode(res.body);
      _data.addAll(body["results"]);
      hasMore = body["next"] != null;
      _page += 1;
      print("Got here page $_page");
      print(_data.length);
      _controller.add(parseItemsFunction(_data));
    });
  }
}
