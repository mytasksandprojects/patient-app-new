import 'package:userapp/Language.dart';
import 'package:userapp/generated/l10n.dart';

class MedicalHistoryTranslationHelper {
  // Translate record type names
  static String translateRecordType(String recordType) {
    switch (recordType.toLowerCase()) {
      case 'iris':
        return S.current.LIris;
      case 'lenses':
        return S.current.LLenses;
      case 'yag_laser':
        return S.current.LYagLaser;
      case 'retina_laser':
        return S.current.LRetinaLaser;
      case 'oculoplasty_laser':
        return S.current.LOculoplastyLaser;
      case 'glaucoma_laser':
        return S.current.LGlaucomaLaser;
      case 'dilatation':
        return S.current.LDilatation;
      default:
        return recordType;
    }
  }

  // Translate yes/no values
  static String translateYesNo(String value) {
    switch (value.toLowerCase()) {
      case 'yes':
      case 'true':
      case '1':
        return S.current.LYes;
      case 'no':
      case 'false':
      case '0':
        return S.current.LNo;
      default:
        return value;
    }
  }

  // Translate common medical field names
  static String translateFieldName(String fieldName) {
    switch (fieldName.toLowerCase()) {
      case 'complaint':
        return S.current.LComplaint;
      case 'remarks':
        return S.current.LRemarks;
      case 'management_plan_comment':
        return S.current.LManagementPlan;
      case 'comment':
        return S.current.LComment;
      case 'transcribed_text':
        return S.current.LTranscribedText;
      case 'iop_air_puff_left':
        return "${S.current.LIopAirPuff} (${S.current.LLeft})";
      case 'iop_air_puff_right':
        return "${S.current.LIopAirPuff} (${S.current.LRight})";
      case 'iop_app_left':
        return "${S.current.LIopApp} (${S.current.LLeft})";
      case 'iop_app_right':
        return "${S.current.LIopApp} (${S.current.LRight})";
      case 'ucva_right':
        return "${S.current.LUCVA} (${S.current.LRight})";
      case 'bcva_left':
        return "${S.current.LBCVA} (${S.current.LLeft})";
      case 'bcva_right':
        return "${S.current.LBCVA} (${S.current.LRight})";
      case 'ar_sphere_left':
        return "${S.current.LSphere} (${S.current.LLeft})";
      case 'ar_sphere_right':
        return "${S.current.LSphere} (${S.current.LRight})";
      case 'ar_cylinder_left':
        return "${S.current.LCylinder} (${S.current.LLeft})";
      case 'ar_cylinder_right':
        return "${S.current.LCylinder} (${S.current.LRight})";
      case 'ar_axis_left':
        return "${S.current.LAxis} (${S.current.LLeft})";
      case 'ar_axis_right':
        return "${S.current.LAxis} (${S.current.LRight})";
      case 'ant_seg_radio2_left':
        return "${S.current.LAnteriorSegment} (${S.current.LLeft})";
      case 'ant_seg_radio2_right':
        return "${S.current.LAnteriorSegment} (${S.current.LRight})";
      case 'power_left':
        return "${S.current.LPower} (${S.current.LLeft})";
      case 'power_right':
        return "${S.current.LPower} (${S.current.LRight})";
      case 'brand_left':
        return "${S.current.LBrand} (${S.current.LLeft})";
      case 'brand_right':
        return "${S.current.LBrand} (${S.current.LRight})";
      case 'color_left':
        return "${S.current.LColor} (${S.current.LLeft})";
      case 'color_right':
        return "${S.current.LColor} (${S.current.LRight})";
      case 'base_curve_left':
        return "${S.current.LBaseCurve} (${S.current.LLeft})";
      case 'base_curve_right':
        return "${S.current.LBaseCurve} (${S.current.LRight})";
      case 'landing_zone_left':
        return "${S.current.LLandingZone} (${S.current.LLeft})";
      case 'landing_zone_right':
        return "${S.current.LLandingZone} (${S.current.LRight})";
      case 'saggital_left':
        return "${S.current.LSaggital} (${S.current.LLeft})";
      case 'saggital_right':
        return "${S.current.LSaggital} (${S.current.LRight})";
      case 'edge_left':
        return "${S.current.LEdge} (${S.current.LLeft})";
      case 'edge_right':
        return "${S.current.LEdge} (${S.current.LRight})";
      case 'visual_acuity_left':
        return "${S.current.LVisualAcuity} (${S.current.LLeft})";
      case 'visual_acuity_right':
        return "${S.current.LVisualAcuity} (${S.current.LRight})";
      case 'capsulotomy_od':
        return "${S.current.LCapsulotomy} ${S.current.LOD}";
      case 'capsulotomy_os':
        return "${S.current.LCapsulotomy} ${S.current.LOS}";
      case 'capsulotomy_ou':
        return "${S.current.LCapsulotomy} ${S.current.LOU}";
      case 'iridotomy_od':
        return "${S.current.LIridotomy} ${S.current.LOD}";
      case 'iridotomy_os':
        return "${S.current.LIridotomy} ${S.current.LOS}";
      case 'iridotomy_ou':
        return "${S.current.LIridotomy} ${S.current.LOU}";
      case 'hyaloidotomy_od':
        return "${S.current.LHyaloidotomy} ${S.current.LOD}";
      case 'hyaloidotomy_os':
        return "${S.current.LHyaloidotomy} ${S.current.LOS}";
      case 'hyaloidotomy_ou':
        return "${S.current.LHyaloidotomy} ${S.current.LOU}";
      case 'focal_od':
        return "${S.current.LFocal} ${S.current.LOD}";
      case 'focal_os':
        return "${S.current.LFocal} ${S.current.LOS}";
      case 'focal_ou':
        return "${S.current.LFocal} ${S.current.LOU}";
      case 'prp_od':
        return "${S.current.LPRP} ${S.current.LOD}";
      case 'prp_os':
        return "${S.current.LPRP} ${S.current.LOS}";
      case 'prp_ou':
        return "${S.current.LPRP} ${S.current.LOU}";
      case 'barrage_od':
        return "${S.current.LBarrage} ${S.current.LOD}";
      case 'barrage_os':
        return "${S.current.LBarrage} ${S.current.LOS}";
      case 'barrage_ou':
        return "${S.current.LBarrage} ${S.current.LOU}";
      case 'around_breaks_od':
        return "${S.current.LAroundBreaks} ${S.current.LOD}";
      case 'around_breaks_os':
        return "${S.current.LAroundBreaks} ${S.current.LOS}";
      case 'around_breaks_ou':
        return "${S.current.LAroundBreaks} ${S.current.LOU}";
      case 'scattered_od':
        return "${S.current.LScattered} ${S.current.LOD}";
      case 'scattered_os':
        return "${S.current.LScattered} ${S.current.LOS}";
      case 'scattered_ou':
        return "${S.current.LScattered} ${S.current.LOU}";
      case 'lashes_roots_od':
        return "${S.current.LLashesRoots} ${S.current.LOD}";
      case 'lashes_roots_os':
        return "${S.current.LLashesRoots} ${S.current.LOS}";
      case 'lashes_roots_ou':
        return "${S.current.LLashesRoots} ${S.current.LOU}";
      case 'alt_od':
        return "${S.current.LALT} ${S.current.LOD}";
      case 'alt_os':
        return "${S.current.LALT} ${S.current.LOS}";
      case 'alt_ou':
        return "${S.current.LALT} ${S.current.LOU}";
      case 'iridoplasty_od':
        return "${S.current.LIridoplasty} ${S.current.LOD}";
      case 'iridoplasty_os':
        return "${S.current.LIridoplasty} ${S.current.LOS}";
      case 'iridoplasty_ou':
        return "${S.current.LIridoplasty} ${S.current.LOU}";
      case 'suture_lysis_od':
        return "${S.current.LSutureLysis} ${S.current.LOD}";
      case 'suture_lysis_os':
        return "${S.current.LSutureLysis} ${S.current.LOS}";
      case 'suture_lysis_ou':
        return "${S.current.LSutureLysis} ${S.current.LOU}";
      case 'iridectomy_od':
        return "${S.current.LIridectomy} ${S.current.LOD}";
      case 'iridectomy_os':
        return "${S.current.LIridectomy} ${S.current.LOS}";
      case 'iridectomy_ou':
        return "${S.current.LIridectomy} ${S.current.LOU}";
      case 'mydriacyl_left':
        return "${S.current.LMydriacyl} (${S.current.LLeft})";
      case 'mydriacyl_right':
        return "${S.current.LMydriacyl} (${S.current.LRight})";
      case 'phenyl_left':
        return "${S.current.LPhenyl} (${S.current.LLeft})";
      case 'phenyl_right':
        return "${S.current.LPhenyl} (${S.current.LRight})";
      case 'cyclo_ar_left':
        return "${S.current.LCycloAR} (${S.current.LLeft})";
      case 'cyclo_ar_right':
        return "${S.current.LCycloAR} (${S.current.LRight})";
      case 'pilocarpine_left':
        return "${S.current.LPilocarpine} (${S.current.LLeft})";
      case 'pilocarpine_right':
        return "${S.current.LPilocarpine} (${S.current.LRight})";
      case 'step_left':
        return "${S.current.LStep} (${S.current.LLeft})";
      case 'step_right':
        return "${S.current.LStep} (${S.current.LRight})";
      case 'created_at_formatted':
        return S.current.LCreatedAt;
      case 'updated_at_formatted':
        return S.current.LUpdatedAt;
      default:
        // Convert snake_case to Title Case as fallback
        return fieldName
            .split('_')
            .map((word) => word.isNotEmpty 
                ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                : word)
            .join(' ');
    }
  }

