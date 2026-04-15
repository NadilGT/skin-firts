import 'package:flutter/material.dart';

/// A simple, codegen-free localization helper.
/// Add new keys here as the app grows.
class AppLocalizations {
  final String languageCode;
  const AppLocalizations(this.languageCode);

  static AppLocalizations of(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return AppLocalizations(locale.languageCode);
  }

  bool get isSinhala => languageCode == 'si';

  // ── Profile Page ────────────────────────────────────────────────
  String get myProfile => isSinhala ? 'මගේ පැතිකඩ' : 'My Profile';
  String get account => isSinhala ? 'ගිණුම' : 'Account';
  String get profile => isSinhala ? 'පැතිකඩ' : 'Profile';
  String get checkDoctorAvailability =>
      isSinhala ? 'වෛද්‍යවරයා ලබා ගත හැකිද?' : 'Check Doctor Availability';
  String get notifications => isSinhala ? 'දැනුම්දීම්' : 'Notifications';
  String get preferences => isSinhala ? 'මනාපයන්' : 'Preferences';
  String get language => isSinhala ? 'භාෂාව' : 'Language';
  String get sinhala => isSinhala ? 'සිංහල' : 'Sinhala';
  String get english => isSinhala ? 'ඉංග්‍රීසි' : 'English';
  String get settings => isSinhala ? 'සැකසීම්' : 'Settings';
  String get darkMode => isSinhala ? 'අඳුරු ක්‍රමය' : 'Dark Mode';
  String get help => isSinhala ? 'උදව්' : 'Help';
  String get logout => isSinhala ? 'පිටවීම' : 'Logout';
  String get noName => isSinhala ? 'නමක් නැත' : 'No name';
  String get loading => isSinhala ? 'පූරණය වෙමින්...' : 'Loading...';

  // ── Home / General ───────────────────────────────────────────────
  String get home => isSinhala ? 'ගෙදර' : 'Home';
  String get appointments => isSinhala ? 'හමුවීම්' : 'Appointments';
  String get messages => isSinhala ? 'පණිවිඩ' : 'Messages';
  String get goodMorning => isSinhala ? 'සුභ උදෑසනක් 👋' : 'Good Morning 👋';
  String get yourSchedule => isSinhala ? 'ඔබගේ කාලසටහන' : 'Your Schedule';
  String get upcomingAppointments =>
      isSinhala ? 'ළඟදී ඇති හමුවීම්' : 'Upcoming appointments';

  // ── Appointment Page ─────────────────────────────────────────────
  String get bookAppointment =>
      isSinhala ? 'හමුවීමක් වෙන් කරන්න' : 'Book Appointment';
  String get selectDate =>
      isSinhala ? 'දිනය තෝරන්න' : 'Select Date';
  String get selectTime =>
      isSinhala ? 'වේලාව තෝරන්න' : 'Select Time';
  String get confirm => isSinhala ? 'තහවුරු කරන්න' : 'Confirm';
  String get cancel => isSinhala ? 'අවලංගු කරන්න' : 'Cancel';
  String get whatDoYouNeed =>
      isSinhala ? 'ඔබට කුමන\nඋදව්වක් අවශ්‍යද?' : 'What do you need\nhelp with?';
  String get selectFocusSubtitle =>
      isSinhala
          ? 'නිවැරදි විශේෂඥ ලබා ගැනීමට\nකේන්ද්‍රය තෝරන්න.'
          : 'Select a primary focus to match you\nwith the right specialist.';
  String get selectFocus => isSinhala ? 'කේන්ද්‍රය තෝරන්න' : 'Select Focus';
  String get chooseAFocus =>
      isSinhala ? 'කේන්ද්‍රයක් තෝරන්න...' : 'Choose a focus...';
  String get availableSpecialists =>
      isSinhala ? 'ලබා ගත හැකි විශේෂඥයෝ' : 'Available Specialists';
  String get noDoctorsAvailable =>
      isSinhala ? 'වෛද්‍යවරු නොමැත' : 'No doctors available';
  String get tryDifferentFocus =>
      isSinhala ? 'වෙනත් කේන්ද්‍රයක් උත්සාහ කරන්න' : 'Try selecting a different focus';
  String get yrs => isSinhala ? 'වසර' : 'yrs';

  // ── Doctor ───────────────────────────────────────────────────────
  String get doctorList => isSinhala ? 'වෛද්‍යවරුකූ' : 'Doctors';
  String get doctors => isSinhala ? 'වෛද්‍යවරුකූ' : 'Doctors';
  String get available => isSinhala ? 'ලබා ගත හැකිය' : 'Available';
  String get notAvailable => isSinhala ? 'ලබා ගත නොහැකිය' : 'Not Available';
  String get sortBy => isSinhala ? 'වර්ගීකරණය' : 'Sort By';
  String get doctorProfile => isSinhala ? 'වෛද්‍ය පැතිකඩ' : 'Doctor Profile';
  String get scheduleBtn => isSinhala ? 'කාලසටහන' : 'Schedule';
  String get profileSection => isSinhala ? 'පැතිකඩ' : 'Profile';
  String get careerPath => isSinhala ? 'වෘත්තීය මාර්ගය' : 'Career Path';
  String get highlights => isSinhala ? 'ඉස්මතු කිරීම්' : 'Highlights';
  String get experience => isSinhala ? 'අත්දැකීම' : 'experience';
  String get focus => isSinhala ? 'අවධානය' : 'Focus';

