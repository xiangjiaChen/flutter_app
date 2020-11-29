class CategoryBigModel{
  String mallCategoryId; //类别编号
  String mallCategoryName; //类别名称
  String bxMallSubDto;
  Null comments;
  String image;

  CategoryBigModel({
    this.mallCategoryId,
    this.mallCategoryName,
    this.bxMallSubDto,
    this.comments,
    this.image,
  });

  factory CategoryBigModel.formJson(dynamic json){
    return CategoryBigModel(
      mallCategoryId: json['mallCategoryId'],
      mallCategoryName: json['mallCategoryName'],
      bxMallSubDto: json['mallCategoryId'],
      comments: json['comments'],
      image: json['image']
    );
  }
}

class CategoryBigListModel{
  List<CategoryBigModel> data;

  CategoryBigListModel(this.data);

  factory CategoryBigListModel.formJson(List json){
    return CategoryBigListModel(
      json.map((i) => CategoryBigModel.formJson(i)).toList()
    );
  }
}