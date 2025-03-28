class FirebaseConfigData {
  final bool? inReleaseProgress;
  final bool? inDev;
  final bool? flexibleUpdate;
  final bool? immediateUpdate;
  final bool? versionDisable;
  final bool? hideTotalLearned;

  const FirebaseConfigData({this.hideTotalLearned, this.inReleaseProgress, this.inDev, this.flexibleUpdate, this.immediateUpdate, this.versionDisable});

  factory FirebaseConfigData.defaultConfig() {
    return const FirebaseConfigData(
      hideTotalLearned: false,
        inReleaseProgress: false, inDev: false, flexibleUpdate: false, immediateUpdate: false, versionDisable: false);
  }

  FirebaseConfigData copyWith(
      {bool? inReleaseProgress, bool? inDev, bool? flexibleUpdate, bool? immediateUpdate, bool? versionDisable, bool? hideTotalLearned}) {
    return FirebaseConfigData(
        inReleaseProgress: inReleaseProgress ?? this.inReleaseProgress,
        inDev: inDev ?? this.inDev,
        flexibleUpdate: flexibleUpdate ?? this.flexibleUpdate,
        immediateUpdate: immediateUpdate ?? this.immediateUpdate,
        versionDisable: versionDisable ?? this.versionDisable,
      hideTotalLearned: hideTotalLearned ?? this.hideTotalLearned);
  }

  Map<String, Object?> toJson() {
    return {
      'inReleaseProgress': inReleaseProgress,
      'inDev': inDev,
      'flexibleUpdate': flexibleUpdate,
      'immediateUpdate': immediateUpdate,
      'versionDisable': versionDisable,
      'hideTotalLearned': hideTotalLearned
    };
  }

  factory FirebaseConfigData.fromJson(Map<String, Object?> json) {
    return FirebaseConfigData(
      hideTotalLearned: json['hideTotalLearned'] == null ? null : json['hideTotalLearned'] as bool?,
        inReleaseProgress: json['inReleaseProgress'] == null ? null : json['inReleaseProgress'] as bool?,
        inDev: json['inDev'] == null ? null : json['inDev'] as bool?,
        flexibleUpdate: json['flexibleUpdate'] == null ? null : json['flexibleUpdate'] as bool?,
        immediateUpdate: json['immediateUpdate'] == null ? null : json['immediateUpdate'] as bool?,
        versionDisable: json['versionDisable'] == null ? null : json['versionDisable'] as bool?);
  }

  @override
  String toString() {
    return 'FirebaseConfigData{inReleaseProgress: $inReleaseProgress, flexibleUpdate: $flexibleUpdate, immediateUpdate: $immediateUpdate, versionDisable: $versionDisable}';
  }

  @override
  bool operator ==(Object other) {
    return other is FirebaseConfigData &&
        other.runtimeType == runtimeType &&
        other.inReleaseProgress == inReleaseProgress &&
        other.flexibleUpdate == flexibleUpdate &&
        other.immediateUpdate == immediateUpdate &&
        other.hideTotalLearned == hideTotalLearned &&
        other.versionDisable == versionDisable;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, inReleaseProgress, flexibleUpdate, immediateUpdate, versionDisable, hideTotalLearned);
  }
}
