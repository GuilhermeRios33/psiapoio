import '../data/clinics_data.dart';
import '../models/clinic.dart';

class ClinicService {
  static List<Clinic> getAll() => clinics;
}
