import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repository_provider/bloc/user_bloc.dart';
import 'package:repository_provider/bloc/user_event.dart';
import 'package:repository_provider/data/model/user_model.dart';
import 'package:repository_provider/data/provider/user_provider.dart';
import 'package:repository_provider/data/repository/user_repository.dart';

import 'bloc/user_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: RepositoryProvider(
          create: (context) => UserRepository(UserProvider()),
          child: BlocProvider(
            create: (context) => UserBloc(context.read<UserRepository>()),
            child: const MyHomePage(),
          ),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Repository Provider'),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UserErrorState) {
            return const Center(child: Text("Error"));
          }
          if (state is UserSucessState) {
            List<Datum> userList = state.userModel.data;
            return userList.isNotEmpty
                ? ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: Card(
                          child: ListTile(
                            title: Text(
                                '${userList[index].firstName} ${userList[index].lastName}'),
                            subtitle: Text('${userList[index].email}'),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  userList[index].avatar.toString()),
                            ),
                          ),
                        ),
                      );
                    })
                : const Center(child: Text("No Data Found"));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<UserBloc>().add(LoadUserEvent());
        },
        child: const Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
