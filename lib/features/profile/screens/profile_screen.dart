import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/profile_tile.dart';
import '../provider/profile_provider.dart';
import '../models/profile_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();

    /// ✅ Correct provider call
    Future.microtask(() {
      Provider.of<ProfileProvider>(context, listen: false).loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);

    /// 🔄 Loading
    if (provider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final ProfileModel? data = provider.profile;

    /// ❌ No Data
    if (data == null) {
      return const Scaffold(
        body: Center(child: Text("No Profile Data")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),

      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 20),

            /// 👤 Profile Image
            CircleAvatar(
              radius: 50,
              backgroundImage: data.profileImage.isNotEmpty
                  ? NetworkImage(data.profileImage)
                  : null,
              child: data.profileImage.isEmpty
                  ? const Icon(Icons.person, size: 40)
                  : null,
            ),

            const SizedBox(height: 10),

            /// 👤 Name
            Text(
              data.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            /// 📧 Email
            Text(
              data.email,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            /// 📦 Tiles
            ProfileTile(
              title: "Mobile",
              subtitle: data.mobile,
              icon: Icons.phone,
              onTap: () {},
            ),

            ProfileTile(
              title: "Add Address",
              subtitle: "Add Address details",
              icon: Icons.location_on,
              onTap: () {
                Navigator.pushNamed(context, '/address');
              },
            ),

            /// ✅ FIXED UPDATE PROFILE
            ProfileTile(
              title: "Edit Profile",
              subtitle: "Update your details",
              icon: Icons.edit,
              onTap: () {
                provider.updateProfile(
                  name: "Updated Name",
                );
              },
            ),

            ProfileTile(
              title: "Logout",
              subtitle: "Sign out from app",
              icon: Icons.logout,
              onTap: () {
                provider.clearProfile();
              },
            ),
          ],
        ),
      ),
    );
  }
}