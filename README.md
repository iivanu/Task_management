# Task management

Simple task management app, completely written in Swift 5.3. The design is made using storyboard, consisting of the elements: TableViewController, SearchController, Text Field, Text Label and Text View. Data is saved using Core Data framework.

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

When you launch app, you will be redirected to the "List of tasks" screen. There you can select "+" button in the right side
of the Navigation bar to add new task, write name and description and press "Done". When you add the task, your task will appear 
on the "List of tasks" screen. Then you can use Apple's swipe gestures for Table view cells to delete it or edit it. If you choose
"Edit", "Edit task" screen will appear where you can change name and description then press "Done" for saving.
At the top of the Table view, there is also a "Search" function where you can search through the "List of the tasks".
There is also a function for reordering list of the tasks. Press left button in the Navitaion bar "Reorder", then app will allow you
to drag task to another position. Press reorder again and your order will be saved and app will exit from the "Reordering mode".


# Screenshots
List of tasks           | Add task               | Edit task               |View task
:-------------------------:|:-------------------------:|:------------------------------:|:------------------------------:
![](https://i.imgur.com/UusQE4L.png) |  ![](https://i.imgur.com/C67NIxx.png) |  ![](https://i.imgur.com/Pzbn0TT.png) |  ![](https://i.imgur.com/4uZLLMm.png)

# Recordings
 Swipe gesture            | Search                | Reorder
:-------------------------:|:-------------------------:|:------------------------------:
![](https://i.imgur.com/fDOvnEa.gif) |  ![](https://i.imgur.com/wNIna83.gif) |  ![](https://i.imgur.com/Dg0wrQW.gif)
