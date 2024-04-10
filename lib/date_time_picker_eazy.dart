library flutter_date_time_picker;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

enum DateTimePickerType { date, time, dateTime, dateTimeSeparate }

class DateTimePicker extends StatefulWidget {
  const DateTimePicker({
    Key? key,
    required this.type,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.initialTime,
    this.dateMask,
    this.icon,
    this.dateLabelText,
    this.timeLabelText,
    this.dateHintText,
    this.timeHintText,
    this.calendarTitle,
    this.cancelText,
    this.confirmText,
    this.fieldLabelText,
    this.fieldHintText,
    this.errorFormatText,
    this.errorInvalidText,
    this.initialEntryMode,
    this.initialDatePickerMode,
    this.selectableDayPredicate,
    this.textDirection,
    this.locale,
    this.useRootNavigator = false,
    this.routeSettings,
    this.use24HourFormat = true,
    this.timeFieldWidth,
    this.timePickerEntryModeInput = false,
  }) : super(key: key);

  final DateTimePickerType type;
  final ValueChanged<String> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  final TimeOfDay? initialTime;
  final String? dateMask;
  final Widget? icon;
  final String? dateLabelText;
  final String? timeLabelText;
  final String? dateHintText;
  final String? timeHintText;
  final String? calendarTitle;
  final String? cancelText;
  final String? confirmText;
  final String? fieldLabelText;
  final String? fieldHintText;
  final String? errorFormatText;
  final String? errorInvalidText;
  final DatePickerEntryMode? initialEntryMode;
  final DatePickerMode? initialDatePickerMode;
  final SelectableDayPredicate? selectableDayPredicate;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool useRootNavigator;
  final RouteSettings? routeSettings;
  final bool use24HourFormat;
  final double? timeFieldWidth;
  final bool timePickerEntryModeInput;

  @override
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _selectedTime = widget.initialTime;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime.now(),
      lastDate: widget.lastDate ?? DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onChanged(DateFormat.yMd().format(picked));
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      widget.onChanged(MaterialLocalizations.of(context).formatTimeOfDay(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: InkWell(
            onTap: () => _selectDate(context),
            child: IgnorePointer(
              child: TextField(
                decoration: InputDecoration(
                  labelText: widget.dateLabelText,
                  hintText: widget.dateHintText,
                  icon: widget.icon,
                ),
                controller: TextEditingController(
                  text: _selectedDate == null
                      ? null
                      : DateFormat.yMd().format(_selectedDate!),
                ),
              ),
            ),
          ),
        ),
        if (widget.type == DateTimePickerType.dateTimeSeparate)
          const SizedBox(width: 15),
        if (widget.type == DateTimePickerType.dateTimeSeparate)
          SizedBox(
            width: widget.timeFieldWidth ?? 100,
            child: InkWell(
              onTap: () => _selectTime(context),
              child: IgnorePointer(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: widget.timeLabelText,
                    hintText: widget.timeHintText,
                  ),
                  controller: TextEditingController(
                    text: _selectedTime == null
                        ? null
                        : MaterialLocalizations.of(context)
                            .formatTimeOfDay(_selectedTime!),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
