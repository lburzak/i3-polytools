enum BlockState { info, good, warning, critical }

extension Serialization on BlockState {
  String serialize() {
    switch (this) {
      case BlockState.info:
        return "Info";
      case BlockState.good:
        return "Good";
      case BlockState.warning:
        return "Warning";
      case BlockState.critical:
        return "Critical";
    }
  }
}
