import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFilterDialog extends StatefulWidget {
  const DateFilterDialog({super.key});

  @override
  State<DateFilterDialog> createState() => _DateFilterDialogState();
}

class _DateFilterDialogState extends State<DateFilterDialog> {
  final TextEditingController _weekController = TextEditingController();

  String _selectedDateRange = 'Date Range';

  final List<String> _listDateRange = [
    'Date Range',
    'Weekly',
    'Monthly',
    'Yearly'
  ];

  final List<String> years = ['2022', '2023', '2024'];
  // Add more years if needed
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  DateTime? _startDate;

  DateTime? _endDate;

  void _selectStartDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: _startDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        selectableDayPredicate: (DateTime date) => date.day <= 31);
    if (pickedDate != null && pickedDate != _startDate) {
      setState(() {
        _startDate = pickedDate;
      });
    }
  }

  void _selectEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      selectableDayPredicate: (DateTime date) => date.day <= 31,
    );
    if (pickedDate != null && pickedDate != _endDate) {
      setState(() {
        _endDate = pickedDate;
      });
    }
  }

  // DateTime? _week;
  void _selectWeek(BuildContext context) async {
    final pickedWeek = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      selectableDayPredicate: (DateTime date) =>
          date.weekday >= DateTime.monday && date.weekday <= DateTime.sunday,
    );
    if (pickedWeek != null) {
      DateTime startDate =
          pickedWeek.subtract(Duration(days: pickedWeek.weekday - 1));
      DateTime endDate =
          pickedWeek.add(Duration(days: DateTime.sunday - pickedWeek.weekday));
      setState(() {
        _weekController.text =
            '${startDate.day}/${startDate.month}/${startDate.year} - ${endDate.day}/${endDate.month}/${endDate.year}';
      });
    }
  }

  String? _selectedMonth;

  String? _selectedYear;

  final List<String> _listYears = [];

  void yearDropDown() {
    int currentYear = DateTime.now().year;
    for (int year = 2023; year <= currentYear && year <= 2024; year++) {
      _listYears.add(year.toString());
    }
    _selectedYear = _listYears.first;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Date Filter'),
      content: Column(children: [
        DropdownButtonFormField<String>(
          value: _selectedDateRange,
          isExpanded: true,
          items: _listDateRange
              .map((String result) =>
                  DropdownMenuItem<String>(value: result, child: Text(result)))
              .toList(),
          onChanged: (newValue) => setState(() {
            _selectedDateRange = newValue!;
          }),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.3))),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.lightBlue),
            ),
          ),
        ),
        if (_selectedDateRange == 'Date Range')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10.0,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Text(
                  'From Date*',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              TextField(
                controller: TextEditingController(
                    text: _startDate == null
                        ? 'Select Start Date'
                        : DateFormat('dd-MM-yyyy').format(_startDate!)),
                onTap: () => _selectStartDate(context),
                readOnly: true,
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.calendar_today,
                    size: 20,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.3))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.lightBlue),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Text(
                  'To Date*',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              TextField(
                controller: TextEditingController(
                    text: _endDate == null
                        ? 'Select End Date'
                        : DateFormat('dd-MM-yyyy').format(_endDate!)),
                onTap: () => _selectEndDate(context),
                readOnly: true,
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.calendar_today,
                    size: 20,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.3))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.lightBlue),
                  ),
                ),
              ),
            ],
          ),
        if (_selectedDateRange == 'Weekly')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10.0,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Text(
                  'Week',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              TextField(
                controller: _weekController,
                onTap: () => _selectWeek(context),
                readOnly: true,
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.calendar_today,
                    size: 20,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.3))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.lightBlue),
                  ),
                ),
              )
            ],
          ),
        if (_selectedDateRange == 'Monthly')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10.0,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Text(
                  'Year',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              DropdownButtonFormField<String>(
                value: _selectedYear,
                isExpanded: true,
                items: _listYears
                    .map((String result) => DropdownMenuItem<String>(
                        value: result, child: Text(result)))
                    .toList(),
                onChanged: (newValue) => setState(() {
                  _selectedYear = newValue;
                }),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.3))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.lightBlue),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Text(
                  'Month',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              DropdownButtonFormField<String>(
                value: _selectedMonth,
                isExpanded: true,
                items: months.where((month) {
                  if (_selectedYear == DateTime.now().toString()) {
                    final currentMonth = DateTime.now().month;
                    final monthIndex = months.indexOf(month) + 1;
                    return monthIndex <= currentMonth;
                  }
                  return true;
                }).map((month) {
                  return DropdownMenuItem<String>(
                    value: month,
                    child: Text(month),
                  );
                }).toList(),
                onChanged: (newValue) => setState(() {
                  _selectedMonth = newValue;
                }),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.3))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.lightBlue),
                  ),
                ),
              ),
            ],
          ),
        if (_selectedDateRange == 'Yearly')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10.0,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Text(
                  'Year',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              DropdownButtonFormField<String>(
                value: _selectedYear,
                isExpanded: true,
                items: _listYears
                    .map((String result) => DropdownMenuItem<String>(
                        value: result, child: Text(result)))
                    .toList(),
                onChanged: (newValue) => setState(() {
                  _selectedYear = newValue;
                }),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.3))),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.lightBlue),
                  ),
                ),
              ),
            ],
          ),
      ]),
    );
  }
}
