//
//  ToDoDetailRouter.swift
//  ToDo List
//
//  Created by Евгений Васильев on 04.09.2025.
//
import UIKit

class TaskDetailRouter: TaskDetailRouterProtocol {
    
    weak var viewController: TaskDetailViewController?
    
    func close() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    // Фабрика для создания модуля
    static func createModule(task: ToDoItem) -> UIViewController {
        let view = TaskDetailViewController()
        let interactor = TaskDetailInteractor()
        let presenter = TaskDetailPresenter(task: task)
        let router = TaskDetailRouter()
        
        // Связываем всё вместе
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        
        router.viewController = view
        
        return view
    }
}
