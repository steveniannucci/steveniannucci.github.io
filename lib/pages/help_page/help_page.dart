// help_page.dart

import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final List<Map<String, String>> faqs = [
    {
      "question": "Creating puzzles",
      "answer": "After creating the first puzzle, you can create as many as want via the Create Puzzle option in the three dot menu on the home page. You can give the puzzle a name, assign it an existing category or make a new one, set a deadline, choose the number of pieces, and upload a reward image from your device. If you don't give the puzzle a name and/or if you don't assign a category to a puzzle, it/they will be blank. Even if the puzzle category is already filled in, you'll need to select it again from the dropdown menu to assign it. If you don't set a deadline, the puzzle's deadline will be set to the current date and time and hence, it will be expired. The number of pieces would also be set to 1 by default. If you made a mistake, you can always edit the puzzle once it's created."
    },
    {
      "question": "Editing puzzles",
      "answer": "When clicking or tapping on a puzzle, you will be sent to that puzzle's page where you may manipulate the puzzle in any way you wish. You can edit the puzzle itself via the Edit Puzzle option in the three dot menu. Here you may edit the puzzle's name, category, deadline, number of pieces, and reset the starting time by clicking or tapping the checkbox. If the checkbox is checked when you save your changes, the number of gems will be reset for that puzzle. If you changed the number of pieces, all the checkboxes will be reset to prevent errors. The only thing you can't change is the reward image. This is only possible when creating a new puzzle."
    },
    {
      "question": "Resetting expired puzzles",
      "answer": "When you click or tap on an expired puzzle or watch a puzzle expire, the task list will be hidden. You may update the deadline in the Edit Puzzle option in the three dot menu to make the puzzle active again. However, the puzzle will only be active again when you set the deadline before the current date and time. For example, if it's 11:59 PM on Saturday and you set the deadline to 11:59 AM on that same Saturday, the puzzle will remain expired. If it's 11:59 PM on Saturday and you set the deadline to Sunday or the next day at 11:59 AM, the puzzle will be active again until that time."
    },
    {
      "question": "Adding a reward image",
      "answer": "When creating a puzzle, you will be able to add a reward image that will have its pieces unveiled as you complete the tasks. You may upload a jpg, jpeg, png, webp, or gif file from your device. If you choose to upload a gif, the gif will not be a still image. You'll need to convert the gif to one of the other file types outside the app if you prefer a still image. If you don't upload an image, the default asset will take its place.\n\nDeveloper's recommendation: For the reward image, I would use a close up of a character's or person's face or an object. You can do this by cropping and saving the image outside the app via an image editor or an app that has image editing features."
    },
    {
      "question": "Managing categories",
      "answer": "You can add, rename, or delete categories for your puzzles on the Manage Categories option in the three dot menu on the home page. This screen also keeps track of the number of puzzles that were assigned each category. If you want to only access the puzzles that were assigned a specific category, you'll need to return to the home page and click or tap the dropdown menu at the top of the screen. Then you can select the category you want to view."
    },
    {
      "question": "Settings",
      "answer": "On the settings page, you can turn on dark mode as well as export and import data. When importing data, you must choose a file you previously exported from this app in order for this option to work. The exported file's name will be puzzleData.json or puzzleData (1).json, etc. If you rename the file, the import should still work assuming that it's a json file that was exported via the Export Data option and that the data structure wasn't altered."
    },
    {
      "question": "Notifications",
      "answer": "Push notifications are only available on mobile platforms due to the intrusiveness of alerts on browsers. On mobile, you can turn on notifications to let you know when puzzles have expired or are going to expire. I plan to set these notification for each gem interval in the puzzle as the timer ticks down. However, there may be limits to what can be done with the feature and it's still a work in progress at this time."
    }
  ];
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        title: Text(
          'Help',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(faqs[index]["question"]!),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(faqs[index]["answer"]!),
              ),
            ],
          );
        },
      ),
    );
  }
}