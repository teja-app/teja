import 'package:cbl/cbl.dart';

part 'master_factor.cbl.type.g.dart';

@TypedDictionary()
abstract class SubCategory with _$SubCategory {
  factory SubCategory({
    required String slug,
    required String title,
  }) = MutableSubCategory;
}

@TypedDocument()
abstract class MasterFactor with _$MasterFactor {
  factory MasterFactor({
    @DocumentId() String? id,
    required String slug,
    required String title,
    List<SubCategory>? subcategories,
  }) = MutableMasterFactor;
}