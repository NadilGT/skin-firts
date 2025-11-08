import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// Model for appointment
class Appointment {
  final String doctorName;
  final String specialty;
  final String time;
  final String status; // 'confirmed', 'pending', 'completed', 'cancelled'
  final String doctorImage;

  Appointment({
    required this.doctorName,
    required this.specialty,
    required this.time,
    required this.status,
    this.doctorImage = '',
  });
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  Map<DateTime, List<Appointment>> _appointments = {};
  List<Appointment> _selectedDayAppointments = [];

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _loadAppointments();
    _loadAppointmentsForDay(_selectedDay);
  }

  // Sample appointment data - Replace with your API call
  void _loadAppointments() {
    final today = DateTime.now();
    _appointments = {
      DateTime(today.year, today.month, today.day): [
        Appointment(
          doctorName: 'Dr. John Smith',
          specialty: 'Cardiologist',
          time: '10:00 AM',
          status: 'confirmed',
        ),
        Appointment(
          doctorName: 'Dr. Sarah Wilson',
          specialty: 'Dermatologist',
          time: '02:00 PM',
          status: 'confirmed',
        ),
      ],
      DateTime(today.year, today.month, today.day + 2): [
        Appointment(
          doctorName: 'Dr. Michael Brown',
          specialty: 'Neurologist',
          time: '11:30 AM',
          status: 'pending',
        ),
      ],
      DateTime(today.year, today.month, today.day + 5): [
        Appointment(
          doctorName: 'Dr. Emily Davis',
          specialty: 'Pediatrician',
          time: '09:00 AM',
          status: 'confirmed',
        ),
      ],
      DateTime(today.year, today.month, today.day - 3): [
        Appointment(
          doctorName: 'Dr. Robert Taylor',
          specialty: 'Orthopedic',
          time: '03:00 PM',
          status: 'completed',
        ),
      ],
    };
  }

  void _loadAppointmentsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    setState(() {
      _selectedDayAppointments = _appointments[normalizedDay] ?? [];
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'confirmed':
        return Icons.check_circle;
      case 'pending':
        return Icons.schedule;
      case 'completed':
        return Icons.done_all;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Appointments',
          style: TextStyle(
            color: Color(0xFF2E5BFF),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildSummaryCard(
                    'Upcoming',
                    _countAppointmentsByStatus('confirmed') +
                        _countAppointmentsByStatus('pending'),
                    Colors.blue,
                    Icons.calendar_today,
                  ),
                  const SizedBox(width: 12),
                  _buildSummaryCard(
                    'Completed',
                    _countAppointmentsByStatus('completed'),
                    Colors.green,
                    Icons.check_circle_outline,
                  ),
                ],
              ),
            ),

            // Calendar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime.now().subtract(const Duration(days: 365)),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronIcon: const Icon(
                    Icons.chevron_left,
                    color: Color(0xFF2E5BFF),
                  ),
                  rightChevronIcon: const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF2E5BFF),
                  ),
                ),
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: const Color(0xFF2E5BFF).withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Color(0xFF2E5BFF),
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: const BoxDecoration(
                    color: Color(0xFF2E5BFF),
                    shape: BoxShape.circle,
                  ),
                  markersMaxCount: 1,
                  outsideDaysVisible: false,
                ),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _loadAppointmentsForDay(selectedDay);
                },
                eventLoader: (day) {
                  final normalizedDay = DateTime(day.year, day.month, day.day);
                  return _appointments[normalizedDay] ?? [];
                },
              ),
            ),

            const SizedBox(height: 16),

            // Appointments Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                _selectedDayAppointments.isEmpty
                    ? 'No appointments'
                    : '${_selectedDayAppointments.length} Appointment${_selectedDayAppointments.length > 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            // Appointments List
            _selectedDayAppointments.isEmpty
                ? Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No appointments on this day',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _selectedDayAppointments.length,
                    itemBuilder: (context, index) {
                      return _buildAppointmentCard(
                        _selectedDayAppointments[index],
                      );
                    },
                  ),
            
            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to book new appointment
        },
        backgroundColor: const Color(0xFF2E5BFF),
        icon: const Icon(Icons.add, color: Colors.white,),
        label: const Text('Book Appointment', style: TextStyle(color: Colors.white),),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    int count,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Doctor Avatar
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF2E5BFF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.person,
                size: 32,
                color: Color(0xFF2E5BFF),
              ),
            ),
            const SizedBox(width: 16),
            // Appointment Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.doctorName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    appointment.specialty,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        appointment.time,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        _getStatusIcon(appointment.status),
                        size: 16,
                        color: _getStatusColor(appointment.status),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        appointment.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(appointment.status),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Action Buttons
            IconButton(
              onPressed: () => _showAppointmentDetails(appointment),
              icon: const Icon(Icons.more_vert),
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  int _countAppointmentsByStatus(String status) {
    int count = 0;
    _appointments.forEach((date, appointments) {
      count += appointments.where((apt) => apt.status == status).length;
    });
    return count;
  }

  void _showAppointmentDetails(Appointment appointment) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appointment Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow(Icons.person, 'Doctor', appointment.doctorName),
            _buildDetailRow(Icons.medical_services, 'Specialty', appointment.specialty),
            _buildDetailRow(Icons.access_time, 'Time', appointment.time),
            _buildDetailRow(Icons.info_outline, 'Status', appointment.status.toUpperCase()),
            const SizedBox(height: 24),
            Row(
              children: [
                if (appointment.status != 'completed' && appointment.status != 'cancelled')
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showCancelDialog();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                if (appointment.status != 'completed' && appointment.status != 'cancelled')
                  const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigate to reschedule
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E5BFF),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Reschedule'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF2E5BFF)),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Cancel Appointment'),
        content: const Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Appointment cancelled'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}