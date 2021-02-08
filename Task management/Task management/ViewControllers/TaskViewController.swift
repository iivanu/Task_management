//
//  TaskViewController.swift
//  Task management
//
//  Created by Ivan Ivanušić on 18.12.2020..
//

import UIKit

protocol TaskViewControllerDelegate: class {
    func addTask(taskName: String, taskMoreinfo: String)
    func editTask(taskName: String, taskMoreinfo: String, taskPosition: Int)
}

class TaskViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var moreInfoField: UITextView!
    
    weak var delegate: TaskViewControllerDelegate?
    private var actionType: ActionType?
    private var name: String?
    private var more_info: String?
    private var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if (traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)) {
                self.nameField.layer.borderColor = self.nameField.textColor?.cgColor
                self.moreInfoField.layer.borderColor = self.moreInfoField.textColor?.cgColor
            }
        }
    }
    
    func setUI() {
        self.nameField.layer.borderWidth = 1
        self.moreInfoField.layer.borderWidth = 1
        self.nameField.layer.cornerRadius = 5
        self.moreInfoField.layer.cornerRadius = 5
        self.nameField.layer.borderColor = self.nameField.textColor?.cgColor
        self.moreInfoField.layer.borderColor = self.moreInfoField.textColor?.cgColor
        
        guard let actionType = self.actionType else { return }
        switch actionType {
        case .add:
            self.title = "Add task"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
            return
        case .readAndUpdate:
            self.title = "Edit task"
            self.nameField.text = self.name ?? ""
            self.moreInfoField.text = self.more_info ?? ""
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
            return
        }
    }
    
    @objc func doneTapped() {
        guard let name = self.nameField.text else { return }
        if name == "" {
            let ac = UIAlertController(title: "Please enter the name.", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true)
            return
        }
        
        switch self.actionType {
        case .add:
            self.delegate?.addTask(taskName: name, taskMoreinfo: self.moreInfoField.text)
        case .readAndUpdate:
            self.delegate?.editTask(taskName: name, taskMoreinfo: self.moreInfoField.text, taskPosition: self.index!)
        default:
            return
        }
        
        self.dismiss(animated: true)
    }
}

extension TaskViewController {
    func setActionType(actionType: ActionType?) {
        self.actionType = actionType
    }
    
    func setName(name: String?) {
        self.name = name
    }
    
    func setMoreInfo(more_info: String?) {
        self.more_info = more_info
    }
    
    func setIndex(index: Int?) {
        self.index = index
    }
}
