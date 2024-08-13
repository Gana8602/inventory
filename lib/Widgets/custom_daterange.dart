import 'package:flutter/material.dart';

class CustomDateRangePickerDialog extends StatefulWidget {
  final DateTimeRange? initialDateRange;
  final Function(DateTimeRange) onDateRangeSelected;

  const CustomDateRangePickerDialog({
    Key? key,
    this.initialDateRange,
    required this.onDateRangeSelected,
  }) : super(key: key);

  @override
  _CustomDateRangePickerDialogState createState() =>
      _CustomDateRangePickerDialogState();
}

class _CustomDateRangePickerDialogState
    extends State<CustomDateRangePickerDialog> {
  late DateTimeRange selectedDateRange;

  @override
  void initState() {
    super.initState();
    selectedDateRange = widget.initialDateRange ??
        DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(days: 7)),
        );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Date Range'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Start Date'),
            subtitle: Text(
              "${selectedDateRange.start.toLocal()}".split(' ')[0],
            ),
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDateRange.start,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null && picked != selectedDateRange.start) {
                setState(() {
                  selectedDateRange = DateTimeRange(
                    start: picked,
                    end: selectedDateRange.end,
                  );
                });
              }
            },
          ),
          ListTile(
            title: const Text('End Date'),
            subtitle: Text(
              "${selectedDateRange.end.toLocal()}".split(' ')[0],
            ),
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: selectedDateRange.end,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null && picked != selectedDateRange.end) {
                setState(() {
                  selectedDateRange = DateTimeRange(
                    start: selectedDateRange.start,
                    end: picked,
                  );
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onDateRangeSelected(selectedDateRange);
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
