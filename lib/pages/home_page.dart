import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_essentials_kit/flutter_essentials_kit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:auto_route/auto_route.dart';
import 'package:telegram_app/cubits/auth/auth_cubit.dart';
import 'package:telegram_app/cubits/chats/chats_cubit.dart';
import 'package:telegram_app/cubits/scroll_cubit.dart';
import 'package:telegram_app/cubits/search_cubit.dart';
import 'package:telegram_app/mixin/search_component.dart';
import 'package:telegram_app/models/chat.dart';
import 'package:telegram_app/router/app_router.gr.dart';
import 'package:telegram_app/widgtes/chat_widget.dart';
// import 'package:telegram_app/widgtes/connectivity_widget.dart';
import 'package:telegram_app/extensions/user_display_name_initials.dart';
import 'package:telegram_app/widgtes/my_error_widget.dart';
import 'package:telegram_app/widgtes/shimmed_list.dart';


// class HomePage extends ConnectivityWidget {
class HomePage extends StatefulWidget {
  final User user;

  const HomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin, SearchComponentsMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,                                                              // passiamo vsync: this in quanto abbiamo implementato il TickerProviderStateMixin (this fa riferimento a questa istanza)
      duration: const Duration(milliseconds: 250),
      reverseDuration: const Duration(milliseconds: 250),
    );
    super.initState();
  }

  // PAGINA CONNESSA A INTERNET
  // In pratica per evitare IL SOLITO PROBLEMA ovvero che "context.read()" non riesce a recuperare il "Bloc" dalla "Gerarchia Dei Widget" e il MOTIVO E' SEMPLICE.
  // Stiamo utilizzando un "context" sbagliato, un "context" che stiamo passando ai nostri "children" che non ha ancora a disposizione lo "ScrollCubit".
  // Quindi la SOLUZIONE più immediata consiste nel wrappare lo Scaffold con un LayoutBuilder(builder: (context, _). il constraint lo ignoriamo in quanto la pagina non richiede nessuna restrizione.
  @override
  Widget build(_) => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => SearchCubit(),
      ),
      BlocProvider(
        create: (_) => ScrollCubit(),
      ),
      BlocProvider(
        create: (context) => ChatsCubit(
          // user.uid,
          widget.user.uid,
          chatRepository: context.read(),
        ),
      ),
    ],
    child: LayoutBuilder(
       builder: (context, _) => BlocBuilder<SearchCubit, bool>(
        // builder: (context, state) => Scaffold(
        builder: (context, isSearching) => Scaffold(
          // body: Container(color: Colors.orange),
              appBar: _appBar(context, isSearching: isSearching),
              drawer: _drawer(context),
              body: _body(context, isSearching: isSearching),
            ),
      ),
    ),
  );

  // Widget _appBar(BuildContext context) => AppBar(
  PreferredSizeWidget _appBar(
    BuildContext context, {
      bool isSearching = false
    }) =>
      AppBar(
        leading: LayoutBuilder(builder: (context, _) => IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow,
            progress: _animationController,
          ),
          onPressed: () {
            if (isSearching) {
              context.read<SearchCubit>().toggle();
              _animationController.reverse();
            } else {
              Scaffold.of(context).openDrawer();
            }
          },
        )),

        title: isSearching
          ? searchField(context)
          : Text(AppLocalizations.of(context)?.app_name ?? ''),
        actions: [
          if(!isSearching) IconButton(
            onPressed: () {
              context.read<SearchCubit>().toggle();
              _animationController.forward();
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      );

  Widget _drawer(BuildContext context) => Drawer(
    child: Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              _accountHeader(context),
              _newMessageButton(context),
            // _logoutButton(context),
            ],
          ),
        ),
        const Divider(height: 0),
        _logoutButton(context),
      ],
    ),
  );

  Widget _newMessageButton(BuildContext context) => ListTile(
    leading: const Icon(
        Icons.edit,
    ),
      title: Text(AppLocalizations.of(context)?.action_new_message ?? ''),
      onTap: () => context.router.push(NewMessageRoute(user: widget.user)),
  );

  Widget _accountHeader(BuildContext context) => UserAccountsDrawerHeader(
    accountName: widget.user.displayName != null ? Text(widget.user.displayName!) : null,
    accountEmail: widget.user.email != null ? Text(widget.user.email!) : null,
    currentAccountPicture: CircleAvatar(
      backgroundColor: Theme.of(context).platform == TargetPlatform.iOS ? Colors.blue : Colors.white,
      child: widget.user.displayName != null
          ? Text(
              // user.displayName!,
              widget.user.displayNameInitials,
              style: const TextStyle(
                color: Colors.black,
              ),
            )
          : Container(),
    ),
  );

  Widget _logoutButton(BuildContext context) => ListTile(
    leading: const Icon(Icons.logout),
    title: Text(AppLocalizations.of(context)?.action_logout ?? ''),
    onTap: () =>  _showLogoutDialog(context)
  );

  Widget _body(BuildContext context, {bool isSearching = false}) => Stack(
    children: [
      _chatsBody(context),
      _fab(isSearching: isSearching),
    ],
  );

  Widget _chatsBody(BuildContext context) => BlocBuilder<ChatsCubit, ChatsState>(
    builder: (context, state) {
      if(state is FetchedChatsState)  {
        return _chatsItems(context, chats: state.chats);
      } else if(state is NoChatsState) {
          return _noChatsWidget(context);
      } else if(state is ErrorChatsState) {
        return _chatsErrorWidget(context);
      }
      return _loadingItems();
    },
  );

  // In questa maniera costruiremo un widget di "Tipo ChaWidget()" i cui valori
  // però saranno vuoti e saranno di fatto dei segnaposto.
  Widget _loadingItems() => ShimmedList(
      child: ChatWidget.shimmed(),
  );

  Widget _chatsItems(BuildContext context, {required List<Chat> chats}) =>
    StreamBuilder<String?>(
      stream: context.watch<SearchCubit>().searchBinding.stream,
      builder: (context, snapshot) {
        final filteredChats = chats
          .where(
            (chat) =>
                !snapshot.hasData ||
                chat.displayName
                  .toLowerCase()
                  .contains(snapshot.data!.toLowerCase()) ||
                chat.lastMessage
                  .toLowerCase()
                  .contains(snapshot.data!.toLowerCase()),
          )
          .toList(growable: false);

        if(filteredChats.isEmpty) {
          return _chatsNotFoundWidget(context);
        }

        // Diversamente mostreremo l'elenco delle chats filtrate
        return NotificationListener<ScrollNotification>(
          child: ListView.builder(
            itemBuilder: (context, index) => ChatWidget(
              filteredChats[index],
              onTap: () => context.router.push(
                ChatRoute(
                  user: widget.user,
                  other: filteredChats[index].user!,
                ),
              ),
            ),
            // itemCount: chats.length,
            itemCount: filteredChats.length,
            ),
            onNotification: (notification) {
              if (notification is ScrollStartNotification) {
                context.read<ScrollCubit>().start();
              } else if(notification is ScrollEndNotification) {
                context.read<ScrollCubit>().stop();
              }
              return false;
            }
        );
      }
    );

  Widget _fab({isSearching = false}) => BlocBuilder<ScrollCubit, bool>(
    builder: (context, isScrolling) => AnimatedPositioned(
      duration: const Duration(milliseconds: 250),
      right: 24,
      bottom: isSearching || isScrolling ? -100 : 24,
      child: FloatingActionButton(
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
        onPressed: () => context.router.push(NewMessageRoute(user: widget.user)),
      ),
    ),
  );

  void _showLogoutDialog(BuildContext context) {
    if(WidgetsBinding.instance != null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)?.dialog_logout_title ?? ''),
            content: Text(AppLocalizations.of(context)?.dialog_logout_message ?? ''),
            actions: [
              TextButton(
                onPressed: () {
                  context.read<AuthCubit>().signOut();
                  context.router.pop();
                },
                child: Text(AppLocalizations.of(context)?.action_yes ?? ''),
              ),
              TextButton(
                onPressed: () => context.router.pop(),
                child: Text(AppLocalizations.of(context)?.action_no ?? ''),
              ),
            ],
          ),
        );
      });
    }
  }

  Widget _chatsNotFoundWidget(BuildContext context) => MyErrorWidget(
    icon: Icons.chat,
    subtitle: AppLocalizations.of(context)?.label_no_chats_found_msg ?? '',
  );

  Widget _noChatsWidget(BuildContext context) => MyErrorWidget(
      icon: Icons.chat,
      subtitle: AppLocalizations.of(context)?.label_no_chats_msg ?? '',
  );

  Widget _chatsErrorWidget(BuildContext context) => MyErrorWidget(
    icon: Icons.chat,
    title: AppLocalizations.of(context)?.label_error ?? '',
    subtitle: AppLocalizations.of(context)?.label_chat_list_error ?? '',
  );


}
