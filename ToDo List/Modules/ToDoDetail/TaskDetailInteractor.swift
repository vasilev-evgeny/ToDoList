//
//  ToDoDetailInterractor.swift
//  ToDo List
//
//  Created by Евгений Васильев on 04.09.2025.
//
import Foundation
class TaskDetailInteractor: TaskDetailInteractorProtocol {
    
    weak var presenter: TaskDetailPresenter!
    
    func updateTask(_ task: ToDoItem) {
            // Обновляем задачу в CoreData
            let operationQueue = OperationQueue()
            let operation = BlockOperation {
                CoreDataManager.shared.updateTask(task)
            }
            operationQueue.addOperation(operation)
            
            print("Задача обновлена: \(task.todo)")
        }
}
