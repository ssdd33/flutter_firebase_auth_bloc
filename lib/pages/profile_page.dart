import 'package:firebase_auth_bloc/blocs/auth/auth_bloc.dart';
import 'package:firebase_auth_bloc/blocs/profile/profile_cubit.dart';
import 'package:firebase_auth_bloc/utils/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile';
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  _getProfile() {
    final uid = context.read<AuthBloc>().state.user!.uid;
    print('uid: $uid');
    context.read<ProfileCubit>().getProfile(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('profile'),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.profileStatus == ProfileStatus.error) {
            errorDialog(context, state.error);
          }
        },
        builder: (context, state) {
          final status = state.profileStatus;
          if (status == ProfileStatus.initial) {
            return Container();
          }
          if (status == ProfileStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (status == ProfileStatus.error) {
            return const Center(
              child: Text('profile '),
            );
          }
          return Card(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FadeInImage.assetNetwork(
                    placeholder: 'assets/images/loading.gif',
                    image: state.user.profileImage,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('-id : ${state.user.id}',
                                style: const TextStyle(fontSize: 18)),
                            const SizedBox(height: 10),
                            Text('-name : ${state.user.name}',
                                style: const TextStyle(fontSize: 18)),
                            const SizedBox(height: 10),
                            Text('-email : ${state.user.email}',
                                style: const TextStyle(fontSize: 18)),
                            const SizedBox(height: 10),
                            Text('-rank : ${state.user.rank}',
                                style: const TextStyle(fontSize: 18)),
                            const SizedBox(height: 10),
                            Text('-point : ${state.user.point}',
                                style: const TextStyle(fontSize: 18)),
                            const SizedBox(height: 10),
                          ]))
                ]),
          );
        },
      ),
    );
  }
}
