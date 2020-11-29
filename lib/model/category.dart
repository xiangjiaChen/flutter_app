import 'dart:convert' show json;

T asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class CategoryModel {
  CategoryModel({
    String code,
    String message,
    List<Data> data,
  })  : _code = code,
        _message = message,
        _data = data;
  factory CategoryModel.fromJson(Map<String, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }
    final List<Data> data = jsonRes['data'] is List ? <Data>[] : null;
    if (data != null) {
      for (final dynamic item in jsonRes['data']) {
        if (item != null) {
          data.add(Data.fromJson(asT<Map<String, dynamic>>(item)));
        }
      }
    }

    return CategoryModel(
      code: asT<String>(jsonRes['code']),
      message: asT<String>(jsonRes['message']),
      data: data,
    );
  }

  String _code;
  String get code => _code;
  String _message;
  String get message => _message;
  List<Data> _data;
  List<Data> get data => _data;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': _code,
        'message': _message,
        'data': _data,
      };

  @override
  String toString() {
    return json.encode(this);
  }
}

class Data {
  Data({
    String mallCategoryId,
    String mallCategoryName,
    List<BxMallSubDto> bxMallSubDto,
    Object comments,
    String image,
  })  : _mallCategoryId = mallCategoryId,
        _mallCategoryName = mallCategoryName,
        _bxMallSubDto = bxMallSubDto,
        _comments = comments,
        _image = image;
  factory Data.fromJson(Map<String, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }
    final List<BxMallSubDto> bxMallSubDto =
        jsonRes['bxMallSubDto'] is List ? <BxMallSubDto>[] : null;
    if (bxMallSubDto != null) {
      for (final dynamic item in jsonRes['bxMallSubDto']) {
        if (item != null) {
          bxMallSubDto
              .add(BxMallSubDto.fromJson(asT<Map<String, dynamic>>(item)));
        }
      }
    }

    return Data(
      mallCategoryId: asT<String>(jsonRes['mallCategoryId']),
      mallCategoryName: asT<String>(jsonRes['mallCategoryName']),
      bxMallSubDto: bxMallSubDto,
      comments: asT<Object>(jsonRes['comments']),
      image: asT<String>(jsonRes['image']),
    );
  }

  String _mallCategoryId;
  String get mallCategoryId => _mallCategoryId;
  String _mallCategoryName;
  String get mallCategoryName => _mallCategoryName;
  List<BxMallSubDto> _bxMallSubDto;
  List<BxMallSubDto> get bxMallSubDto => _bxMallSubDto;
  Object _comments;
  Object get comments => _comments;
  String _image;
  String get image => _image;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'mallCategoryId': _mallCategoryId,
        'mallCategoryName': _mallCategoryName,
        'bxMallSubDto': _bxMallSubDto,
        'comments': _comments,
        'image': _image,
      };

  @override
  String toString() {
    return json.encode(this);
  }
}

class BxMallSubDto {
  BxMallSubDto({
    String mallSubId,
    String mallCategoryId,
    String mallSubName,
    String comments,
  })  : _mallSubId = mallSubId,
        _mallCategoryId = mallCategoryId,
        _mallSubName = mallSubName,
        _comments = comments;
  factory BxMallSubDto.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : BxMallSubDto(
          mallSubId: asT<String>(jsonRes['mallSubId']),
          mallCategoryId: asT<String>(jsonRes['mallCategoryId']),
          mallSubName: asT<String>(jsonRes['mallSubName']),
          comments: asT<String>(jsonRes['comments']),
        );

  String _mallSubId;
  String get mallSubId => _mallSubId;
  String _mallCategoryId;
  String get mallCategoryId => _mallCategoryId;
  String _mallSubName;
  String get mallSubName => _mallSubName;
  String _comments;
  String get comments => _comments;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'mallSubId': _mallSubId,
        'mallCategoryId': _mallCategoryId,
        'mallSubName': _mallSubName,
        'comments': _comments,
      };

  @override
  String toString() {
    return json.encode(this);
  }
}
