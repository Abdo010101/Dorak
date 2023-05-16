import 'package:dio/dio.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:dorakpattient/data/repository/home_repo.dart';
import 'package:flutter/cupertino.dart';
import '../../data/models/response/response.dart';

class MainScreenController extends ChangeNotifier {
  final _homeRepository = locator<HomeRepository>();
  bool isLoading = false;
  HomeResponse? homeData;
  int index = 0;

  void onBottomSheetChanged() {}
}
