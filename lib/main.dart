import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const UgandaCareApp());
}

// ─────────────────────────────────────────────────────────────
// THEME & CONSTANTS
// ─────────────────────────────────────────────────────────────
const Color kPrimary = Color(0xFF006B3F); // Uganda green
const Color kAccent = Color(0xFFFCDC04); // Uganda yellow
const Color kRed = Color(0xFFD21034); // Uganda red
const Color kSurface = Color(0xFFF5F7F5);
const Color kCard = Colors.white;
const Color kText = Color(0xFF1A2E1A);
const Color kSubText = Color(0xFF5A7A5A);

ThemeData get appTheme => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: kPrimary,
        primary: kPrimary,
        secondary: kAccent,
        surface: kSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFCDD9CD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFCDD9CD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kPrimary, width: 2),
        ),
        labelStyle: const TextStyle(color: kSubText),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    cardTheme: CardThemeData(
  color: kCard,
  elevation: 2,
  shadowColor: kPrimary.withValues(alpha: 0.08),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
  ),
  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
),
      fontFamily: 'Roboto',
    );

// ─────────────────────────────────────────────────────────────
// MODELS
// ─────────────────────────────────────────────────────────────
enum AccessLevel { patient, clinic, regionalHospital, ministryOfHealth }

enum Gender { male, female, other }

enum MaritalStatus { single, married, divorced, widowed, separated }

class Address {
  String district;
  String subCounty;
  String village;
  String parish;
  String region;

  Address({
    this.district = '',
    this.subCounty = '',
    this.village = '',
    this.parish = '',
    this.region = '',
  });
}

class PhysicalMeasurements {
  double? heightCm;
  double? weightKg;
  double? bmi;
  String? bloodPressure;
  double? temperature;
  int? pulseRate;
  int? respiratoryRate;
  double? oxygenSaturation;
  String? bloodGroup;
  bool rhFactor = true; // true = positive

  PhysicalMeasurements();
}

class GeneticInfo {
  String hivStatus = 'Unknown';
  String sickleCellStatus = 'Unknown';
  String hepatitisBStatus = 'Unknown';
  String hepatitisCStatus = 'Unknown';
  String malariaStatus = 'Unknown';
  String tbStatus = 'Unknown';
}

class ChronicCondition {
  String name;
  String diagnosedYear;
  String managedBy;
  String notes;
  ChronicCondition({
    required this.name,
    this.diagnosedYear = '',
    this.managedBy = '',
    this.notes = '',
  });
}

class Allergy {
  String allergen;
  String reaction;
  String severity;
  Allergy(
      {required this.allergen, this.reaction = '', this.severity = 'Moderate'});
}

class Medication {
  String name;
  String dose;
  String frequency;
  String startDate;
  Medication(
      {required this.name,
      this.dose = '',
      this.frequency = '',
      this.startDate = ''});
}

class ImmunizationRecord {
  String vaccine;
  String date;
  String facility;
  String batchNo;
  ImmunizationRecord(
      {required this.vaccine,
      this.date = '',
      this.facility = '',
      this.batchNo = ''});
}

class ReproductiveHealth {
  bool applicable = false;
  String pregnanciesCount = '0';
  String livebirthsCount = '0';
  String lastMenstrualPeriod = '';
  String contraceptionMethod = 'None';
  bool onAntenatalCare = false;
  String ancFacility = '';
}

class EmergencyContact {
  String name;
  String relationship;
  String phone;
  EmergencyContact({this.name = '', this.relationship = '', this.phone = ''});
}

class ClinicalVisit {
  final String visitId;
  final DateTime date;
  final String facilityName;
  final String facilityDistrict;
  final String clinicianName;
  final String chiefComplaint;
  final String diagnosis;
  final String icd10Code;
  final String treatment;
  final String prescription;
  final String referredTo;
  final String notes;
  final AccessLevel accessedBy;

  ClinicalVisit({
    required this.visitId,
    required this.date,
    required this.facilityName,
    required this.facilityDistrict,
    required this.clinicianName,
    required this.chiefComplaint,
    required this.diagnosis,
    required this.icd10Code,
    required this.treatment,
    required this.prescription,
    this.referredTo = '',
    this.notes = '',
    required this.accessedBy,
  });
}

class Patient {
  final String uhn; // Uganda Health Number
  final String registrationDate;

  // Section 1: Personal
  String firstName;
  String middleName;
  String lastName;
  String nin; // National ID Number
  DateTime? dateOfBirth;
  Gender gender;
  MaritalStatus maritalStatus;
  String nationality;
  String tribe;
  String religion;
  String occupation;
  String educationLevel;
  String phone;
  String altPhone;
  String email;
  String nextOfKin;
  String nextOfKinPhone;

  // Section 2: Address
  Address address;

  // Section 3: Physical
  PhysicalMeasurements measurements;

  // Section 4: Genetic / Lab
  GeneticInfo geneticInfo;

  // Section 5: Chronic conditions
  List<ChronicCondition> chronicConditions;

  // Section 6: Allergies
  List<Allergy> allergies;

  // Section 7: Current medications
  List<Medication> currentMedications;

  // Section 8: Lifestyle
  String smokingStatus;
  String alcoholUse;
  String exerciseFrequency;
  String dietaryRestrictions;

  // Section 9: Reproductive health
  ReproductiveHealth reproductiveHealth;

  // Section 10: Immunizations
  List<ImmunizationRecord> immunizations;

  // Section 11: Disability
  bool hasDisability;
  String disabilityType;

  // Emergency
  EmergencyContact emergencyContact;

  // Insurance
  String insuranceProvider;
  String insuranceMemberNo;
  String nhifNumber;

  // Consent
  bool consentGiven;

  // Visit history
  List<ClinicalVisit> visits;

  // Registered at
  String registeredFacility;
  String registeredDistrict;

  Patient({
    required this.uhn,
    required this.registrationDate,
    required this.firstName,
    this.middleName = '',
    required this.lastName,
    this.nin = '',
    this.dateOfBirth,
    this.gender = Gender.male,
    this.maritalStatus = MaritalStatus.single,
    this.nationality = 'Ugandan',
    this.tribe = '',
    this.religion = '',
    this.occupation = '',
    this.educationLevel = '',
    this.phone = '',
    this.altPhone = '',
    this.email = '',
    this.nextOfKin = '',
    this.nextOfKinPhone = '',
    Address? address,
    PhysicalMeasurements? measurements,
    GeneticInfo? geneticInfo,
    List<ChronicCondition>? chronicConditions,
    List<Allergy>? allergies,
    List<Medication>? currentMedications,
    this.smokingStatus = 'Never',
    this.alcoholUse = 'None',
    this.exerciseFrequency = 'Rarely',
    this.dietaryRestrictions = 'None',
    ReproductiveHealth? reproductiveHealth,
    List<ImmunizationRecord>? immunizations,
    this.hasDisability = false,
    this.disabilityType = '',
    EmergencyContact? emergencyContact,
    this.insuranceProvider = '',
    this.insuranceMemberNo = '',
    this.nhifNumber = '',
    this.consentGiven = true,
    List<ClinicalVisit>? visits,
    this.registeredFacility = '',
    this.registeredDistrict = '',
  })  : address = address ?? Address(),
        measurements = measurements ?? PhysicalMeasurements(),
        geneticInfo = geneticInfo ?? GeneticInfo(),
        chronicConditions = chronicConditions ?? [],
        allergies = allergies ?? [],
        currentMedications = currentMedications ?? [],
        reproductiveHealth = reproductiveHealth ?? ReproductiveHealth(),
        immunizations = immunizations ?? [],
        emergencyContact = emergencyContact ?? EmergencyContact(),
        visits = visits ?? [];

  String get fullName =>
      [firstName, middleName, lastName].where((s) => s.isNotEmpty).join(' ');

  int? get ageYears {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }
}

// ─────────────────────────────────────────────────────────────
// STATE / DATABASE (in-memory)
// ─────────────────────────────────────────────────────────────
class EhrDatabase extends ChangeNotifier {
  static final EhrDatabase _instance = EhrDatabase._internal();
  factory EhrDatabase() => _instance;
  EhrDatabase._internal() {
    _seedDemoData();
  }

  final List<Patient> patients = [];
  AccessLevel currentUserLevel = AccessLevel.clinic;
  String currentFacility = 'Mulago National Referral Hospital';
  String currentDistrict = 'Kampala';
  int _uhnCounter = 1001;

  String generateUHN() {
    final id =
        'UHN-${DateTime.now().year}-${_uhnCounter.toString().padLeft(6, '0')}';
    _uhnCounter++;
    return id;
  }

  void addPatient(Patient p) {
    patients.add(p);
    notifyListeners();
  }

  void addVisit(String uhn, ClinicalVisit visit) {
    final idx = patients.indexWhere((p) => p.uhn == uhn);
    if (idx != -1) {
      patients[idx].visits.add(visit);
      notifyListeners();
    }
  }

