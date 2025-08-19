import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_chat_flutter/cubits/profiles/profiles_cubit.dart';
import 'package:realtime_chat_flutter/models/profile.dart';
import 'package:realtime_chat_flutter/pages/register_page.dart';
import 'package:realtime_chat_flutter/utils/constants.dart';
import 'package:timeago/timeago.dart';

import '../cubits/rooms/rooms_cubit.dart';
import 'chat_page.dart';

/// Displays the list of chat threads
class RoomsPage extends StatefulWidget {
  final Profile? username;
  const RoomsPage({Key? key, required this.username}) : super(key: key);

  static Route<void> route({Profile? username}) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider<RoomCubit>(
        create: (context) => RoomCubit()..initializeRooms(context),
        child: RoomsPage(username: username),
      ),
    );
  }

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Chats of ${widget.username?.username ?? 'current username'}'),
        actions: [
          TextButton(
            onPressed: () async {
              await supabase.auth.signOut();
              Navigator.of(
                context,
              ).pushAndRemoveUntil(RegisterPage.route(), (route) => false);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
      body: BlocBuilder<RoomCubit, RoomState>(
        builder: (context, state) {
          if (state is RoomsLoading) {
            return preloader;
          } else if (state is RoomsLoaded) {
            final newUsers = state.newUsers;
            final rooms = state.rooms;
            return BlocBuilder<ProfilesCubit, ProfilesState>(
              builder: (context, state) {
                if (state is ProfilesLoaded) {
                  final profiles = state.profiles;
                  return Column(
                    children: [
                      _NewUsers(newUsers: newUsers),
                      Expanded(
                        child: ListView.builder(
                          itemCount: rooms.length,
                          itemBuilder: (context, index) {
                            final room = rooms[index];
                            final otherUser = profiles[room.otherUserId];

                            return ListTile(
                              onTap: () => Navigator.of(context).push(
                                ChatPage.route(room.id, otherUser: otherUser),
                              ),
                              leading: CircleAvatar(
                                child: otherUser == null
                                    ? preloader
                                    : Text(otherUser.username.substring(0, 2)),
                              ),
                              title: Text(
                                otherUser == null
                                    ? 'Loading...'
                                    : otherUser.username,
                              ),
                              subtitle: room.lastMessage != null
                                  ? Text(
                                      room.lastMessage!.content,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : const Text('Chat Room created'),
                              trailing: Text(
                                format(
                                  room.lastMessage?.createdAt ?? room.createdAt,
                                  locale: 'en_short',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return preloader;
                }
              },
            );
          } else if (state is RoomsEmpty) {
            final newUsers = state.newUsers;
            return Column(
              children: [
                _NewUsers(newUsers: newUsers),
                const Expanded(
                  child: Center(
                    child: Text('Start a chat by tapping on available users'),
                  ),
                ),
              ],
            );
          } else if (state is RoomsError) {
            return Center(child: Text(state.message));
          }
          throw UnimplementedError();
        },
      ),
    );
  }
}

class _NewUsers extends StatelessWidget {
  const _NewUsers({Key? key, required this.newUsers}) : super(key: key);

  final List<Profile> newUsers;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: newUsers
            .map<Widget>(
              (user) => InkWell(
                onTap: () async {
                  try {
                    final roomId = await BlocProvider.of<RoomCubit>(
                      context,
                    ).createRoom(user.id);
                    Navigator.of(context).push(ChatPage.route(roomId, otherUser: user));
                  } catch (_) {
                    context.showErrorSnackBar(
                      message: 'Failed creating a new room',
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 60,
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Text(user.username.substring(0, 2)),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user.username,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
