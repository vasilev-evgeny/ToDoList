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
        let operationQueue = OperationQueue()
        let operation = BlockOperation {
            CoreDataManager.shared.updateTask(task)
        }
        operationQueue.addOperation(operation)
        print("Задача обновлена: \(task.todo)")
    }
    
    func createTask(id: Int, todo: String, completed: Bool, userId: Int) {
        let operationQueue = OperationQueue()
        let operation = BlockOperation {
            CoreDataManager.shared.createTask(
                id: id,
                todo: todo,
                completed: completed,
                userId: userId
            )
        }
        operationQueue.addOperation(operation)
        print("Новая задача создана: \(todo)")
    }
}