  Patient? findByUHN(String uhn) {
    try {
      return patients
          .firstWhere((p) => p.uhn.toLowerCase() == uhn.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  List<Patient> search(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return patients;
    return patients.where((p) {
      return p.uhn.toLowerCase().contains(q) ||
          p.fullName.toLowerCase().contains(q) ||
          p.nin.toLowerCase().contains(q) ||
          p.phone.contains(q);
    }).toList();
  }

  // National stats
  int get totalPatients => patients.length;
  int get totalVisitsToday {
    final today = DateTime.now();
    return patients
        .expand((p) => p.visits)
        .where((v) =>
            v.date.year == today.year &&
            v.date.month == today.month &&
            v.date.day == today.day)
        .length;
  }

  int get activeFacilities => 47; // simulated
  int get alertsCount => 3;

  void _seedDemoData() {
    // Patient 1
    final p1 = Patient(
      uhn: 'UHN-2026-001001',
      registrationDate: '2026-01-10',
      firstName: 'Akello',
      middleName: 'Grace',
      lastName: 'Opio',
      nin: 'CM86100150YKWK',
      dateOfBirth: DateTime(1986, 10, 1),
      gender: Gender.female,
      maritalStatus: MaritalStatus.married,
      tribe: 'Acholi',
      religion: 'Christian',
      occupation: 'Teacher',
      educationLevel: 'University',
      phone: '0772345678',
      nextOfKin: 'Opio James',
      nextOfKinPhone: '0751234567',
      address: Address(
        district: 'Gulu',
        subCounty: 'Bardege',
        village: 'Layibi',
        parish: 'Layibi',
        region: 'Northern',
      ),
      measurements: PhysicalMeasurements()
        ..heightCm = 163
        ..weightKg = 68
        ..bmi = 25.6
        ..bloodPressure = '120/80'
        ..bloodGroup = 'A'
        ..rhFactor = true,
      geneticInfo: GeneticInfo()
        ..hivStatus = 'Negative'
        ..hepatitisBStatus = 'Negative'
        ..sickleCellStatus = 'Carrier',
      chronicConditions: [
        ChronicCondition(
          name: 'Hypertension',
          diagnosedYear: '2020',
          managedBy: 'Gulu Regional Referral Hospital',
          notes: 'Stage 1, well controlled on medication',
        ),
      ],
      allergies: [
        Allergy(
            allergen: 'Penicillin',
            reaction: 'Rash and hives',
            severity: 'Severe'),
      ],
      currentMedications: [
        Medication(
            name: 'Amlodipine',
            dose: '5mg',
            frequency: 'Once daily',
            startDate: '2020-03-15'),
      ],
      smokingStatus: 'Never',
      alcoholUse: 'Occasional',
      exerciseFrequency: '3x per week',
      immunizations: [
        ImmunizationRecord(
            vaccine: 'COVID-19 (Pfizer)',
            date: '2021-09-10',
            facility: 'Gulu RRH',
            batchNo: 'PFZ-2021-09'),
        ImmunizationRecord(
            vaccine: 'Yellow Fever',
            date: '2015-06-01',
            facility: 'Gulu HC IV',
            batchNo: 'YF-2015-44'),
        ImmunizationRecord(
            vaccine: 'Tetanus Toxoid',
            date: '2019-03-20',
            facility: 'Gulu HC IV',
            batchNo: 'TT-2019-12'),
      ],
      registeredFacility: 'Gulu Regional Referral Hospital',
      registeredDistrict: 'Gulu',
      visits: [
        ClinicalVisit(
          visitId: 'V-001',
          date: DateTime(2026, 1, 15),
          facilityName: 'Gulu Regional Referral Hospital',
          facilityDistrict: 'Gulu',
          clinicianName: 'Dr. Okello Peter',
          chiefComplaint: 'Headache and elevated BP',
          diagnosis: 'Hypertension - uncontrolled',
          icd10Code: 'I10',
          treatment: 'Medication adjusted, lifestyle counselling given',
          prescription: 'Amlodipine 10mg OD, HCTZ 25mg OD',
          accessedBy: AccessLevel.clinic,
        ),
        ClinicalVisit(
          visitId: 'V-002',
          date: DateTime(2026, 3, 5),
          facilityName: 'Mulago National Referral Hospital',
          facilityDistrict: 'Kampala',
          clinicianName: 'Dr. Nakato Sarah',
          chiefComplaint: 'Chest pain - referred from Gulu',
          diagnosis: 'Hypertensive heart disease',
          icd10Code: 'I11.9',
          treatment: 'ECG done, echocardiography ordered',
          prescription: 'Atenolol 50mg OD, Aspirin 75mg OD',
          referredTo: '',
          accessedBy: AccessLevel.regionalHospital,
        ),
      ],
    );

    // Patient 2
    final p2 = Patient(
      uhn: 'UHN-2026-001002',
      registrationDate: '2026-01-22',
      firstName: 'Ssemakula',
      middleName: '',
      lastName: 'Ronald',
      nin: 'CM90041587ABCD',
      dateOfBirth: DateTime(1990, 4, 15),
      gender: Gender.male,
      maritalStatus: MaritalStatus.single,
      tribe: 'Baganda',
      religion: 'Muslim',
      occupation: 'Boda Boda Rider',
      educationLevel: 'Secondary',
      phone: '0700112233',
      nextOfKin: 'Ssemakula John',
      nextOfKinPhone: '0784556677',
      address: Address(
        district: 'Wakiso',
        subCounty: 'Nansana',
        village: 'Kavule',
        parish: 'Kavule',
        region: 'Central',
      ),
      measurements: PhysicalMeasurements()
        ..heightCm = 175
        ..weightKg = 72
        ..bmi = 23.5
        ..bloodPressure = '118/76'
        ..bloodGroup = 'O'
        ..rhFactor = true,
      geneticInfo: GeneticInfo()
        ..hivStatus = 'Negative'
        ..malariaStatus = 'History of recurrent malaria'
        ..sickleCellStatus = 'Negative',
      smokingStatus: 'Never',
      alcoholUse: 'Regular',
      exerciseFrequency: 'Daily (work related)',
      registeredFacility: 'Nansana Health Centre IV',
      registeredDistrict: 'Wakiso',
      visits: [
        ClinicalVisit(
          visitId: 'V-003',
          date: DateTime(2026, 2, 14),
          facilityName: 'Nansana Health Centre IV',
          facilityDistrict: 'Wakiso',
          clinicianName: 'Clinical Officer Namutebi',
          chiefComplaint: 'Fever, chills, body aches',
          diagnosis: 'Malaria - Uncomplicated',
          icd10Code: 'B54',
          treatment: 'Artemether-lumefantrine prescribed',
          prescription: 'Coartem 4 tabs BD x3 days',
          accessedBy: AccessLevel.clinic,
        ),
      ],
    );

    patients.addAll([p1, p2]);
    _uhnCounter = 1003;
  }
}

// ─────────────────────────────────────────────────────────────
// APP ROOT
// ─────────────────────────────────────────────────────────────
class UgandaCareApp extends StatelessWidget {
  const UgandaCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: EhrDatabase(),
      builder: (context, _) {
        return MaterialApp(
          title: 'UgandaCare EHR',
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          home: const MainShell(),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// MAIN SHELL
// ─────────────────────────────────────────────────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;
  final db = EhrDatabase();

  final List<_NavItem> _navItems = const [
    _NavItem(Icons.dashboard_rounded, 'Dashboard'),
    _NavItem(Icons.person_add_rounded, 'Register'),
    _NavItem(Icons.search_rounded, 'Find Patient'),
    _NavItem(Icons.analytics_rounded, 'Analytics'),
    _NavItem(Icons.shield_rounded, 'Access & Audit'),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width > 700;

    Widget body;
    switch (_selectedIndex) {
      case 0:
        body = const DashboardScreen();
        break;
      case 1:
        body = const RegisterPatientScreen();
        break;
      case 2:
        body = const FindPatientScreen();
        break;
      case 3:
        body = const AnalyticsScreen();
        break;
      case 4:
        body = const AccessAuditScreen();
        break;
      default:
        body = const DashboardScreen();
    }

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              backgroundColor: kPrimary,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (i) => setState(() => _selectedIndex = i),
              labelType: NavigationRailLabelType.all,
              selectedIconTheme: const IconThemeData(color: kAccent, size: 26),
              unselectedIconTheme:
                  const IconThemeData(color: Colors.white70, size: 22),
              selectedLabelTextStyle: const TextStyle(
                  color: kAccent, fontWeight: FontWeight.bold, fontSize: 11),
              unselectedLabelTextStyle:
                  const TextStyle(color: Colors.white60, fontSize: 11),
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                          color: kAccent, shape: BoxShape.circle),
                      child: const Icon(Icons.local_hospital,
                          color: kPrimary, size: 24),
                    ),
                    const SizedBox(height: 4),
                    const Text('UgandaCare',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              destinations: _navItems
                  .map((item) => NavigationRailDestination(
                        icon: Icon(item.icon),
                        label: Text(item.label),
                      ))
                  .toList(),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        backgroundColor: kPrimary,
        indicatorColor: kAccent,
        destinations: _navItems
            .map((item) => NavigationDestination(
                  icon: Icon(item.icon, color: Colors.white70),
                  selectedIcon: Icon(item.icon, color: kPrimary),
                  label: item.label,
                ))
            .toList(),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

// ─────────────────────────────────────────────────────────────
// DASHBOARD
// ─────────────────────────────────────────────────────────────
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final db = EhrDatabase();
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.local_hospital, color: kAccent, size: 22),
            SizedBox(width: 8),
            Text('UgandaCare National EHR'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _AccessBadge(db.currentUserLevel),
          ),
        ],
      ),
      backgroundColor: kSurface,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Facility info bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: kPrimary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: kPrimary.withOpacity(0.15)),
            ),
            child: Row(
              children: [
                const Icon(Icons.business_rounded, color: kPrimary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${db.currentFacility} • ${db.currentDistrict} District',
                    style: const TextStyle(
                        color: kPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13),
                  ),
                ),
                Text(
                  'Logged in as: ${_levelLabel(db.currentUserLevel)}',
                  style: const TextStyle(color: kSubText, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Stat cards
          const Text('National Overview',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700, color: kText)),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.6,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _StatCard('Registered Citizens', '${db.totalPatients}',
                  Icons.people_rounded, kPrimary),
              _StatCard('Active Facilities', '${db.activeFacilities}',
                  Icons.local_hospital_rounded, const Color(0xFF1565C0)),
              _StatCard("Today's Visits", '${db.totalVisitsToday}',
                  Icons.calendar_today_rounded, const Color(0xFF6A1B9A)),
              _StatCard('Active Alerts', '${db.alertsCount}',
                  Icons.warning_amber_rounded, kRed),
            ],
          ),
          const SizedBox(height: 20),

