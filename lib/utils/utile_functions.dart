class UtileFunctions {

    static String formatDate(DateTime date) {
    return '${monthShort(date.month)} ${date.day}, ${date.year}';
  }

  static String monthShort(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month];
  }

  static String formatTime(dynamic time) {
    if (time == null) return '-';
    if (time is String && time.length >= 16 && time.contains('T')) {
      // ISO string
      final dt = DateTime.tryParse(time);
      if (dt != null) {
        final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
        final ampm = dt.hour >= 12 ? 'PM' : 'AM';
        return '$hour:${dt.minute.toString().padLeft(2, '0')} $ampm';
      }
    }
    return time.toString();
  }

}