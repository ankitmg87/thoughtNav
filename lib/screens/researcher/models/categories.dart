class Categories {
  String categoriesUID;
  bool lifestyle;
  bool health;
  bool auto;
  bool fashion;
  bool advertising;
  bool product;
  bool futures;
  String others;

  Categories({
    this.categoriesUID,
    this.lifestyle,
    this.health,
    this.auto,
    this.fashion,
    this.advertising,
    this.product,
    this.futures,
    this.others,
  });

  void setCategoryStatus(String categoryName, bool status){
    switch(categoryName){
      case 'Lifestyle':
        lifestyle = status;
        break;
      case 'Health':
        health = status;
        break;
      case 'Auto':
        auto = status;
        break;
      case 'Fashion':
        fashion = status;
        break;
      case 'Advertising':
        advertising = status;
        break;
      case 'Product':
        product = status;
        break;
      case 'Futures':
        futures = status;
        break;
    }
  }

  bool checkCategoryStatus(String categoryName){
    var categoryStatus;
    switch(categoryName){
      case 'Lifestyle':
        categoryStatus = lifestyle;
        break;
      case 'Health':
        categoryStatus = health;
        break;
      case 'Auto':
        categoryStatus = auto;
        break;
      case 'Fashion':
        categoryStatus = fashion;
        break;
      case 'Advertising':
        categoryStatus = advertising;
        break;
      case 'Product':
        categoryStatus = product;
        break;
      case 'Futures':
        categoryStatus = futures;
        break;
    }

    return categoryStatus;
  }

  Map toMap(Categories categories){
    var categoriesMap = <String, dynamic>{};

    categoriesMap['categoriesUID'] = categories.categoriesUID ?? false;
    categoriesMap['lifestyle'] = categories.lifestyle ?? false;
    categoriesMap['health'] = categories.health ?? false;
    categoriesMap['auto'] = categories.auto ?? false;
    categoriesMap['fashion'] = categories.fashion ?? false;
    categoriesMap['advertising'] = categories.advertising ?? false;
    categoriesMap['product'] = categories.product ?? false;
    categoriesMap['futures'] = categories.futures ?? false;
    categoriesMap['others'] = categories.others ?? false;

    return categoriesMap;
  }

  Categories.fromMap(Map<String, dynamic> categories){
    categoriesUID = categories['categoriesUID'];
    lifestyle = categories['lifestyle'];
    health = categories['health'];
    auto = categories['auto'];
    fashion = categories['fashion'];
    advertising = categories['advertising'];
    product = categories['product'];
    futures = categories['futures'];
    others = categories['others'];
  }

}