          // Alert banner
          _AlertBanner(),
          const SizedBox(height: 20),

          // Uganda Region Coverage
          const Text('Regional Coverage',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700, color: kText)),
          const SizedBox(height: 10),
          _RegionCoverageCard(),
          const SizedBox(height: 20),

          // Recent registrations
          const Text('Recently Registered',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700, color: kText)),
          const SizedBox(height: 8),
          ...db.patients.map((p) => _PatientListTile(patient: p)),
        ],
      ),
    );
  }

  String _levelLabel(AccessLevel l) {
    switch (l) {
      case AccessLevel.patient:
        return 'Patient';
      case AccessLevel.clinic:
        return 'Clinic Staff';
      case AccessLevel.regionalHospital:
        return 'Regional Hospital';
      case AccessLevel.ministryOfHealth:
        return 'Ministry of Health';
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard(this.title, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 22),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.1), shape: BoxShape.circle),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: color)),
                Text(title,
                    style: const TextStyle(fontSize: 11, color: kSubText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFF3E0),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.warning_rounded, color: Colors.orange, size: 18),
                SizedBox(width: 6),
                Text('Disease Surveillance Alerts',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.orange,
                        fontSize: 14)),
              ],
            ),
            const Divider(height: 12),
            ...[
              '🔴 Cholera outbreak — Moroto District (12 cases this week)',
              '🟡 Malaria surge — Arua District (+34% vs last month)',
              '🟠 Measles cluster — Kabale District (9 unvaccinated cases)',
            ].map((alert) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(alert,
                      style: const TextStyle(fontSize: 13, color: kText)),
                )),
          ],
        ),
      ),
    );
  }
}

class _RegionCoverageCard extends StatelessWidget {
  final List<Map<String, dynamic>> regions = const [
    {
      'name': 'Central',
      'facilities': 18,
      'patients': 1024,
      'color': Color(0xFF006B3F)
    },
    {
      'name': 'Northern',
      'facilities': 9,
      'patients': 412,
      'color': Color(0xFF1565C0)
    },
    {
      'name': 'Eastern',
      'facilities': 11,
      'patients': 564,
      'color': Color(0xFF6A1B9A)
    },
    {
      'name': 'Western',
      'facilities': 9,
      'patients': 398,
      'color': Color(0xFFC62828)
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: regions.map((r) {
            final pct = (r['facilities'] as int) / 47;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(r['name'],
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: kText)),
                      Text(
                          '${r['facilities']} facilities • ${r['patients']} patients',
                          style:
                              const TextStyle(fontSize: 12, color: kSubText)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct,
                      backgroundColor: Colors.grey[200],
                      color: r['color'] as Color,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _PatientListTile extends StatelessWidget {
  final Patient patient;
  const _PatientListTile({required this.patient});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: kPrimary.withOpacity(0.12),
          child: Text(patient.firstName[0],
              style: const TextStyle(
                  color: kPrimary, fontWeight: FontWeight.bold)),
        ),
        title: Text(patient.fullName,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text('${patient.uhn} • ${patient.address.district}',
            style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: kSubText),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => PatientProfileScreen(patient: patient),
          ));
        },
      ),
    );
  }
}

class _AccessBadge extends StatelessWidget {
  final AccessLevel level;
  const _AccessBadge(this.level);

  Color get _color {
    switch (level) {
      case AccessLevel.patient:
        return Colors.blue;
      case AccessLevel.clinic:
        return Colors.green;
      case AccessLevel.regionalHospital:
        return Colors.orange;
      case AccessLevel.ministryOfHealth:
        return kRed;
    }
  }

