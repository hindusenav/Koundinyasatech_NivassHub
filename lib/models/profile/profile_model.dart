import 'package:flutter_nivasshub/models/profile/address_model.dart';

class ProfileModel {
  final String userName;
  final String bio;
  final String work;
  final bool enableCalls;
  final List<String> tags;
  final List<String> interests;
  final AddressModel address;

  const ProfileModel({
    this.userName = 'User Name',
    this.bio = '',
    this.work = '',
    this.enableCalls = true,
    this.tags = const ['B-402', 'Tenant'],
    this.interests = const [],
    this.address = const AddressModel(),
  });

  ProfileModel copyWith({
    String? userName,
    String? bio,
    String? work,
    bool? enableCalls,
    List<String>? tags,
    List<String>? interests,
    AddressModel? address,
  }) {
    return ProfileModel(
      userName: userName ?? this.userName,
      bio: bio ?? this.bio,
      work: work ?? this.work,
      enableCalls: enableCalls ?? this.enableCalls,
      tags: tags ?? this.tags,
      interests: interests ?? this.interests,
      address: address ?? this.address,
    );
  }
}