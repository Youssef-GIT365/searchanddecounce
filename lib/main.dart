import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:searchanddecounce/controller/search_cubit.dart';
import 'package:searchanddecounce/controller/search_state.dart';

void main() {
  runApp(BlocProvider(create: (_) => SearchCubit(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchScreen());
  }
}

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Smart Search")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              onChanged: (value) {
                context.read<SearchCubit>().onSearchChanged(value);
              },
              decoration: InputDecoration(
                hintText: "Search...",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state is SearchResults) {
                  return ListView.builder(
                    itemCount: state.results.length,
                    itemBuilder: (_, i) =>
                        ListTile(title: Text(state.results[i])),
                  );
                }

                if (state is SearchHistoryState) {
                  return ListView.builder(
                    itemCount: state.history.length,
                    itemBuilder: (_, i) => ListTile(
                      leading: Icon(Icons.history),
                      title: Text(state.history[i]),
                    ),
                  );
                }

                return Center(child: Text("Start typing..."));
              },
            ),
          ),
        ],
      ),
    );
  }
}
