// import 'package:flutter/material.dart';

// class Profile extends StatelessWidget {
//   const Profile({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const Color primaryColor = Color(0xFF101127);
//     const Color accentColor = Color(0xFF3D5CFF); // A brighter blue for accents

//     return Scaffold(
//       backgroundColor: Colors.white,
//       // appBar: AppBar(
//       //   backgroundColor: Colors.white,
//       //   elevation: 0,
//       //   centerTitle: false,
//       //   title: const Text(
//       //     "My Profile",
//       //     style: TextStyle(
//       //         color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
//       //   ),
//       //   actions: [
//       //     IconButton(
//       //       onPressed: () {},
//       //       icon: const Icon(Icons.share_outlined, color: Colors.black),
//       //     ),
//       //     IconButton(
//       //       onPressed: () {},
//       //       icon: const Icon(Icons.settings_outlined, color: Colors.black),
//       //     ),
//       //   ],
//       // ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 20),

//               // --- AVATAR & INFO ---
//               Center(
//                 child: Column(
//                   children: [
//                     Stack(
//                       children: [
//                         Container(
//                           width: 120,
//                           height: 120,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.grey[100],
//                             image: const DecorationImage(
//                               image: AssetImage(
//                                   'assets/images/avatar_placeholder.png'),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 0,
//                           right: 0,
//                           child: Container(
//                             padding: const EdgeInsets.all(6),
//                             decoration: BoxDecoration(
//                               color: primaryColor,
//                               shape: BoxShape.circle,
//                               border: Border.all(color: Colors.white, width: 3),
//                             ),
//                             child: const Icon(Icons.edit,
//                                 color: Colors.white, size: 16),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       "Ahmed Manasrah",
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: primaryColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         "@ahmed_dev",
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: primaryColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 30),

//               // --- STATS ROW (Friends / Photos / Events) ---
//               Container(
//                 padding: const EdgeInsets.symmetric(vertical: 20),
//                 decoration: BoxDecoration(
//                   border: Border.symmetric(
//                     horizontal: BorderSide(color: Colors.grey.shade200),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _buildStatItem("Friends", "120"),
//                     Container(
//                         width: 1, height: 40, color: Colors.grey.shade200),
//                     _buildStatItem("Photos", "24"),
//                     Container(
//                         width: 1, height: 40, color: Colors.grey.shade200),
//                     _buildStatItem("Events", "8"),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 30),

//               // --- FRIENDS PREVIEW ---
//               // Align(
//               //   alignment: Alignment.centerLeft,
//               //   child: Row(
//               //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               //     children: [
//               //       const Text("Friends",
//               //           style: TextStyle(
//               //               fontSize: 18, fontWeight: FontWeight.bold)),
//               //       Icon(Icons.arrow_forward,
//               //           size: 20, color: Colors.grey[400]),
//               //     ],
//               //   ),
//               // ),
//               // const SizedBox(height: 16),
//               // SizedBox(
//               //   height: 60,
//               //   child: ListView.builder(
//               //     scrollDirection: Axis.horizontal,
//               //     itemCount: 5,
//               //     itemBuilder: (context, index) {
//               //       if (index == 0) {
//               //         // Add Friend Button
//               //         return Container(
//               //           width: 60,
//               //           margin: const EdgeInsets.only(right: 12),
//               //           decoration: BoxDecoration(
//               //             shape: BoxShape.circle,
//               //             border: Border.all(
//               //                 color: Colors.grey.shade300,
//               //                 style: BorderStyle.solid),
//               //           ),
//               //           child: Icon(Icons.add, color: Colors.grey[400]),
//               //         );
//               //       }
//               //       return Container(
//               //         margin: const EdgeInsets.only(right: 12),
//               //         child: CircleAvatar(
//               //           radius: 30,
//               //           backgroundColor: Colors.grey[200],
//               //           child: Text("U$index"),
//               //         ),
//               //       );
//               //     },
//               //   ),
//               // ),

//               // const SizedBox(height: 40),

