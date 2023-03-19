import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_essentials_kit/flutter_essentials_kit.dart';
import 'package:telegram_app/blocs/chat/chat_bloc.dart';
import 'package:telegram_app/blocs/friend_status/friend_status_bloc.dart';
import 'package:telegram_app/blocs/users/users_bloc.dart';
import 'package:telegram_app/cubits/user_cubit.dart';
import 'package:telegram_app/cubits/user_status/user_status_cubit.dart';
import 'package:timeago/timeago.dart' as timeago;                               // Per formatatre la data in modo più comprensibile all'utente
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:telegram_app/widgtes/connectivity_widget.dart';                 // Stabiliamo se l'app è connessa a Intenet oppure no
import 'package:telegram_app/models/user.dart' as models;                       // Interlocutore
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ANDIAMO AD IMPLEMENTARE QUESTA INTERFACCIA AutoRouteWrapper PER POTER INIETTARE I NOSTRI Bloc
class ChatPage extends ConnectivityWidget implements AutoRouteWrapper {
  final User user;
  final models.User other;

  ChatPage({Key? key, required this.user, required this.other}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => UserStatusCubit(
          other,
          userRepository: context.read(),
        ),
      ),
      BlocProvider(
        create: (context) => FriendStatusBloc(
          friendRepository: context.read(),
        )..fetchStatus(
            me: user.uid,
            user: other.id!,
        ),
      ),
      BlocProvider(
        create: (context) => ChatBloc(
          friendStatusBloc: context.read(),
          chatRepository: context.read(),
          messageRepository: context.read(),
        )..findChat(
            user: user.uid,
            other: other.id!,
        )
      ),
      BlocProvider(
        lazy: false,                                                            // Non de "lazy: false" così da permettere allo UserCubit di essere costruito immediatamente
        create: (context) => UserCubit(
          user.uid,
          userRepository: context.read(),
          chatBloc: context.read(),
        ),
      ),
    ],
    child: this,                                                                // this segnaposto di ChatPage
  );

  @override
  Widget connectedBuild(BuildContext context) =>
    BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) => Scaffold(
          appBar: _appBar(context, chatState: state),
          body: _body(context, state: state),
        ),
    );

    PreferredSizeWidget _appBar(BuildContext context, {required ChatState chatState}) =>
      AppBar(
        title: BlocConsumer<UserStatusCubit, UserStatusState>(
          listener: (context, state) {
            _shouldShowErrorSnackbar(context, state: state);
          },
          builder: (context, state) => Row(
              children: [
              _otherAvatar(),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _otherName(                                               // Giuseppe Rossi (interlocutore)
                        context,
                        other: state is UpdatedUserStatusState
                          ? state.user
                          : other,
                      ),
                      _otherLastAccess(
                        context,
                        other:
                          state is UpdatedUserStatusState ? state.user : other,

                      ),
                    ],
                  ),
                ),
              ],
            ),
        ),

        actions: () {
          final items = [
            if(chatState is ChatAvailableState)
              PopupMenuItem<_AppBarMenuActions>(
                child: Text(
                  AppLocalizations.of(context)?.action_delete_chat ?? '',
                ),
                value: _AppBarMenuActions.ACTION_DELETE,
              ),
          ];

          return items.isNotEmpty
            ? [
                PopupMenuButton<_AppBarMenuActions>(
                  itemBuilder: (_) => items,
                  onSelected: (action) {
                    if(_AppBarMenuActions.ACTION_DELETE == action) {
                      _showDeleteChatDialog(
                        context,
                        state: chatState as ChatAvailableState,
                      );
                    }
                  }
                )
              ]
            : null;
        }(),                                                                    // ATTENZIONE!!! voglio che su action: venga eseguita qeusta funzione anomima ()
      );

  Widget _body(BuildContext context, {required ChatState state}) =>  Column(
      children: [
        _messageBody(chatState: state),
        if(state is! ErrorChatState)
          _footer(context, disabled: state is FetchingChatState),
      ],
  );

  Widget _messageBody({required ChatState chatState}) => Expanded(
    child: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/telegram_background10.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: BlocBuilder<FriendStatusBloc, FriendStatusState>(
        builder: (context, friendStatusState) {
          final friends = friendStatusState is FetchedFriendStatusState &&
                            friendStatusState.friends;
          return Stack(
            children: [
              if(chatState is NoChatAvailableState &&
                  friendStatusState is FetchedFriendStatusState &&
                  !friendStatusState.friends)
                _noFriendsWidget(context),
              // In caso contrario
              if(chatState is NoChatAvailableState && friends)
                _noMessagesWidget(context),
              if(chatState is ErrorChatState || friendStatusState is ErrorFriendStatusState)
                _genericErrorWidget(context),
            ],
          );
        }
      ),
    ),
  );

  Widget _noFriendsWidget(BuildContext context) => Positioned(
    bottom: 16,
    left: 16,
    right: 16,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: Colors.grey[400]!),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)?.label_no_friends(other.displayName) ?? '',

          ),
        ],
      ),
    ),
  );

  Widget _genericErrorWidget(BuildContext context) => Positioned(
    bottom: 16,
    left: 16,
    right: 16,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: Colors.grey[400]!),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)?.label_chat_error ?? '',
          ),
        ],
      ),
    ),
  );

  // Nel caso in cui non siamo amici
  Widget _noMessagesWidget(BuildContext context) => Positioned(
    bottom: 16,
    left: 16,
    right: 16,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: Colors.grey[400]!),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)?.label_no_messages_available ?? '',
          ),
          MaterialButton(
            onPressed: () => context.read<ChatBloc>().sendMessage(
              user: user.uid,                                                   // lo user fi FirebaseAuth
              other: other.id!,                                                 // Interlocutore di User model
              message: AppLocalizations.of(context)?.action_hello ?? '',
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.handSparkles,
                  size: 16,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(AppLocalizations.of(context)?.action_say_hi(
                      other.displayName) ?? '',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _footer(BuildContext context, {bool disabled = false}) => Card(
    shape: const Border(),
    margin: EdgeInsets.zero,

    child: StreamBuilder<bool>(
      stream: context.watch<ChatBloc>().emptyChat,
      builder: (context, snapshot) => Row(
          children: [
            _emojiButton(disabled: disabled),
            _textField(context),
            if(!snapshot.hasData || snapshot.data!)
              _attachmentsButton(disabled: disabled),
            if(!snapshot.hasData || snapshot.data!)
              _audioButton(disabled: disabled),
            if(snapshot.hasData && !snapshot.data!)
              _sendMessageButton(context, disabled: disabled),
          ],
        )
    ),
  );

  Widget _emojiButton({bool disabled = false}) => IconButton(                   // Bottone per emoji :) disabled mi serve per disabilitare onPressed:
    icon: const Icon(
      Icons.emoji_emotions_outlined,
    ),
    onPressed: disabled ? null : () {},
  );

  Widget _textField(BuildContext context) => Expanded(
    child: TwoWayBindingBuilder<String>(
      binding: context.watch<ChatBloc>().messageBinding,
      builder: (context, controller, data, onChanged, error) =>
        TextField(
          minLines: 1,
          maxLines: 6,
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            errorText: error?.localizedString(context),

            hintText: AppLocalizations.of(context)?.label_message ?? '',
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.text,
        ),
    ),
  );

  Widget _attachmentsButton({bool disabled = false}) => IconButton(
    icon: const Icon(Icons.attachment),
    onPressed: disabled ? null : () {},
  );

  Widget _audioButton({bool disabled = false}) => IconButton(
    onPressed: disabled ? null :() {},                                          //  Se disabled è true è vuoto altrimenti mostriamo IconButton moccato
    icon: const Icon(Icons.mic),
  );

  Widget _sendMessageButton(BuildContext context, {bool disabled = false}) => IconButton(
    icon: const Icon(
      Icons.send,
      color: Colors.blue,
    ),
    onPressed: disabled ? null : () => context.read<ChatBloc>().sendMessage(    //  Se disabled è true è vuoto altrimenti mostriamo IconButton moccato.
      user: user.uid,
      other: other.id!,
    ),
  );


  Widget _otherAvatar() =>CircleAvatar(
    child: Text(other.initials),
  );

  Widget _otherName(BuildContext context, {required models.User other}) => Text(
    other.displayName,
    style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.white),  // headline DEPRECATO dovrei usare "titleLarge" / "headlineLarge"
                                                                                  // GUARDARE LE ALTERNATIVE A headline https://api.flutter.dev/flutter/material/TextTheme/titleLarge.html
  );

  Widget _otherLastAccess(BuildContext context, {required models.User other}) => Text(
    other.lastAccess != null
      ? timeago.format(
          other.lastAccess!,
          locale: AppLocalizations.of(context)?.localeName,
        )
      : AppLocalizations.of(context)?.label_last_access ?? '',
        // style: Theme.of(context).textTheme.caption?.copyWith(                // rende legegrmente più piccolo in modo tali che si adatti perfettamente all'interno della nostra AppBar()
        style: Theme.of(context).textTheme.caption?.copyWith(                       // caption DEPRECATO dovrei usare "bodySmall"
          color: Colors.white70,
        ),
  );

  void _shouldShowErrorSnackbar(
    BuildContext context, {
    required UserStatusState state}
  ) {
    if(WidgetsBinding.instance != null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if(state is ErrorUsersState) {
          final scaffold = ScaffoldMessenger.of(context);

          scaffold.showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)?.label_other_error ?? ''),
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: AppLocalizations.of(context)?.action_ok ?? '',
                onPressed: scaffold.hideCurrentSnackBar,
              ),
            ),
          );
        }
      });
    }
  }

  void _showDeleteChatDialog(
    BuildContext context, {
    required ChatAvailableState state,
  }) {
    if(WidgetsBinding.instance != null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        showDialog(context: context, builder: (_) => AlertDialog(
          title: Text(AppLocalizations.of(context)?.dialog_delete_chat_title ?? ''),
          content: Text(AppLocalizations.of(context)?.dialog_delete_chat_message ?? ''),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)?.action_yes ?? ''),
              onPressed: () {
                context.read<ChatBloc>().deleteChat(
                  state.chat.id!,
                  streamSubscription: state.streamSubscription);
                  context.router.pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)?. action_no ?? ''),
              onPressed: () => context.router.pop(),
            ),
          ],
        ));
      });
    }
  }
}

enum _AppBarMenuActions {                                                       // QUI aggiungiamo l'unica azione disponibile per PoUpMenuButton() che aveva bisogno di un Tipo come argomento
  ACTION_DELETE,
}


