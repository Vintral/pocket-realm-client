extension StringExtension on String {
    String capitalize() {    
      return "${this[0].toUpperCase()}${length >= 1 ? substring(1).toLowerCase() : ""}";
    }
}