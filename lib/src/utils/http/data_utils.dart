import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tlm/src/screens/homescreen/model/res_book_listing.dart';
import 'package:tlm/src/screens/login/model/req_login.dart';
import 'package:tlm/src/screens/login/model/res_login.dart';
import 'package:tlm/src/screens/login/model/version_model.dart';
import 'package:tlm/src/utils/http/api_constant.dart';

import 'http_utils.dart';
import 'res_base_model.dart';

DataUtils dataUtils = DataUtils();

//All api calling base.
class DataUtils {
  static final DataUtils _singleton = DataUtils._internal();

  factory DataUtils() => _singleton;

  static const httpStatusCodeSuccess200 = 200;
  static const httpStatusCodeSuccess201 = 201;
  static const httpStatusCodeSuccess202 = 202;
  static const httpStatusCodeAlreadyExist409 = 409;
  static const httpStatusCodePreConditionRequired = 428;
  static String membershipCharges = "20";

  DataUtils._internal();

  bool isSuccess(int statusCode) {
    return (statusCode == httpStatusCodeSuccess200 ||
            statusCode == httpStatusCodeSuccess201 ||
            statusCode == httpStatusCodeSuccess202)
        ? true
        : false;
  }


  Future<ResLogin> login(
      ReqLogin reLogin, BuildContext context) async {
    var data = await reLogin.toJson();
    Response response = await httpUtils.post(ApiConstant.login,
        data: data,
        context: context,
        isAddLoading: true);
    return ResLogin.fromJson(response.data);
  }

  Future<ResBookListing> getBookListing(
      BuildContext context) async {
    Response response = await httpUtils.get(ApiConstant.bookListing, context: context,isAddLoading: false);
    return ResBookListing.fromJson(response.data);
  }

  Future<Version> version(
      BuildContext context) async {
    Response response = await httpUtils.get(ApiConstant.version, context: context,isAddLoading: false);
    return Version.fromJson(response.data);
  }
}
