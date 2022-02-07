import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lyricsizer/models/search_result_model.dart';

enum requestState { empty, isFetching, done, error, noResult }

class SearchProvider with ChangeNotifier {
  var status = requestState.empty;

  var reqToken = CancelToken();
  final _dio = Dio(BaseOptions(
    baseUrl: 'https://genius.com/api/search',
  ));
  List<SearchResultModel> _searchResults = [];
  List get results => _searchResults;
  Future<void> makeSearchQuery(String searchTerm) async {
    status = requestState.empty;

    reqToken.cancel();
    notifyListeners();
    reqToken = CancelToken();
    _searchResults = [];
    if (searchTerm.isEmpty) {
      status = requestState.empty;
      notifyListeners();
    } else {
      status = requestState.isFetching;
      notifyListeners();
      return await _dio
          .get('/song',
              queryParameters: {'q': searchTerm.trim()}, cancelToken: reqToken)
          .then((value) {
        _searchResults.addAll(value.data['response']['sections'][0]['hits']
            .map<SearchResultModel>(
                (a) => SearchResultModel.fromJSON(a as Map<String, dynamic>))
            .toList());
      }).then((value) {
        if (_searchResults.isEmpty) {
          status = requestState.noResult;
        } else {
          status = requestState.done;
        }
        notifyListeners();
      }).catchError((e) {
        try {
          if (CancelToken.isCancel(e)) {
            if (searchTerm.isEmpty) {
              //to show empty condition if we have empty textfield after cancelling.
              status = requestState.empty;
              notifyListeners();
            }
            // status = requestState.isFetching;
            // notifyListeners();
          } else {
            status = requestState.error;
            notifyListeners();
          }
        } catch (e) {
          //catching error other than dio error
          status = requestState.error;
          notifyListeners();
        }
      });
    }
  }
}