  String get _label {
    switch (level) {
      case AccessLevel.patient:
        return 'PATIENT';
      case AccessLevel.clinic:
        return 'CLINIC';
      case AccessLevel.regionalHospital:
        return 'REGIONAL';
      case AccessLevel.ministryOfHealth:
        return 'MOH';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(_label,
          style: const TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// REGISTER PATIENT SCREEN
// ─────────────────────────────────────────────────────────────
class RegisterPatientScreen extends StatefulWidget {
  const RegisterPatientScreen({super.key});

  @override
  State<RegisterPatientScreen> createState() => _RegisterPatientScreenState();
}

class _RegisterPatientScreenState extends State<RegisterPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final db = EhrDatabase();
  int _currentStep = 0;
  bool _submitted = false;
  String? _generatedUHN;

  // Controllers — Personal
  final _firstNameCtrl = TextEditingController();
  final _middleNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _ninCtrl = TextEditingController();
  DateTime? _dob;
  Gender _gender = Gender.male;
  MaritalStatus _maritalStatus = MaritalStatus.single;
  final _tribeCtrl = TextEditingController();
  final _religionCtrl = TextEditingController();
  final _occupationCtrl = TextEditingController();
  String _educationLevel = 'Primary';
  final _phoneCtrl = TextEditingController();
  final _altPhoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _nokCtrl = TextEditingController();
  final _nokPhoneCtrl = TextEditingController();

  // Controllers — Address
  final _districtCtrl = TextEditingController();
  final _subCountyCtrl = TextEditingController();
  final _parishCtrl = TextEditingController();
  final _villageCtrl = TextEditingController();
  String _region = 'Central';

  // Physical
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _bpCtrl = TextEditingController();
  final _tempCtrl = TextEditingController();
  final _pulseCtrl = TextEditingController();
  final _rrCtrl = TextEditingController();
  final _spo2Ctrl = TextEditingController();
  String _bloodGroup = 'A';
  bool _rhPositive = true;

  // Genetic/Lab
  String _hivStatus = 'Unknown';
  String _sickleCellStatus = 'Unknown';
  String _hepBStatus = 'Unknown';
  String _hepCStatus = 'Unknown';
  String _tbStatus = 'Unknown';

  // Chronic
  final List<Map<String, String>> _chronicConditions = [];
  final _condNameCtrl = TextEditingController();
  final _condYearCtrl = TextEditingController();
  final _condNotesCtrl = TextEditingController();
  final List<String> _commonChronic = [
    'Diabetes Type 1',
    'Diabetes Type 2',
    'Hypertension',
    'Asthma',
    'HIV/AIDS',
    'Tuberculosis',
    'Epilepsy',
    'Sickle Cell Disease',
    'Cancer',
    'Kidney Disease',
    'Heart Disease',
    'Mental Health Disorder',
  ];

  // Allergies
  final List<Map<String, String>> _allergies = [];
  final _allergenCtrl = TextEditingController();
  final _reactionCtrl = TextEditingController();
  String _allergySeverity = 'Moderate';

  // Medications
  final List<Map<String, String>> _medications = [];
  final _medNameCtrl = TextEditingController();
  final _medDoseCtrl = TextEditingController();
  final _medFreqCtrl = TextEditingController();

  // Lifestyle
  String _smoking = 'Never';
  String _alcohol = 'None';
  String _exercise = 'Rarely';
  final _dietCtrl = TextEditingController();

  // Reproductive
  bool _reproApplicable = false;
  final _pregnanciesCtrl = TextEditingController(text: '0');
  final _livebirthsCtrl = TextEditingController(text: '0');
  final _lmpCtrl = TextEditingController();
  String _contraception = 'None';
  bool _onANC = false;

  // Immunizations
  final List<Map<String, String>> _immunizations = [];
  final _vaccineCtrl = TextEditingController();
  final _vaccDateCtrl = TextEditingController();
  final _vaccFacCtrl = TextEditingController();
  final List<String> _commonVaccines = [
    'BCG',
    'OPV (Polio)',
    'DPT-HepB-Hib',
    'Measles',
    'Yellow Fever',
    'Meningococcal',
    'COVID-19 (Pfizer)',
    'COVID-19 (AstraZeneca)',
    'Tetanus Toxoid',
    'HPV',
    'Rotavirus',
    'Pneumococcal',
  ];

  // Disability
  bool _hasDisability = false;
  final _disabilityTypeCtrl = TextEditingController();

  // Insurance
  final _insuranceCtrl = TextEditingController();
  final _insuranceNoCtrl = TextEditingController();
  final _nhifCtrl = TextEditingController();

  // Registered facility
  final _regFacilityCtrl =
      TextEditingController(text: 'Mulago National Referral Hospital');

  double? _calcBMI() {
    final h = double.tryParse(_heightCtrl.text);
    final w = double.tryParse(_weightCtrl.text);
    if (h != null && w != null && h > 0) {
      return w / ((h / 100) * (h / 100));
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields')),
      );
      return;
    }
    final uhn = db.generateUHN();
    final patient = Patient(
      uhn: uhn,
      registrationDate: DateTime.now().toIso8601String().substring(0, 10),
      firstName: _firstNameCtrl.text.trim(),
      middleName: _middleNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      nin: _ninCtrl.text.trim(),
      dateOfBirth: _dob,
      gender: _gender,
      maritalStatus: _maritalStatus,
      tribe: _tribeCtrl.text.trim(),
      religion: _religionCtrl.text.trim(),
      occupation: _occupationCtrl.text.trim(),
      educationLevel: _educationLevel,
      phone: _phoneCtrl.text.trim(),
      altPhone: _altPhoneCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      nextOfKin: _nokCtrl.text.trim(),
      nextOfKinPhone: _nokPhoneCtrl.text.trim(),
      address: Address(
        district: _districtCtrl.text.trim(),
        subCounty: _subCountyCtrl.text.trim(),
        parish: _parishCtrl.text.trim(),
        village: _villageCtrl.text.trim(),
        region: _region,
      ),
      measurements: PhysicalMeasurements()
        ..heightCm = double.tryParse(_heightCtrl.text)
        ..weightKg = double.tryParse(_weightCtrl.text)
        ..bmi = _calcBMI()
        ..bloodPressure = _bpCtrl.text.trim()
        ..bloodGroup = _bloodGroup
        ..rhFactor = _rhPositive
        ..temperature = double.tryParse(_tempCtrl.text)
        ..pulseRate = int.tryParse(_pulseCtrl.text)
        ..respiratoryRate = int.tryParse(_rrCtrl.text)
        ..oxygenSaturation = double.tryParse(_spo2Ctrl.text),
      geneticInfo: GeneticInfo()
        ..hivStatus = _hivStatus
        ..sickleCellStatus = _sickleCellStatus
        ..hepatitisBStatus = _hepBStatus
        ..hepatitisCStatus = _hepCStatus
        ..tbStatus = _tbStatus,
      chronicConditions: _chronicConditions
          .map((c) => ChronicCondition(
                name: c['name']!,
                diagnosedYear: c['year'] ?? '',
                notes: c['notes'] ?? '',
              ))
          .toList(),
      allergies: _allergies
          .map((a) => Allergy(
                allergen: a['allergen']!,
                reaction: a['reaction'] ?? '',
                severity: a['severity'] ?? 'Moderate',
              ))
          .toList(),
      currentMedications: _medications
          .map((m) => Medication(
                name: m['name']!,
                dose: m['dose'] ?? '',
                frequency: m['freq'] ?? '',
              ))
          .toList(),
      smokingStatus: _smoking,
      alcoholUse: _alcohol,
      exerciseFrequency: _exercise,
      dietaryRestrictions: _dietCtrl.text.trim(),
      immunizations: _immunizations
          .map((i) => ImmunizationRecord(
                vaccine: i['vaccine']!,
                date: i['date'] ?? '',
                facility: i['facility'] ?? '',
              ))
          .toList(),
      hasDisability: _hasDisability,
      disabilityType: _disabilityTypeCtrl.text.trim(),
      insuranceProvider: _insuranceCtrl.text.trim(),
      insuranceMemberNo: _insuranceNoCtrl.text.trim(),
      nhifNumber: _nhifCtrl.text.trim(),
      consentGiven: true,
      registeredFacility: _regFacilityCtrl.text.trim(),
      registeredDistrict: _districtCtrl.text.trim(),
    );

    db.addPatient(patient);
    setState(() {
      _submitted = true;
      _generatedUHN = uhn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return _SuccessScreen(
        uhn: _generatedUHN!,
        patientName: '${_firstNameCtrl.text} ${_lastNameCtrl.text}',
        onReset: () => setState(() {
          _submitted = false;
          _currentStep = 0;
        }),
      );
    }

    final steps = [
      _buildPersonalStep(),
      _buildAddressStep(),
      _buildPhysicalStep(),
      _buildGeneticStep(),
      _buildChronicStep(),
      _buildAllergyStep(),
      _buildMedicationStep(),
      _buildLifestyleStep(),
      _buildReproductiveStep(),
      _buildImmunizationStep(),
      _buildDisabilityStep(),
      _buildInsuranceFinalStep(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Register New Patient')),
      backgroundColor: kSurface,
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          type: StepperType.vertical,
          onStepContinue: () {
            if (_currentStep < steps.length - 1) {
              setState(() => _currentStep++);
            } else {
              _submit();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) setState(() => _currentStep--);
          },
          onStepTapped: (i) => setState(() => _currentStep = i),
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(_currentStep == steps.length - 1
                        ? 'Submit & Register'
                        : 'Continue'),
                  ),
                  if (_currentStep > 0) ...[
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                  ],
                ],
              ),
            );
          },
          steps: steps,
        ),
      ),
    );
  }

  Step _buildPersonalStep() => Step(
        title: const Text('Personal Information'),
        subtitle: const Text('Full name, ID, demographics'),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        content: Column(
          children: [
            _row([
              _field(_firstNameCtrl, 'First Name *', required: true),
              _field(_middleNameCtrl, 'Middle Name'),
            ]),
            _field(_lastNameCtrl, 'Last Name *', required: true),
            _field(_ninCtrl, 'National ID Number (NIN)'),
            const SizedBox(height: 8),
            // DOB
            GestureDetector(
              onTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: DateTime(1990),
                  firstDate: DateTime(1920),
                  lastDate: DateTime.now(),
                );
                if (d != null) setState(() => _dob = d);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFCDD9CD)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: kSubText, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      _dob == null
                          ? 'Date of Birth *'
                          : 'DOB: ${_dob!.day}/${_dob!.month}/${_dob!.year}',
                      style: TextStyle(color: _dob == null ? kSubText : kText),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            _dropdown(
                'Gender',
                ['Male', 'Female', 'Other'],
                _gender == Gender.male
                    ? 'Male'
                    : _gender == Gender.female
                        ? 'Female'
                        : 'Other',
                (v) => setState(() => _gender = v == 'Male'
                    ? Gender.male
                    : v == 'Female'
                        ? Gender.female
                        : Gender.other)),
            _dropdown(
                'Marital Status',
                ['Single', 'Married', 'Divorced', 'Widowed', 'Separated'],
                [
                  'Single',
                  'Married',
                  'Divorced',
                  'Widowed',
                  'Separated'
                ][MaritalStatus.values.indexOf(_maritalStatus)],
                (v) => setState(() => _maritalStatus = MaritalStatus.values[[
                      'Single',
                      'Married',
                      'Divorced',
                      'Widowed',
                      'Separated'
                    ].indexOf(v)])),
            _field(_tribeCtrl, 'Tribe/Ethnic Group'),
            _field(_religionCtrl, 'Religion'),
            _field(_occupationCtrl, 'Occupation'),
            _dropdown(
                'Highest Education Level',
                [
                  'None',
                  'Primary',
                  'Secondary',
                  'Vocational',
                  'University',
                  'Postgraduate'
                ],
                _educationLevel,
                (v) => setState(() => _educationLevel = v)),
            _field(_phoneCtrl, 'Primary Phone *',
                required: true, keyboard: TextInputType.phone),
            _field(_altPhoneCtrl, 'Alternative Phone',
                keyboard: TextInputType.phone),
            _field(_emailCtrl, 'Email Address',
                keyboard: TextInputType.emailAddress),
            _field(_nokCtrl, 'Next of Kin Name *', required: true),
            _field(_nokPhoneCtrl, 'Next of Kin Phone *',
                required: true, keyboard: TextInputType.phone),
          ],
        ),
      );

  Step _buildAddressStep() => Step(
        title: const Text('Residential Address'),
        subtitle: const Text('District, sub-county, village'),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        content: Column(
          children: [
            _dropdown('Region', ['Central', 'Eastern', 'Northern', 'Western'],
                _region, (v) => setState(() => _region = v)),
            _field(_districtCtrl, 'District *', required: true),
            _field(_subCountyCtrl, 'Sub-County'),
            _field(_parishCtrl, 'Parish'),
            _field(_villageCtrl, 'Village / Cell'),
          ],
        ),
      );

  Step _buildPhysicalStep() => Step(
        title: const Text('Physical Measurements & Vitals'),
        subtitle: const Text('Height, weight, blood pressure, blood group'),
        isActive: _currentStep >= 2,
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
        content: Column(
          children: [
            _row([
              _field(_heightCtrl, 'Height (cm)',
                  keyboard: TextInputType.number),
              _field(_weightCtrl, 'Weight (kg)',
                  keyboard: TextInputType.number),
            ]),
            if (_calcBMI() != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  label: Text('BMI: ${_calcBMI()!.toStringAsFixed(1)}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  backgroundColor: kPrimary.withOpacity(0.1),
                ),
              ),
            _field(_bpCtrl, 'Blood Pressure (e.g. 120/80)'),
            _field(_tempCtrl, 'Temperature (°C)',
                keyboard: TextInputType.number),
            _row([
              _field(_pulseCtrl, 'Pulse (bpm)', keyboard: TextInputType.number),
              _field(_rrCtrl, 'Resp. Rate (/min)',
                  keyboard: TextInputType.number),
            ]),
            _field(_spo2Ctrl, 'SpO2 (%)', keyboard: TextInputType.number),
            _dropdown('Blood Group', ['A', 'B', 'AB', 'O', 'Unknown'],
                _bloodGroup, (v) => setState(() => _bloodGroup = v)),
            _dropdown(
                'Rhesus Factor',
                ['Positive (+)', 'Negative (-)'],
                _rhPositive ? 'Positive (+)' : 'Negative (-)',
                (v) => setState(() => _rhPositive = v == 'Positive (+)')),
          ],
        ),
      );

  Step _buildGeneticStep() => Step(
        title: const Text('Lab & Genetic Information'),
        subtitle: const Text('HIV, Sickle cell, Hepatitis, TB status'),
        isActive: _currentStep >= 3,
        state: _currentStep > 3 ? StepState.complete : StepState.indexed,
        content: Column(
          children: [
            const Text('Provide known results. Select "Unknown" if not tested.',
                style: TextStyle(color: kSubText, fontSize: 13)),
            const SizedBox(height: 8),
            _dropdown(
                'HIV Status',
                [
                  'Unknown',
                  'Negative',
                  'Positive - On ART',
                  'Positive - Not on ART'
                ],
                _hivStatus,
                (v) => setState(() => _hivStatus = v)),
            _dropdown(
                'Sickle Cell Status',
                ['Unknown', 'Negative', 'Carrier (AS)', 'Positive (SS)'],
                _sickleCellStatus,
                (v) => setState(() => _sickleCellStatus = v)),
            _dropdown(
                'Hepatitis B Status',
                [
                  'Unknown',
                  'Negative',
                  'Chronic carrier',
                  'Acute',
                  'Vaccinated'
                ],
                _hepBStatus,
                (v) => setState(() => _hepBStatus = v)),
            _dropdown('Hepatitis C Status', ['Unknown', 'Negative', 'Positive'],
                _hepCStatus, (v) => setState(() => _hepCStatus = v)),
            _dropdown(
                'TB Status',
                [
                  'Unknown',
                  'Never',
                  'Past infection (treated)',
                  'Active TB',
                  'MDR-TB'
                ],
                _tbStatus,
                (v) => setState(() => _tbStatus = v)),
          ],
        ),
      );

  Step _buildChronicStep() => Step(
        title: const Text('Chronic Conditions'),
        subtitle: Text('${_chronicConditions.length} condition(s) added'),
        isActive: _currentStep >= 4,
        state: _currentStep > 4 ? StepState.complete : StepState.indexed,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select from common conditions or type a custom one:',
                style: TextStyle(color: kSubText, fontSize: 13)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _commonChronic.map((c) {
                final added = _chronicConditions.any((x) => x['name'] == c);
                return FilterChip(
                  label: Text(c,
                      style: TextStyle(
                          fontSize: 12,
                          color: added ? Colors.white : kPrimary)),
                  selected: added,
                  selectedColor: kPrimary,
                  onSelected: (sel) {
                    setState(() {
                      if (sel) {
                        _chronicConditions
                            .add({'name': c, 'year': '', 'notes': ''});
                      } else {
                        _chronicConditions.removeWhere((x) => x['name'] == c);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            // Custom condition
            Row(
              children: [
                Expanded(child: _field(_condNameCtrl, 'Custom condition name')),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_condNameCtrl.text.isNotEmpty) {
                      setState(() {
                        _chronicConditions.add({
                          'name': _condNameCtrl.text,
                          'year': _condYearCtrl.text,
                          'notes': _condNotesCtrl.text,
                        });
                        _condNameCtrl.clear();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16)),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            if (_chronicConditions.isNotEmpty) ...[
              const SizedBox(height: 8),
              ..._chronicConditions.map((c) => ListTile(
                    dense: true,
                    leading: const Icon(Icons.medical_services,
                        color: kPrimary, size: 18),
                    title: Text(c['name']!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13)),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_circle,
                          color: kRed, size: 18),
                      onPressed: () =>
                          setState(() => _chronicConditions.remove(c)),
                    ),
                  )),
            ],
          ],
        ),
      );

  Step _buildAllergyStep() => Step(
        title: const Text('Allergies'),
        subtitle: Text('${_allergies.length} allergy(s) recorded'),
        isActive: _currentStep >= 5,
        state: _currentStep > 5 ? StepState.complete : StepState.indexed,
        content: Column(
          children: [
            _field(_allergenCtrl, 'Allergen (e.g. Penicillin, Peanuts)'),
            _field(_reactionCtrl, 'Reaction / Symptom'),
            _dropdown(
                'Severity',
                ['Mild', 'Moderate', 'Severe', 'Life-threatening'],
                _allergySeverity,
                (v) => setState(() => _allergySeverity = v)),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                if (_allergenCtrl.text.isNotEmpty) {
                  setState(() {
                    _allergies.add({
                      'allergen': _allergenCtrl.text,
                      'reaction': _reactionCtrl.text,
                      'severity': _allergySeverity,
                    });
                    _allergenCtrl.clear();
                    _reactionCtrl.clear();
                  });
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Allergy'),
            ),
            ..._allergies.map((a) => ListTile(
                  dense: true,
                  leading: const Icon(Icons.warning_amber,
                      color: Colors.orange, size: 18),
                  title: Text('${a['allergen']} (${a['severity']})',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: Text(a['reaction'] ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: kRed, size: 18),
                    onPressed: () => setState(() => _allergies.remove(a)),
                  ),
                )),
          ],
        ),
      );

  Step _buildMedicationStep() => Step(
        title: const Text('Current Medications'),
        subtitle: Text('${_medications.length} medication(s)'),
        isActive: _currentStep >= 6,
        state: _currentStep > 6 ? StepState.complete : StepState.indexed,
        content: Column(
          children: [
            _field(_medNameCtrl, 'Medication Name'),
            _row([
              _field(_medDoseCtrl, 'Dose (e.g. 500mg)'),
              _field(_medFreqCtrl, 'Frequency (e.g. BD)'),
            ]),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                if (_medNameCtrl.text.isNotEmpty) {
                  setState(() {
                    _medications.add({
                      'name': _medNameCtrl.text,
                      'dose': _medDoseCtrl.text,
                      'freq': _medFreqCtrl.text,
                    });
                    _medNameCtrl.clear();
                    _medDoseCtrl.clear();
                    _medFreqCtrl.clear();
                  });
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Medication'),
            ),
            ..._medications.map((m) => ListTile(
                  dense: true,
                  leading:
                      const Icon(Icons.medication, color: kPrimary, size: 18),
                  title: Text(m['name']!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                  subtitle: Text('${m['dose']} — ${m['freq']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: kRed, size: 18),
                    onPressed: () => setState(() => _medications.remove(m)),
                  ),
                )),
          ],
        ),
      );

  Step _buildLifestyleStep() => Step(
        title: const Text('Lifestyle'),
        subtitle: const Text('Smoking, alcohol, exercise, diet'),
        isActive: _currentStep >= 7,
        state: _currentStep > 7 ? StepState.complete : StepState.indexed,
        content: Column(
          children: [
            _dropdown(
                'Smoking Status',
                ['Never', 'Ex-smoker', 'Occasional', 'Regular'],
                _smoking,
                (v) => setState(() => _smoking = v)),
            _dropdown('Alcohol Use', ['None', 'Occasional', 'Regular', 'Heavy'],
                _alcohol, (v) => setState(() => _alcohol = v)),
            _dropdown(
                'Exercise Frequency',
                ['Never', 'Rarely', '1-2x per week', '3x per week', 'Daily'],
                _exercise,
                (v) => setState(() => _exercise = v)),
            _field(_dietCtrl, 'Dietary Restrictions or Notes'),
          ],
        ),
      );

  Step _buildReproductiveStep() => Step(
        title: const Text('Reproductive Health'),
        subtitle: const Text('Applicable for female patients'),
        isActive: _currentStep >= 8,
        state: _currentStep > 8 ? StepState.complete : StepState.indexed,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Reproductive history applicable'),
              value: _reproApplicable,
              activeColor: kPrimary,
              onChanged: (v) => setState(() => _reproApplicable = v),
            ),
            if (_reproApplicable) ...[
              _row([
                _field(_pregnanciesCtrl, 'No. of Pregnancies',
                    keyboard: TextInputType.number),
                _field(_livebirthsCtrl, 'Live Births',
                    keyboard: TextInputType.number),
              ]),
              _field(_lmpCtrl, 'Last Menstrual Period (date)'),
              _dropdown(
                  'Contraception Method',
                  [
                    'None',
                    'Oral pills',
                    'DMPA injection',
                    'Implant',
                    'IUD',
                    'Condom',
                    'Natural',
                    'Sterilisation'
                  ],
                  _contraception,
                  (v) => setState(() => _contraception = v)),
              SwitchListTile(
                title: const Text('Currently on Antenatal Care (ANC)'),
                value: _onANC,
                activeColor: kPrimary,
                onChanged: (v) => setState(() => _onANC = v),
              ),
            ],
          ],
        ),
      );

  Step _buildImmunizationStep() => Step(
        title: const Text('Immunization Records'),
        subtitle: Text('${_immunizations.length} vaccine(s) recorded'),
        isActive: _currentStep >= 9,
        state: _currentStep > 9 ? StepState.complete : StepState.indexed,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tap vaccines received:',
                style: TextStyle(color: kSubText, fontSize: 13)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _commonVaccines.map((v) {
                final added = _immunizations.any((i) => i['vaccine'] == v);
                return FilterChip(
                  label: Text(v,
                      style: TextStyle(
                          fontSize: 11,
                          color: added ? Colors.white : kPrimary)),
                  selected: added,
                  selectedColor: kPrimary,
                  onSelected: (sel) {
                    setState(() {
                      if (sel) {
                        _immunizations
                            .add({'vaccine': v, 'date': '', 'facility': ''});
                      } else {
                        _immunizations.removeWhere((i) => i['vaccine'] == v);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _field(_vaccineCtrl, 'Other vaccine')),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_vaccineCtrl.text.isNotEmpty) {
                      setState(() {
                        _immunizations.add({
                          'vaccine': _vaccineCtrl.text,
                          'date': _vaccDateCtrl.text,
                          'facility': _vaccFacCtrl.text
                        });
                        _vaccineCtrl.clear();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16)),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      );

  Step _buildDisabilityStep() => Step(
        title: const Text('Disability & Special Needs'),
        isActive: _currentStep >= 10,
        state: _currentStep > 10 ? StepState.complete : StepState.indexed,
        content: Column(
          children: [
            SwitchListTile(
              title: const Text('Patient has a disability'),
              value: _hasDisability,
              activeColor: kPrimary,
              onChanged: (v) => setState(() => _hasDisability = v),
            ),
            if (_hasDisability)
              _dropdown(
                  'Disability Type',
                  [
                    'Physical/Mobility',
                    'Visual',
                    'Hearing',
                    'Speech',
                    'Intellectual',
                    'Psychosocial',
                    'Multiple',
                    'Other'
                  ],
                  _disabilityTypeCtrl.text.isEmpty
                      ? 'Physical/Mobility'
                      : _disabilityTypeCtrl.text, (v) {
                setState(() => _disabilityTypeCtrl.text = v);
              }),
          ],
        ),
      );

  Step _buildInsuranceFinalStep() => Step(
        title: const Text('Insurance & Consent'),
        subtitle: const Text('NHIF, insurance, data consent'),
        isActive: _currentStep >= 11,
        state: _currentStep > 11 ? StepState.complete : StepState.indexed,
        content: Column(
          children: [
            _field(_nhifCtrl, 'NHIF Number'),
            _field(_insuranceCtrl, 'Insurance Provider'),
            _field(_insuranceNoCtrl, 'Insurance Member Number'),
            const Divider(height: 24),
            _field(_regFacilityCtrl, 'Registering Facility *', required: true),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: kPrimary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kPrimary.withOpacity(0.2)),
              ),
              child: const Text(
                '✅ By submitting, the patient consents to their health data being stored in the UgandaCare National EHR System and accessed by authorised health facilities across Uganda for the purpose of healthcare provision.',
                style: TextStyle(fontSize: 12, color: kText),
              ),
            ),
          ],
        ),
      );

  Widget _field(TextEditingController ctrl, String label,
      {bool required = false, TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboard,
        decoration: InputDecoration(labelText: label),
        validator: required
            ? (v) => (v == null || v.isEmpty) ? '$label is required' : null
            : null,
      ),
    );
  }

  Widget _row(List<Widget> children) {
    return Row(
      children: children
          .map((w) => Expanded(
              child:
                  Padding(padding: const EdgeInsets.only(right: 6), child: w)))
          .toList(),
    );
  }

  Widget _dropdown(String label, List<String> options, String value,
      Function(String) onChanged) {
    final safeValue = options.contains(value) ? value : options.first;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        value: safeValue,
        decoration: InputDecoration(labelText: label),
        items: options
            .map((o) => DropdownMenuItem(
                value: o, child: Text(o, style: const TextStyle(fontSize: 14))))
            .toList(),
        onChanged: (v) => onChanged(v!),
      ),
    );
  }
}

class _SuccessScreen extends StatelessWidget {
  final String uhn;
  final String patientName;
  final VoidCallback onReset;
  const _SuccessScreen(
      {required this.uhn, required this.patientName, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSurface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                    color: kPrimary, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 24),
              const Text('Patient Registered!',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: kPrimary)),
              const SizedBox(height: 8),
              Text(patientName,
                  style: const TextStyle(fontSize: 18, color: kText)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: kAccent, width: 2),
                ),
                child: Column(
                  children: [
                    const Text('UGANDA HEALTH NUMBER',
                        style: TextStyle(
                            fontSize: 12, color: kSubText, letterSpacing: 1)),
                    const SizedBox(height: 6),
                    Text(uhn,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: kPrimary,
                            letterSpacing: 2)),
                    const SizedBox(height: 6),
                    const Text(
                        'This number is valid across all Uganda health facilities',
                        style: TextStyle(fontSize: 11, color: kSubText)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onReset,
                icon: const Icon(Icons.person_add),
                label: const Text('Register Another Patient'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  final patient = EhrDatabase().findByUHN(uhn);
                  if (patient != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => PatientProfileScreen(patient: patient),
                    ));
                  }
                },
                child: const Text('View Patient Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// FIND PATIENT
// ─────────────────────────────────────────────────────────────
class FindPatientScreen extends StatefulWidget {
  const FindPatientScreen({super.key});

  @override
  State<FindPatientScreen> createState() => _FindPatientScreenState();
}

class _FindPatientScreenState extends State<FindPatientScreen> {
  final _searchCtrl = TextEditingController();
  final db = EhrDatabase();
  List<Patient> _results = [];
  bool _searched = false;

  void _search() {
    setState(() {
      _results = db.search(_searchCtrl.text);
      _searched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find Patient')),
      backgroundColor: kSurface,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Search by UHN, Full Name, NIN or Phone',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: kText)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _searchCtrl,
                            onFieldSubmitted: (_) => _search(),
                            decoration: InputDecoration(
                              hintText: 'e.g. UHN-2026-001001 or Akello',
                              prefixIcon:
                                  const Icon(Icons.search, color: kPrimary),
                              suffixIcon: _searchCtrl.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchCtrl.clear();
                                        setState(() => _searched = false);
                                      })
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                            onPressed: _search, child: const Text('Search')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_searched && _results.isEmpty)
              const Card(
                  child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(
                          child: Text(
                              'No patient found. Check the UHN or register a new patient.',
                              textAlign: TextAlign.center)))),
            Expanded(
              child: ListView(
                children: (!_searched ? db.patients : _results)
                    .map((p) => Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: kPrimary.withOpacity(0.12),
                              radius: 22,
                              child: Text(p.firstName[0],
                                  style: const TextStyle(
                                      color: kPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ),
                            title: Text(p.fullName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 15)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.uhn,
                                    style: const TextStyle(
                                        color: kPrimary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600)),
                                Text(
                                    '${p.ageYears != null ? "${p.ageYears}yrs" : ""} • ${p.address.district} District • ${p.phone}',
                                    style: const TextStyle(
                                        fontSize: 12, color: kSubText)),
                              ],
                            ),
                            isThreeLine: true,
                            trailing: const Icon(Icons.chevron_right,
                                color: kPrimary),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) =>
                                      PatientProfileScreen(patient: p)),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// PATIENT PROFILE
// ─────────────────────────────────────────────────────────────
class PatientProfileScreen extends StatefulWidget {
  final Patient patient;
  const PatientProfileScreen({super.key, required this.patient});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.patient;
    return Scaffold(
      backgroundColor: kSurface,
      body: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: kPrimary,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [kPrimary, Color(0xFF004D2C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 80, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: kAccent,
                            child: Text(p.firstName[0],
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: kPrimary)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.fullName,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                      color: kAccent,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Text(p.uhn,
                                      style: const TextStyle(
                                          color: kPrimary,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 13,
                                          letterSpacing: 1)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${p.ageYears != null ? "${p.ageYears} yrs" : "Age N/A"} • ${p.gender == Gender.male ? "Male" : p.gender == Gender.female ? "Female" : "Other"} • ${p.address.district}',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabCtrl,
              indicatorColor: kAccent,
              labelColor: kAccent,
              unselectedLabelColor: Colors.white70,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Medical'),
                Tab(text: 'Visits'),
                Tab(text: 'Labs & Meds'),
                Tab(text: 'Add Visit'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabCtrl,
          children: [
            _OverviewTab(patient: p),
            _MedicalTab(patient: p),
            _VisitsTab(patient: p),
            _LabsMedsTab(patient: p),
            _AddVisitTab(patient: p, onAdded: () => setState(() {})),
          ],
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  final Patient patient;
  const _OverviewTab({required this.patient});

  @override
  Widget build(BuildContext context) {
    final p = patient;
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        // Alert chips
        if (p.allergies.isNotEmpty)
          _AlertChip(
              '⚠️ ALLERGY: ${p.allergies.map((a) => a.allergen).join(", ")}',
              kRed),
        if (p.chronicConditions.isNotEmpty)
          _AlertChip(
              '🏥 CHRONIC: ${p.chronicConditions.map((c) => c.name).join(", ")}',
              const Color(0xFF6A1B9A)),

        _SectionCard('Personal Details', [
          _row2('NIN', p.nin.isEmpty ? 'Not provided' : p.nin),
          _row2(
              'Date of Birth',
              p.dateOfBirth != null
                  ? '${p.dateOfBirth!.day}/${p.dateOfBirth!.month}/${p.dateOfBirth!.year}'
                  : 'N/A'),
          _row2('Age', p.ageYears != null ? '${p.ageYears} years' : 'N/A'),
          _row2('Tribe', p.tribe.isEmpty ? '—' : p.tribe),
          _row2('Religion', p.religion.isEmpty ? '—' : p.religion),
          _row2('Occupation', p.occupation.isEmpty ? '—' : p.occupation),
          _row2('Education', p.educationLevel),
          _row2('Marital Status', p.maritalStatus.name),
        ]),
        _SectionCard('Contact & Address', [
          _row2('Phone', p.phone),
          _row2('Alt Phone', p.altPhone.isEmpty ? '—' : p.altPhone),
          _row2('Email', p.email.isEmpty ? '—' : p.email),
          _row2('Next of Kin', '${p.nextOfKin} (${p.nextOfKinPhone})'),
          _row2('Region', p.address.region),
          _row2('District', p.address.district),
          _row2('Sub-County',
              p.address.subCounty.isEmpty ? '—' : p.address.subCounty),
          _row2('Village', p.address.village.isEmpty ? '—' : p.address.village),
        ]),
        _SectionCard('Insurance', [
          _row2('NHIF No.',
              p.nhifNumber.isEmpty ? 'Not registered' : p.nhifNumber),
          _row2('Insurance',
              p.insuranceProvider.isEmpty ? 'None' : p.insuranceProvider),
          _row2('Member No.',
              p.insuranceMemberNo.isEmpty ? '—' : p.insuranceMemberNo),
        ]),
        _SectionCard('Registered At', [
          _row2('Facility',
              p.registeredFacility.isEmpty ? '—' : p.registeredFacility),
          _row2('District',
              p.registeredDistrict.isEmpty ? '—' : p.registeredDistrict),
          _row2('Date', p.registrationDate),
        ]),
      ],
    );
  }
}

class _AlertChip extends StatelessWidget {
  final String text;
  final Color color;
  const _AlertChip(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(text,
          style: TextStyle(
              color: color, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> rows;
  const _SectionCard(this.title, this.rows);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: kPrimary)),
            const Divider(height: 14),
            ...rows,
          ],
        ),
      ),
    );
  }
}

Widget _row2(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 120,
            child: Text(label,
                style: const TextStyle(color: kSubText, fontSize: 12))),
        Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13, color: kText))),
      ],
    ),
  );
}

