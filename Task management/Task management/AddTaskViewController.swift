//
//  AddTaskViewController.swift
//  Task management
//
//  Created by Ivan Ivanušić on 18.12.2020..
//

import UIKit

protocol AddTaskViewControllerDelegate {
    func addTask(data: [String])
}

class AddTaskViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var moreInfoField: UITextView!
    
    var delegate: AddTaskViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(addTaskTapped))
    }
    
    @objc func addTaskTapped() {
        guard let name = self.nameField.text else { return }
        
        if name == "" {
            let ac = UIAlertController(title: "Enter the name", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(ac, animated: true)
            return
        }

        let returnData: [String] = [name, self.moreInfoField.text]
        self.delegate?.addTask(data: returnData)
        self.navigationController?.popViewController(animated: true)
    }
}
