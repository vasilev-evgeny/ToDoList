//
//  TaskDetailProtocols.swift
//  ToDo List
//
//  Created by Евгений Васильев on 08.09.2025.
//
import UIKit

// MARK: - View
protocol TaskDetailViewProtocol: AnyObject {
    func displayTask(_ task: ToDoItem)
    func setupForCreateMode()
}

// MARK: - Presenter
protocol TaskDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didRequestToClose()
    func updateTaskTitle(_ title: String)
    func updateTaskDescription(_ description: String)
    func createNewTask(title: String, description: String)
    func isCreatingNewTask() -> Bool
}

// MARK: - Interactor
protocol TaskDetailInteractorProtocol: AnyObject {
    func updateTask(_ task: ToDoItem)
    func createTask(id: Int, todo: String, completed: Bool, userId: Int)
}

// MARK: - Router
protocol TaskDetailRouterProtocol: AnyObject {
    func close()
    func closeWithNewTask()
}
