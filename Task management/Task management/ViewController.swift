//
//  ViewController.swift
//  Task management
//
//  Created by Ivan Ivanušić on 18.12.2020..
//

import UIKit

enum ActionType: Int {
    case add
    case view
    case update
}

class ViewController: UITableViewController {
    var items: [Task]?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searching = false
    var searchedItems: [Task]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Task management"
        self.searchBar.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskTapped))
        
        self.fetchData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searching {
            return self.searchedItems!.count
        } else if let items = self.items {
            return items.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        var task: Task
        if self.searching {
            task = self.searchedItems![indexPath.row]
        } else {
            task = self.items![indexPath.row]
        }
        cell.textLabel?.text = task.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if !self.searching {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
                let taskToRemove = self.items![indexPath.row]
                self.context.delete(taskToRemove)
                
                self.saveAndReloadData()
            }
            
            let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
                guard let vc = self.storyboard?.instantiateViewController(identifier: "Task") as? TaskViewController else {
                    return
                }
                vc.actionType = .update
                vc.name = self.items![indexPath.row].name
                vc.more_info = self.items![indexPath.row].more_info
                vc.index = indexPath.row
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "Task") as? TaskViewController else {
            return
        }
        
        vc.actionType = .view
        if self.searching {
            vc.name = self.searchedItems![indexPath.row].name
            vc.more_info = self.searchedItems![indexPath.row].more_info
        } else {
            vc.name = self.items![indexPath.row].name
            vc.more_info = self.items![indexPath.row].more_info
        }

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addTaskTapped() {
        guard let vc = storyboard?.instantiateViewController(identifier: "Task") as? TaskViewController else {
            return
        }
        
        vc.actionType = .add
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: TaskViewControllerDelegate {
    func addTask(taskName: String, taskMoreinfo: String) {
        let newTask = Task(context: self.context)
        newTask.name = taskName
        newTask.more_info = taskMoreinfo
        
        self.saveAndReloadData()
    }
    
    func editTask(taskName: String, taskMoreinfo: String, taskPosition: Int) {
        let task = self.items![taskPosition]
        task.name = taskName
        task.more_info = taskMoreinfo
        
        self.saveAndReloadData()
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let items = self.items else { return }
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

extension ViewController {
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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
        }
    }
}