class _MedicalTab extends StatelessWidget {
  final Patient patient;
  const _MedicalTab({required this.patient});

  @override
  Widget build(BuildContext context) {
    final p = patient;
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _SectionCard('Physical Measurements', [
          _row2(
              'Height',
              p.measurements.heightCm != null
                  ? '${p.measurements.heightCm} cm'
                  : 'N/A'),
          _row2(
              'Weight',
              p.measurements.weightKg != null
                  ? '${p.measurements.weightKg} kg'
                  : 'N/A'),
          _row2(
              'BMI',
              p.measurements.bmi != null
                  ? p.measurements.bmi!.toStringAsFixed(1)
                  : 'N/A'),
          _row2(
              'Blood Pressure',
              p.measurements.bloodPressure?.isEmpty ?? true
                  ? 'N/A'
                  : p.measurements.bloodPressure!),
          _row2('Blood Group',
              '${p.measurements.bloodGroup ?? "Unknown"} ${p.measurements.rhFactor ? "(+)" : "(-)"}'),
        ]),
        _SectionCard('Genetic & Lab Status', [
          _row2('HIV', p.geneticInfo.hivStatus),
          _row2('Sickle Cell', p.geneticInfo.sickleCellStatus),
          _row2('Hepatitis B', p.geneticInfo.hepatitisBStatus),
          _row2('Hepatitis C', p.geneticInfo.hepatitisCStatus),
          _row2('TB Status', p.geneticInfo.tbStatus),
        ]),
        if (p.chronicConditions.isNotEmpty)
          _SectionCard(
              'Chronic Conditions',
              p.chronicConditions
                  .map(
                    (c) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.medical_services,
                              color: kPrimary, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(c.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600))),
                          if (c.diagnosedYear.isNotEmpty)
                            Text('Since ${c.diagnosedYear}',
                                style: const TextStyle(
                                    color: kSubText, fontSize: 12)),
                        ],
                      ),
                    ),
                  )
                  .toList()),
        _SectionCard('Lifestyle', [
          _row2('Smoking', p.smokingStatus),
          _row2('Alcohol', p.alcoholUse),
          _row2('Exercise', p.exerciseFrequency),
          _row2('Diet Notes',
              p.dietaryRestrictions.isEmpty ? 'None' : p.dietaryRestrictions),
        ]),
        if (p.immunizations.isNotEmpty)
          _SectionCard(
              'Immunizations',
              p.immunizations
                  .map(
                    (i) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          const Icon(Icons.vaccines,
                              color: Colors.teal, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(i.vaccine,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13))),
                          Text(i.date,
                              style: const TextStyle(
                                  color: kSubText, fontSize: 12)),
                        ],
                      ),
                    ),
                  )
                  .toList()),
      ],
    );
  }
}

