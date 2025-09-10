//
//  ToDoRouter.swift
//  ToDo List
//
//  Created by Евгений Васильев on 08.09.2025.
//

import UIKit

protocol ToDoListRouterProtocol: AnyObject {
    func navigateToTaskDetails(task: ToDoItem?)
    func navigateToCreateTask()
}

class ToDoListRouter: ToDoListRouterProtocol {
    
    weak var viewController: ToDoListViewController?
    
    static func createModule() -> UIViewController {
        let view = ToDoListViewController()
        let interactor = ToDoListInteractor()
        let presenter = ToDoListPresenter()
        let router = ToDoListRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    func navigateToTaskDetails(task: ToDoItem?) {
        let detailViewController = TaskDetailRouter.createModule(task: task)
        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func navigateToCreateTask() {
        navigateToTaskDetails(task: nil) 
    }
}
