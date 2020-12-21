# Task management
A simple task management app, completely written in Swift 5.3. The design is made using storyboard, consisting of the elements: TableViewController, SearchController, Text Field, Text Label and Text View. Data is saved using Core Data framework.

# Compatibility
The app is compatible with iPhone and iPad devices.
The app is locked in the portrait mode.
Tested on iOS 14.3 and XCode 12.3.
Tested on iPhone Xs Max.

# Usage
The app has 4 screens:
1. List of tasks
2. Add task
3. Edit task
4. View task

When you launch the app, you will be redirected to the "List of tasks" screen. There you can select "+" button on the right side
of the Navigation bar to add a new task, write its name and description and press "Done". When you add the task, your task will appear 
on the "List of tasks" screen. Then you can use Apple's swipe gesture for the Table view cells to delete or edit the task. If you choose
"Edit", the "Edit task" screen will appear and there you can change the name and the description and save it by pressing "Done".
At the top of the Table view, there is also a "Search" bar where you can search through the "List of tasks".
There is also a function for reordering the "List of tasks" by pressing the left button in the Navigation bar "Reorder", then the app will allow you
to drag the task to a different position. Press "Reorder" again and your order will be saved and the app will exit "Reordering mode".


# Screenshots
List of tasks           | Add task               | Edit task               |View task
:-------------------------:|:-------------------------:|:------------------------------:|:------------------------------:
![](https://i.imgur.com/UusQE4L.png) |  ![](https://i.imgur.com/C67NIxx.png) |  ![](https://i.imgur.com/Pzbn0TT.png) |  ![](https://i.imgur.com/4uZLLMm.png)

# Recordings
 Swipe gesture            | Search                | Reorder
:-------------------------:|:-------------------------:|:------------------------------:
![](https://i.imgur.com/fDOvnEa.gif) |  ![](https://i.imgur.com/wNIna83.gif) |  ![](https://i.imgur.com/Dg0wrQW.gif)
