import 'package:cbl/cbl.dart';

part 'master_feeling.cbl.type.g.dart';

@TypedDocument()
abstract class MasterFeeling with _$MasterFeeling {
  factory MasterFeeling({
    @DocumentId() String? id,
    required String slug,
    required String name,
    required String type,
    String? parentSlug,
    int? energy,
    int? pleasantness,
  }) = MutableMasterFeeling;
}