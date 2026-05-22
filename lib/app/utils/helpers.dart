import 'package:intl/intl.dart';

class Helpers {
  static String formatPrice(String price) {
    final double? value = double.tryParse(price);
    if (value == null) return '₹0';
    return '₹${NumberFormat('#,##0.00').format(value)}';
  }

  static String formatDate(String date) {
    try {
      final DateTime dateTime = DateTime.parse(date);
      return DateFormat('dd MMM yyyy').format(dateTime);
    } catch (e) {
      return date;
    }
  }

  static String formatDateTime(String date) {
    try {
      final DateTime dateTime = DateTime.parse(date);
      return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    } catch (e) {
      return date;
    }
  }

  static String getTimeAgo(DateTime dateTime) {
    final Duration diff = DateTime.now().difference(dateTime);
    if (diff.inDays > 365) {
      return '${(diff.inDays / 365).floor()} year(s) ago';
    } else if (diff.inDays > 30) {
      return '${(diff.inDays / 30).floor()} month(s) ago';
    } else if (diff.inDays > 0) {
      return '${diff.inDays} day(s) ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hour(s) ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minute(s) ago';
    } else {
      return 'Just now';
    }
  }

  static String getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return '#FFA726';
      case 'processing':
        return '#29B6F6';
      case 'on-hold':
        return '#FFA726';
      case 'completed':
        return '#4CAF50';
      case 'cancelled':
        return '#E53935';
      case 'refunded':
        return '#9E9E9E';
      case 'failed':
        return '#E53935';
      default:
        return '#9E9E9E';
    }
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}
