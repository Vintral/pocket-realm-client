class ExploreResult {
  final int gain;
  final int energy;
  late String message;

  ExploreResult( { required this.gain, required this.energy } ) {
    message = getMessage();
  }

  String getMessage() {
    switch( gain ) {
      case 0: return "No land found";
      case 1: return "You managed to clear out 1 acre of land";
      default: return "You found $gain acres of land";
    }
  }
}