  // ── Check Doctor Availability ────────────────────────────────────
  String get checkAvailability =>
      isSinhala ? 'ලබා ගත හැකිද?' : 'Check Availability';
  String get findAvailableDoctor =>
      isSinhala ? 'ලබා ගත හැකි\nවෛද්‍යවරයෙකු සොයන්න' : 'Find an available\ndoctor';
  String get findAvailableDoctorSub =>
      isSinhala
          ? 'කේන්ද්‍ර ක්ෂේත්‍රයක් තෝරා, ඔවුන්ගේ\nලබා ගැනීමේ හැකියාව පරීක්ෂා කිරීමට\nවෛද්‍යවරයෙකු තෝරන්න.'
          : 'Select a focus area, then choose a doctor\nto check their availability.';
  String get selectADoctor =>
      isSinhala ? 'වෛද්‍යවරයෙකු තෝරන්න' : 'Select a Doctor';
  String get check => isSinhala ? 'පරීක්ෂා කරන්න' : 'Check';

  // ── Notifications Page ───────────────────────────────────────────
  String get notificationsTitle => isSinhala ? 'දැනුම්දීම්' : 'Notifications';
  String get noNotifications => isSinhala ? 'දැනුම්දීම් නොමැත' : 'No Notifications';
  String get noNotificationsSub =>
      isSinhala
          ? 'රසවත් දෙයක් සිදු වූ විට\nඅපි ඔබට දන්වන්නෙමු!'
          : "We'll let you know when something\nexciting happens!";
  String get somethingWentWrong =>
      isSinhala ? 'යම් දෙයක් වැරදී ගියා' : 'Something went wrong';
  String get tryAgain => isSinhala ? 'නැවත උත්සාහ කරන්න' : 'Try Again';

  // ── Medicine Order (Messages) Page ───────────────────────────────
  String get medicineOrder => isSinhala ? 'ඖෂධ ඇණවුම' : 'Medicine Order';
  String get searchMedicines =>
      isSinhala ? 'ඖෂධ සොයන්න...' : 'Search medicines...';
  String get search => isSinhala ? 'සොයන්න' : 'Search';
  String get retry => isSinhala ? 'නැවත උත්සාහ කරන්න' : 'Retry';
  String get searchForMedicines =>
      isSinhala ? 'ඇණවුමට ඖෂධ සොයන්න' : 'Search for medicines to add to order';
  String get orderCart => isSinhala ? 'ඇණවුම් කරත්තය' : 'Order Cart';
  String get patientInformation =>
      isSinhala ? 'රෝගී තොරතුරු' : 'Patient Information';
  String get cartItems => isSinhala ? 'කරත්තයේ දෑ' : 'Cart Items';
  String get cartIsEmpty => isSinhala ? 'කරත්තය හිස්ය' : 'Cart is empty';
  String get totalAmount => isSinhala ? 'මුළු මුදල' : 'Total Amount';
  String get placeOrder => isSinhala ? 'ඇණවුම ලබා දෙන්න' : 'Place Order';
  String get orderCreated => isSinhala ? 'ඇණවුම සෑදා ඇත' : 'Order Created';
  String get outOfStock => isSinhala ? 'තොගය නොමැත' : 'Out of Stock';
  String get inStock => isSinhala ? 'තොගය ඇත' : 'In Stock';

  // ── Book Appointment Page ────────────────────────────────────────
  String get bookAppointmentTitle =>
      isSinhala ? 'හමුවීමක් වෙන් කරන්න' : 'Book Appointment';
  String get patientInfoSection =>
      isSinhala ? 'රෝගී තොරතුරු' : 'Patient Information';
  String get doctorInfoSection =>
      isSinhala ? 'වෛද්‍ය තොරතුරු' : 'Doctor Information';
  String get appointmentDetails =>
      isSinhala ? 'හමුවීමේ විස්තර' : 'Appointment Details';
  String get appointmentDate =>
      isSinhala ? 'හමුවීමේ දිනය' : 'Appointment Date';
  String get selectDateHint => isSinhala ? 'දිනය තෝරන්න' : 'Select Date';
  String get booking => isSinhala ? 'වෙන් කරමින්...' : 'Booking...';

  // ── Find Running Appointment Page ──────────────────────────────────
  String get findRunningAppointment => isSinhala ? 'දැනට පවතින හමුවීම සොයන්න' : 'Find Running Appointment';
  String get selectAFocusArea => isSinhala ? 'කේන්ද්‍ර ක්ෂේත්‍රයක් තෝරන්න' : 'Select a Focus Area';
  String get chooseAFocusToSeeDoctors => 
      isSinhala ? 'දැනට පවතින හමුවීම් ඇති වෛද්‍යවරුන් බැලීමට කේන්ද්‍රයක් තෝරන්න.' : 'Choose a focus to see doctors with currently running appointments.';
  String get noDoctorsAvailableForFocus =>
      isSinhala ? 'මෙම කේන්ද්‍රය සඳහා වෛද්‍යවරුන් නොමැත.' : 'No doctors available for this focus.';
  String get failedToLoadFocus =>
      isSinhala ? 'කේන්ද්‍රය පූරණය කිරීමට අසමත් විය:' : 'Failed to load focus:';
  String get failedToLoadDoctors =>
      isSinhala ? 'වෛද්‍යවරුන් පූරණය කිරීමට අසමත් විය:' : 'Failed to load doctors:';
}
