//
//  ViewController.swift
//  Task management
//
//  Created by Ivan Ivanušić on 18.12.2020..
//

import UIKit

enum ActionType: Int {
    case add
    case readAndUpdate
}

class MainViewController: UITableViewController {
    private var items = [Task]()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var searchBar: UISearchBar!
    private var searchedItems = [Task]()
    private var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Task management"
        self.searchBar.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskTapped))
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        self.fetchData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searching {
            return self.searchedItems.count
        }
        
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var task: Task
        if self.searching {
            task = self.searchedItems[indexPath.row]
        } else {
            task = self.items[indexPath.row]
        }
        cell.textLabel?.text = task.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            var taskToRemove: Task
            if self.searching {
                taskToRemove = self.searchedItems[indexPath.row]
                self.searchedItems.remove(at: indexPath.row)
            } else {
                taskToRemove = self.items[indexPath.row]
            }
            self.context.delete(taskToRemove)
            self.rewriteOrderNums()
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "Task") as? TaskViewController else {
            return
        }
        let navBarOnVC: UINavigationController = UINavigationController(rootViewController: vc)
        
        var index: Int
        if self.searching {
            index = Int(self.searchedItems[indexPath.row].order_id)
        } else {
            index = indexPath.row
        }
        vc.setActionType(actionType: .readAndUpdate)
        vc.delegate = self
        vc.setName(name: self.items[index].name)
        vc.setMoreInfo(more_info: self.items[index].more_info)
        vc.setIndex(index: index)
        
        self.navigationController?.present(navBarOnVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedTask = self.items[sourceIndexPath.row]
        self.items.remove(at: sourceIndexPath.row)
        self.items.insert(movedTask, at: destinationIndexPath.row)
        
        rewriteOrderNums()
    }
}

extension MainViewController: TaskViewControllerDelegate {
    func addTask(taskName: String, taskMoreinfo: String) {
        let newTask = Task(context: self.context)
        newTask.name = taskName
        newTask.more_info = taskMoreinfo
        newTask.order_id = Int32(self.items.count + 1)
        
        rewriteOrderNums()
    }
    
    func editTask(taskName: String, taskMoreinfo: String, taskPosition: Int) {
        let task = self.items[taskPosition]
        task.name = taskName
        task.more_info = taskMoreinfo
        
        self.saveAndReloadData()
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchedItems = items.filter { $0.name!.lowercased().prefix(searchText.count) == searchText.lowercased() }
        self.searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searching = false
        searchBar.text = ""
        searchBar.endEditing(true)
        tableView.reloadData()
    }
}

extension MainViewController {
    func saveAndReloadData() {
        do {
            try self.context.save()
        } catch {
        }
        
        self.fetchData()
    }
    
    func fetchData() {
        do {
            self.items = try context.fetch(Task.fetchRequest())
            self.items.sort(by: { $0.order_id < $1.order_id })
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
        }
    }
    
    func rewriteOrderNums() {
        for index in 0..<self.items.count {
            if self.items[index].order_id != Int32(index) {
                self.items[index].order_id = Int32(index)
            }
        }
        
        self.saveAndReloadData()
    }
    
    @objc private func addTaskTapped() {
        guard let vc = storyboard?.instantiateViewController(identifier: "Task") as? TaskViewController else {
            return
        }
        let navBarOnVC: UINavigationController = UINavigationController(rootViewController: vc)
        
        vc.setActionType(actionType: .add)
        vc.delegate = self
        self.present(navBarOnVC, animated: true, completion: nil)
    }
}