class _VisitsTab extends StatelessWidget {
  final Patient patient;
  const _VisitsTab({required this.patient});

  @override
  Widget build(BuildContext context) {
    final visits = patient.visits.reversed.toList();
    if (visits.isEmpty) {
      return const Center(
          child:
              Text('No visit records yet', style: TextStyle(color: kSubText)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: visits.length,
      itemBuilder: (context, i) {
        final v = visits[i];
        final Color levelColor = v.accessedBy == AccessLevel.ministryOfHealth
            ? kRed
            : v.accessedBy == AccessLevel.regionalHospital
                ? Colors.orange
                : v.accessedBy == AccessLevel.clinic
                    ? kPrimary
                    : Colors.blue;
        return Card(
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: levelColor.withOpacity(0.15),
              radius: 20,
              child: Icon(Icons.local_hospital, color: levelColor, size: 18),
            ),
            title: Text(v.facilityName,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            subtitle: Text(
              '${v.date.day}/${v.date.month}/${v.date.year} • ${v.facilityDistrict}',
              style: const TextStyle(fontSize: 12),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  children: [
                    _row2('Clinician', v.clinicianName),
                    _row2('Complaint', v.chiefComplaint),
                    _row2('Diagnosis', '${v.diagnosis} (${v.icd10Code})'),
                    _row2('Treatment', v.treatment),
                    _row2('Prescription', v.prescription),
                    if (v.referredTo.isNotEmpty)
                      _row2('Referred to', v.referredTo),
                    _row2('Access Level', v.accessedBy.name),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LabsMedsTab extends StatelessWidget {
  final Patient patient;
  const _LabsMedsTab({required this.patient});

  @override
  Widget build(BuildContext context) {
    final p = patient;
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        if (p.allergies.isNotEmpty)
          _SectionCard(
              'Known Allergies',
              p.allergies
                  .map(
                    (a) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber,
                              color: a.severity == 'Severe' ||
                                      a.severity == 'Life-threatening'
                                  ? kRed
                                  : Colors.orange,
                              size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(a.allergen,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13)),
                              Text('${a.reaction} — ${a.severity}',
                                  style: const TextStyle(
                                      fontSize: 12, color: kSubText)),
                            ],
                          )),
                        ],
                      ),
                    ),
                  )
                  .toList()),
        if (p.currentMedications.isNotEmpty)
          _SectionCard(
              'Current Medications',
              p.currentMedications
                  .map(
                    (m) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.medication,
                              color: kPrimary, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13)),
                              Text('${m.dose} — ${m.frequency}',
                                  style: const TextStyle(
                                      fontSize: 12, color: kSubText)),
                            ],
                          )),
                        ],
                      ),
                    ),
                  )
                  .toList()),
        if (p.allergies.isEmpty && p.currentMedications.isEmpty)
          const Card(
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                      child: Text('No medications or allergies recorded',
                          style: TextStyle(color: kSubText))))),
      ],
    );
  }
}

