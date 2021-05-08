//
//  AddTaskViewController.swift
//  ToDoListRxSwift
//
//  Created by Ivan Ivanov on 5/8/21.
//

import UIKit
import RxSwift
import RxCocoa



class AddTaskViewController: UIViewController {
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    
    private let taskObject = PublishSubject<Task>()
     var setTaskObj: Observable<Task> {
        return taskObject.asObserver()
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func saveBtn(_ sender: UIBarButtonItem) {
        guard let priority = Priority(rawValue: segmentedController.selectedSegmentIndex) , let title = textField.text else { return }
        
        let task = Task(titile: title, priority: priority)
        taskObject.onNext(task)
        self.dismiss(animated: true, completion: nil)
    }
}
