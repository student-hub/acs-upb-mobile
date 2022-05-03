import 'package:acs_upb_mobile/generated/l10n.dart';

enum SourceCategory { official, organizations, students }

extension SourceCategoryExtension on SourceCategory {
  String toLocalizedString() {
    switch (this) {
      case SourceCategory.official:
        return S.current.sourceOfficial;
      case SourceCategory.organizations:
        return S.current.sourceOrganization;
      case SourceCategory.students:
        return S.current.sourceStudentRepresentative;
      default:
        return S.current.sourceOfficial;
    }
  }
}
