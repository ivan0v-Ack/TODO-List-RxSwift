//
//  TaskListViewController.swift
//  ToDoListRxSwift
//
//  Created by Ivan Ivanov on 5/8/21.
//

import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    private var tasks = BehaviorRelay<[Task]>(value: [Task]())
    private var filteredTasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
   
    }
    
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let NavC = segue.destination as? UINavigationController,
        let TaskVC = NavC.viewControllers.first as? AddTaskViewController
        else { fatalError("Controller is not found...") }
        TaskVC.setTaskObj.subscribe(onNext: { [weak self] task in
            guard let self = self else { return }
            
            let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
         
            
            var existingTasks = self.tasks.value
            existingTasks.append(task)
            self.tasks.accept(existingTasks)
            self.filterTasks(by: priority)
           
          
        }).disposed(by: disposeBag)
    }
    
  
    @IBAction func segmentedControllerChangeValue(_ sender: UISegmentedControl) {
        let priority = Priority(rawValue: sender.selectedSegmentIndex - 1)
        filterTasks(by: priority)
    }
    
    private func upDateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func filterTasks(by priority: Priority?) {
        
        if priority == nil {
            filteredTasks = tasks.value
            upDateTableView()
         
        }else {
            
            tasks.map { tasks in
                return tasks.filter { $0.priority == priority}
            }.subscribe(onNext: { [weak self] tasks in
                self?.filteredTasks = tasks
                self?.upDateTableView()
               
            }).disposed(by: disposeBag)
        }
        
    }
    
}

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskTableViewCell", for: indexPath)
        let task = filteredTasks[indexPath.row]
        cell.textLabel?.text = task.titile
        
        return cell
    }
}