//               // --- SETTINGS LIST (Clean Style) ---
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text("Account",
//                     style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey[400])),
//               ),
//               const SizedBox(height: 10),

//               _buildCleanSettingItem(
//                   Icons.person_outline, "Change Username", "ahmed_dev"),
//               _buildCleanSettingItem(
//                   Icons.email_outlined, "Change Email", "ahmed@ex.com"),
//               _buildCleanSettingItem(
//                   Icons.lock_outline, "Change Password", "••••••"),

//               const SizedBox(height: 20),

//               // Logout (Big Minimal Button)
//               SizedBox(
//                 width: double.infinity,
//                 height: 55,
//                 child: OutlinedButton(
//                   onPressed: () {
//                     Navigator.of(context).pushReplacementNamed('/login');
//                   },
//                   style: OutlinedButton.styleFrom(
//                     side: BorderSide(color: Colors.red.shade100),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16)),
//                     backgroundColor: Colors.red.shade50.withOpacity(0.3),
//                   ),
//                   child: const Text("Log Out",
//                       style: TextStyle(
//                           color: Colors.red,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold)),
//                 ),
//               ),
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStatItem(String label, String value) {
//     return Column(
//       children: [
//         Text(value,
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 4),
//         Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 14)),
//       ],
//     );
//   }

//   Widget _buildCleanSettingItem(IconData icon, String title, String trailing) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.grey[50],
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, size: 22, color: Colors.black),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.w600, fontSize: 16)),
//               ],
//             ),
//           ),
//           Text(trailing,
//               style: TextStyle(color: Colors.grey[400], fontSize: 14)),
//           const SizedBox(width: 8),
//           Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[300]),
//         ],
//       ),
//     );
//   }
// }
import 'package:evently/data/repo/home/profile_repo.dart';
import 'package:evently/data/sources/home/profile_service.dart';
import 'package:evently/presentation/profile/bloc/profile_cubit.dart';
import 'package:evently/presentation/profile/bloc/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF101127);

    // 1. Wrap the entire screen with BlocProvider
    // This creates the Cubit and automatically calls getProfileData()
    return BlocProvider(
      create: (context) => ProfileCubit(
        ProfileRepo(ProfileService()),
      )..getProfileData(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            // Optional: Listen for specific errors (like Token Expired) to redirect
            if (state is ProfileError) {
              // You could show a snackbar here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            }
          },
          builder: (context, state) {
            // CASE 1: LOADING
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // CASE 2: ERROR
            if (state is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text("Error: ${state.errorMessage}",
                        textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Retry logic
                        context.read<ProfileCubit>().getProfileData();
                      },
                      child: const Text("Retry"),
                    )
                  ],
                ),
              );
            }

            // CASE 3: SUCCESS (Show the UI)
            if (state is ProfileSuccess) {
              final user = state.user; // Get the data model

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60), // Space for status bar

                      // --- AVATAR & INFO ---
                      Center(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[100],
                                    border: Border.all(
                                        color: Colors.grey.shade200, width: 2),
                                    image: DecorationImage(
                                      // LOGIC: Use NetworkImage if URL exists, else generic
                                      image: user.profileImageUrl.isNotEmpty
                                          ? NetworkImage(user.profileImageUrl)
                                          : const AssetImage(
                                                  'assets/images/avatar_placeholder.png')
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 3),
                                    ),
                                    child: const Icon(Icons.edit,
                                        color: Colors.white, size: 16),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              user.name, // Real Name
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "@${user.username}", // Real Username
                                style: TextStyle(
                                  fontSize: 14,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // --- STATS ROW ---
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                            horizontal: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem(
                                "Friends", user.friendsCount.toString()),
                            Container(
                                width: 1,
                                height: 40,
                                color: Colors.grey.shade200),
                            _buildStatItem(
                                "Photos", user.postsCount.toString()),
                            Container(
                                width: 1,
                                height: 40,
                                color: Colors.grey.shade200),
                            _buildStatItem(
                                "Events", user.eventsCount.toString()),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // --- SETTINGS LIST ---
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Account",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[400])),
                      ),
                      const SizedBox(height: 10),

                      _buildCleanSettingItem(Icons.person_outline,
                          "Change Username", user.username),
                      _buildCleanSettingItem(
                          Icons.email_outlined,
                          "Change Email",
                          "******"), // Email not in DTO usually for security?
                      _buildCleanSettingItem(
                          Icons.lock_outline, "Change Password", "••••••"),

                      const SizedBox(height: 20),

                      // --- LOGOUT BUTTON ---
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: OutlinedButton(
                          onPressed: () async {
                            // 1. Clear Token
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.remove('token');

                            // 2. Navigate safely (Remove Back Stack)
                            if (context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/login', (route) => false);
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.red.shade100),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            backgroundColor:
                                Colors.red.shade50.withOpacity(0.3),
                          ),
                          child: const Text("Log Out",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              );
            }

            // Fallback (Should typically not reach here)
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 14)),
      ],
    );
  }

  Widget _buildCleanSettingItem(IconData icon, String title, String trailing) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: Colors.black),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16)),
              ],
            ),
          ),
          Text(trailing,
              style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[300]),
        ],
      ),
    );
  }
}
