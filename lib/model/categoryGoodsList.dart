import 'dart:convert' show json;

T asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class CategoryGoodsListModel {
  CategoryGoodsListModel({
    String code,
    String message,
    List<CategoryListData> data,
  })  : _code = code,
        _message = message,
        _data = data;
  factory CategoryGoodsListModel.fromJson(Map<String, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }
    final List<CategoryListData> data = jsonRes['data'] is List ? <CategoryListData>[] : null;
    if (data != null) {
      for (final dynamic item in jsonRes['data']) {
        if (item != null) {
          data.add(CategoryListData.fromJson(asT<Map<String, dynamic>>(item)));
        }
      }
    }

    return CategoryGoodsListModel(
      code: asT<String>(jsonRes['code']),
      message: asT<String>(jsonRes['message']),
      data: data,
    );
  }

  String _code;
  String get code => _code;
  String _message;
  String get message => _message;
  List<CategoryListData> _data;
  List<CategoryListData> get data => _data;

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

class CategoryListData {
  CategoryListData({
    String image,
    double oriPrice,
    double presentPrice,
    String goodsName,
    String goodsId,
  })  : _image = image,
        _oriPrice = oriPrice,
        _presentPrice = presentPrice,
        _goodsName = goodsName,
        _goodsId = goodsId;
  factory CategoryListData.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : CategoryListData(
          image: asT<String>(jsonRes['image']),
          oriPrice: asT<double>(jsonRes['oriPrice']),
          presentPrice: asT<double>(jsonRes['presentPrice']),
          goodsName: asT<String>(jsonRes['goodsName']),
          goodsId: asT<String>(jsonRes['goodsId']),
        );

  String _image;
  String get image => _image;
  double _oriPrice;
  double get oriPrice => _oriPrice;
  double _presentPrice;
  double get presentPrice => _presentPrice;
  String _goodsName;
  String get goodsName => _goodsName;
  String _goodsId;
  String get goodsId => _goodsId;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'image': _image,
        'oriPrice': _oriPrice,
        'presentPrice': _presentPrice,
        'goodsName': _goodsName,
        'goodsId': _goodsId,
      };

  @override
  String toString() {
    return json.encode(this);
  }
}
