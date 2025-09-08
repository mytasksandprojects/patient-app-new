import 'package:userapp/generated/l10n.dart';

extension VitalsExtension on S {
  String vitals(String vitalKey) {
    switch (vitalKey) {
      case 'blood_pressure': return blood_pressure;
      case 'sugar': return sugar;
      case 'weight': return weight;
      case 'temperature': return temperature;
      case 'spo2': return spo2;
      default: return vitalKey;
    }
  }
}
extension UnitsExtension on S {
  String getUnit(String vitalType) {
    return switch (vitalType.toLowerCase().trim()) {
      'blood_pressure' => units_mmHg,
      'sugar' => units_Mgdl,
      'weight' => units_KG,
      'temperature' => units_F,
      'spo2' => units_percent,
      _ => '',
    };
  }
}