  // Translate common medical values
  static String translateValue(String value) {
    switch (value.toLowerCase()) {
      case 'clear':
        return S.current.LClear;
      case 'cataract':
        return S.current.LCataract;
      case 'pseudo':
        return S.current.LPseudo;
      case 'aphakic':
        return S.current.LAphakic;
      case 'sluggish':
        return S.current.LSluggish;
      case 'yes':
      case 'true':
        return S.current.LYes;
      case 'no':
      case 'false':
        return S.current.LNo;
      default:
        return value;
    }
  }

  // Helper to check if a field should be displayed as boolean
  static bool isBooleanField(String fieldName) {
    return fieldName.contains('_od') || 
           fieldName.contains('_os') || 
           fieldName.contains('_ou') ||
           fieldName.endsWith('_left') && (fieldName.contains('sluggish') || 
                                          fieldName.contains('rapd') || 
                                          fieldName.contains('rrr') || 
                                          fieldName.contains('aphakic') || 
                                          fieldName.contains('pseudo') || 
                                          fieldName.contains('cataract') || 
                                          fieldName.contains('clear')) ||
           fieldName.endsWith('_right') && (fieldName.contains('sluggish') || 
                                           fieldName.contains('rapd') || 
                                           fieldName.contains('rrr') || 
                                           fieldName.contains('aphakic') || 
                                           fieldName.contains('pseudo') || 
                                           fieldName.contains('cataract') || 
                                           fieldName.contains('clear'));
  }

  // Helper to format boolean display
  static String formatBooleanValue(dynamic value) {
    if (value is bool) {
      return value ? S.current.LYes : S.current.LNo;
    }
    if (value is String) {
      switch (value.toLowerCase()) {
        case 'true':
        case '1':
        case 'yes':
          return S.current.LYes;
        case 'false':
        case '0':
        case 'no':
          return S.current.LNo;
        default:
          return value;
      }
    }
    if (value is int) {
      return value == 1 ? S.current.LYes : S.current.LNo;
    }
    return value.toString();
  }
}
