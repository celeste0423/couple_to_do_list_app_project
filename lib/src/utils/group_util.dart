class GroupUtil {
  bool isSoloGroup(String? groupId) {
    if (groupId != null) {
      return groupId.startsWith('solo');
    } else {
      return false;
    }
  }
}
