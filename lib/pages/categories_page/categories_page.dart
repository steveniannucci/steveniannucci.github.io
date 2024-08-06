import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../database/database.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    final categoriesAsyncValue = ref.watch(puzzleCategoriesDataProvider);
    final puzzlesAsyncValue = ref.watch(puzzlesDataProvider);

    final Map<String, int> categoryCounts = {};
    
    puzzlesAsyncValue.when(
      data: (puzzles) {
        for (var puzzle in puzzles) {
          categoryCounts[puzzle.puzzleCategory] = (categoryCounts[puzzle.puzzleCategory] ?? 0) + 1;
        }
      },
      loading: () => null,
      error: (err, stack) => null,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        title: Text(
          'Categories',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddCategoryDialog(context),
          ),
        ],
      ),
      body: categoriesAsyncValue.when(
        data: (categories) => categories.isEmpty
            ? Center(
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'There\'s no categories right now.',
                      style: TextStyle(fontSize: kIsWeb ? 16 : 14),
                    ),
                    Text(
                      'You can make one by pressing the + button.',
                      style: TextStyle(fontSize: kIsWeb ? 16 : 14),
                    ),
                  ],
                ),
              )
            : ListView.separated(
                separatorBuilder: (context, index) => Divider(color: Color.fromARGB(255, 30, 30, 30), thickness: 2.0),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final puzzleCount = categoryCounts[category] ?? 0;
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(category),
                        Text('Number of Puzzles: $puzzleCount'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditCategoryDialog(context, category);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm'),
                                  content: RichText(
                                    text: TextSpan(
                                      text: 'Are you sure you want to delete ',
                                      style: TextStyle(
                                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(text: category, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
                                        TextSpan(text: '?'),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        ref.read(databaseProvider).deleteCategory(category).then((_) {
                                          ref.invalidate(puzzleCategoriesDataProvider);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Delete'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Future<void> _showAddCategoryDialog(BuildContext context) async {
    final TextEditingController newCategoryController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Puzzle Category'),
          content: TextFormField(
            controller: newCategoryController,
            decoration: InputDecoration(
              labelText: 'Category',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (newCategoryController.text.isNotEmpty) {
                  ref.read(databaseProvider).addCategory(newCategoryController.text).then((_) {
                    ref.invalidate(puzzleCategoriesDataProvider);
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditCategoryDialog(BuildContext context, String category) async {
    final TextEditingController editCategoryController = TextEditingController(text: category);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Puzzle Category'),
          content: TextFormField(
            controller: editCategoryController,
            decoration: InputDecoration(
              labelText: 'Category',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                if (editCategoryController.text.isNotEmpty) {
                  ref.read(databaseProvider).updateCategory(category, editCategoryController.text).then((_) {
                    ref.invalidate(puzzleCategoriesDataProvider);
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