class _AddVisitTab extends StatefulWidget {
  final Patient patient;
  final VoidCallback onAdded;
  const _AddVisitTab({required this.patient, required this.onAdded});

  @override
  State<_AddVisitTab> createState() => _AddVisitTabState();
}

class _AddVisitTabState extends State<_AddVisitTab> {
  final db = EhrDatabase();
  final _complaintCtrl = TextEditingController();
  final _diagnosisCtrl = TextEditingController();
  final _icd10Ctrl = TextEditingController();
  final _treatmentCtrl = TextEditingController();
  final _prescriptionCtrl = TextEditingController();
  final _referredCtrl = TextEditingController();
  final _clinicianCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    if (_saved) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: kPrimary, size: 60),
            const SizedBox(height: 12),
            const Text('Visit Recorded',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: kPrimary)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => setState(() => _saved = false),
              child: const Text('Add Another Visit'),
            ),
          ],
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recording visit for: ${widget.patient.fullName}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: kPrimary,
                        fontSize: 15)),
                Text('UHN: ${widget.patient.uhn}',
                    style: const TextStyle(fontSize: 12, color: kSubText)),
                const Divider(height: 16),
                _f(_clinicianCtrl, 'Attending Clinician / Doctor *'),
                _f(_complaintCtrl, 'Chief Complaint *'),
                _f(_diagnosisCtrl, 'Diagnosis *'),
                _f(_icd10Ctrl, 'ICD-10 Code (e.g. J06.9)'),
                _f(_treatmentCtrl, 'Treatment / Management'),
                _f(_prescriptionCtrl, 'Prescription'),
                _f(_referredCtrl, 'Referred to (leave blank if none)'),
                _f(_notesCtrl, 'Additional Notes', maxLines: 3),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_complaintCtrl.text.isEmpty ||
                          _diagnosisCtrl.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Chief complaint and diagnosis are required')),
                        );
                        return;
                      }
                      final visit = ClinicalVisit(
                        visitId: 'V-${DateTime.now().millisecondsSinceEpoch}',
                        date: DateTime.now(),
                        facilityName: db.currentFacility,
                        facilityDistrict: db.currentDistrict,
                        clinicianName: _clinicianCtrl.text.trim(),
                        chiefComplaint: _complaintCtrl.text.trim(),
                        diagnosis: _diagnosisCtrl.text.trim(),
                        icd10Code: _icd10Ctrl.text.trim(),
                        treatment: _treatmentCtrl.text.trim(),
                        prescription: _prescriptionCtrl.text.trim(),
                        referredTo: _referredCtrl.text.trim(),
                        notes: _notesCtrl.text.trim(),
                        accessedBy: db.currentUserLevel,
                      );
                      db.addVisit(widget.patient.uhn, visit);
                      widget.onAdded();
                      setState(() => _saved = true);
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Save Visit Record'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _f(TextEditingController c, String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: c,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ANALYTICS SCREEN
// ─────────────────────────────────────────────────────────────
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('National Health Analytics')),
      backgroundColor: kSurface,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard('Top 10 Disease Burden (ICD-10)', [
            ...[
              ['Malaria (B54)', '28,430', 0.85],
              ['Hypertension (I10)', '15,200', 0.62],
              ['HIV/AIDS (B20)', '12,840', 0.54],
              ['Diabetes Mellitus (E11)', '9,100', 0.41],
              ['Pneumonia (J18)', '8,760', 0.39],
              ['TB (A15)', '6,320', 0.29],
              ['Diarrhoeal Disease (A09)', '5,890', 0.27],
              ['Malnutrition (E46)', '4,300', 0.20],
              ['Neonatal conditions (P96)', '3,200', 0.16],
              ['Cholera (A00)', '1,100', 0.08],
            ].map((d) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(d[0] as String,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600)),
                          Text(d[1] as String,
                              style: const TextStyle(
                                  fontSize: 12, color: kSubText)),
                        ],
                      ),
                      const SizedBox(height: 3),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                            value: d[2] as double,
                            minHeight: 7,
                            color: kPrimary,
                            backgroundColor: Colors.grey[200]),
                      ),
                    ],
                  ),
                )),
          ]),
          _SectionCard('Active Outbreak Alerts', [
            _outbreakRow(
                '🔴', 'Cholera', 'Moroto District', '12 cases', 'CRITICAL'),
            _outbreakRow(
                '🟠', 'Malaria Surge', 'Arua District', '+34%', 'HIGH'),
            _outbreakRow('🟡', 'Measles Cluster', 'Kabale District', '8 cases',
                'MODERATE'),
          ]),
          _SectionCard('Vaccination Coverage by District', [
            ...[
              ['Kampala', 0.92],
              ['Gulu', 0.76],
              ['Mbarara', 0.81],
              ['Mbale', 0.68],
              ['Arua', 0.55],
              ['Moroto', 0.41],
            ].map((d) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      SizedBox(
                          width: 90,
                          child: Text(d[0] as String,
                              style: const TextStyle(fontSize: 12))),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: d[1] as double,
                            minHeight: 10,
                            color: (d[1] as double) > 0.7
                                ? kPrimary
                                : (d[1] as double) > 0.5
                                    ? Colors.orange
                                    : kRed,
                            backgroundColor: Colors.grey[200],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${((d[1] as double) * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )),
          ]),
          _SectionCard('System Stats', [
            _row2('Total Citizens Registered', '2,398'),
            _row2('Facilities Using System', '47'),
            _row2('Districts Covered', '22 of 146'),
            _row2('Records Accessed Today', '1,204'),
            _row2('Cross-district Lookups', '89'),
            _row2('Referrals This Month', '342'),
          ]),
        ],
      ),
    );
  }

  Widget _outbreakRow(String emoji, String disease, String district,
      String count, String severity) {
    final Color color = severity == 'CRITICAL'
        ? kRed
        : severity == 'HIGH'
            ? Colors.orange
            : Colors.amber;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(disease,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 13)),
              Text('$district • $count',
                  style: const TextStyle(fontSize: 12, color: kSubText)),
            ],
          )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8)),
            child: Text(severity,
                style: TextStyle(
                    color: color, fontSize: 10, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ACCESS & AUDIT SCREEN
// ─────────────────────────────────────────────────────────────
class AccessAuditScreen extends StatefulWidget {
  const AccessAuditScreen({super.key});

  @override
  State<AccessAuditScreen> createState() => _AccessAuditScreenState();
}

class _AccessAuditScreenState extends State<AccessAuditScreen> {
  final db = EhrDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Access Control & Audit')),
      backgroundColor: kSurface,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Simulate level
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Simulate Access Level',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: kPrimary,
                          fontSize: 15)),
                  const SizedBox(height: 8),
                  const Text('Switch roles to test what each level can see:',
                      style: TextStyle(fontSize: 12, color: kSubText)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: AccessLevel.values.map((level) {
                      final selected = db.currentUserLevel == level;
                      return ChoiceChip(
                        label: Text(_levelName(level),
                            style: TextStyle(
                                color: selected ? Colors.white : kPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                        selected: selected,
                        selectedColor: _levelColor(level),
                        onSelected: (_) =>
                            setState(() => db.currentUserLevel = level),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Access level matrix
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Permission Matrix',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: kPrimary,
                          fontSize: 15)),
                  const SizedBox(height: 10),
                  _permRow('Patient', [true, false, false, false],
                      'Own records only'),
                  _permRow('Clinic', [true, true, false, false],
                      'Their patients + registered facility'),
                  _permRow('Regional Hospital', [true, true, true, false],
                      'All patients in region'),
                  _permRow('Ministry of Health', [true, true, true, true],
                      'Full national access + analytics'),
                ],
              ),
            ),
          ),

          // Access rules by level
          ...[
            _AccessLevelCard(
              level: AccessLevel.patient,
              color: Colors.blue,
              permissions: [
                'View own medical history',
                'See own visit records',
                'Update contact info',
                'View own lab results'
              ],
              restrictions: [
                'Cannot see other patients',
                'Cannot edit clinical records',
                'Cannot see analytics'
              ],
            ),
            _AccessLevelCard(
              level: AccessLevel.clinic,
              color: kPrimary,
              permissions: [
                'Register new patients',
                'Record clinical visits',
                'Search any patient by UHN',
                'View full patient history',
                'Add prescriptions'
              ],
              restrictions: [
                'Cannot access MOH analytics',
                'Cannot change access policies'
              ],
            ),
            _AccessLevelCard(
              level: AccessLevel.regionalHospital,
              color: Colors.orange,
              permissions: [
                'All clinic permissions',
                'View regional disease stats',
                'Issue referrals',
                'Access regional audit logs'
              ],
              restrictions: ['Cannot modify national policies'],
            ),
            _AccessLevelCard(
              level: AccessLevel.ministryOfHealth,
              color: kRed,
              permissions: [
                'Full national data access',
                'Disease surveillance',
                'Policy configuration',
                'Facility management',
                'National audit logs',
                'Export data'
              ],
              restrictions: [],
            ),
          ],

          // Audit log
          const SizedBox(height: 8),
          const Text('Recent Audit Log',
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700, color: kText)),
          const SizedBox(height: 8),
          ...[
            [
              'Mulago NRH',
              'UHN-2026-001001',
              'Akello Opio',
              'Viewed full profile',
              'Regional',
              '18/03/2026 09:14'
            ],
            [
              'Gulu RRH',
              'UHN-2026-001001',
              'Akello Opio',
              'Added visit record',
              'Clinic',
              '05/03/2026 14:30'
            ],
            [
              'Nansana HC IV',
              'UHN-2026-001002',
              'Ssemakula Ronald',
              'Added visit record',
              'Clinic',
              '14/02/2026 10:05'
            ],
            [
              'MOH Kampala',
              'ALL',
              'ALL',
              'Analytics dashboard viewed',
              'MOH',
              '17/03/2026 16:00'
            ],
          ].map((row) => Card(
                child: ListTile(
                  dense: true,
                  leading:
                      const Icon(Icons.security, color: kPrimary, size: 18),
                  title: Text('${row[0]} accessed ${row[2]}',
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  subtitle: Text('${row[3]} • ${row[4]} • ${row[5]}',
                      style: const TextStyle(fontSize: 11)),
                ),
              )),
        ],
      ),
    );
  }

  Widget _permRow(String role, List<bool> perms, String note) {
    final icons = ['👤', '🏥', '📊', '🌍'];
    final labels = ['Own', 'Clinic', 'Region', 'National'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
              width: 110,
              child: Text(role,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600))),
          ...List.generate(
              4,
              (i) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Tooltip(
                      message: labels[i],
                      child: Text(perms[i] ? '✅' : '❌',
                          style: const TextStyle(fontSize: 16)),
                    ),
                  )),
          Expanded(
              child: Text(note,
                  style: const TextStyle(fontSize: 11, color: kSubText))),
        ],
      ),
    );
  }

  String _levelName(AccessLevel l) {
    switch (l) {
      case AccessLevel.patient:
        return 'Patient';
      case AccessLevel.clinic:
        return 'Clinic';
      case AccessLevel.regionalHospital:
        return 'Regional Hospital';
      case AccessLevel.ministryOfHealth:
        return 'Ministry of Health';
    }
  }

  Color _levelColor(AccessLevel l) {
    switch (l) {
      case AccessLevel.patient:
        return Colors.blue;
      case AccessLevel.clinic:
        return kPrimary;
      case AccessLevel.regionalHospital:
        return Colors.orange;
      case AccessLevel.ministryOfHealth:
        return kRed;
    }
  }
}

class _AccessLevelCard extends StatelessWidget {
  final AccessLevel level;
  final Color color;
  final List<String> permissions;
  final List<String> restrictions;
  const _AccessLevelCard(
      {required this.level,
      required this.color,
      required this.permissions,
      required this.restrictions});

  String get _name {
    switch (level) {
      case AccessLevel.patient:
        return 'Patient';
      case AccessLevel.clinic:
        return 'Registered Clinic';
      case AccessLevel.regionalHospital:
        return 'Regional Referral Hospital';
      case AccessLevel.ministryOfHealth:
        return 'Ministry of Health';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(12)),
                  child: Text(_name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...permissions.map((p) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('✅ ', style: TextStyle(fontSize: 12)),
                    Expanded(
                        child: Text(p, style: const TextStyle(fontSize: 12))),
                  ],
                )),
            ...restrictions.map((r) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🚫 ', style: TextStyle(fontSize: 12)),
                    Expanded(
                        child: Text(r,
                            style: const TextStyle(
                                fontSize: 12, color: kSubText))),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
