//
//  ViewController.swift
//  Task management
//
//  Created by Ivan Ivanušić on 18.12.2020..
//

import UIKit

class ViewController: UITableViewController, AddTaskViewControllerDelegate {
    
    var items: [Task]?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskTapped))
        
        fetchData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = items else { return 0 }
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = self.items![indexPath.row]
        cell.textLabel?.text = task.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let taskToRemove = self.items![indexPath.row]
            self.context.delete(taskToRemove)
            
            self.saveAndReloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
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
    
    func addTask(data: [String]) {
        let newTask = Task(context: self.context)
        newTask.name = data[0]
        newTask.more_info = data[1]
        
        self.saveAndReloadData()
    }
    
    @objc func addTaskTapped() {
        guard let vc = storyboard?.instantiateViewController(identifier: "AddTask") as? AddTaskViewController else {
            return
        }
        
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

