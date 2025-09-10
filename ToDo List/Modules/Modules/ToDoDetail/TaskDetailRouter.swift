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
        notifyListToRefresh()
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func closeWithNewTask() {
        notifyListToRefresh()
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    private func notifyListToRefresh() {
        if let navigationController = viewController?.navigationController {
            for viewController in navigationController.viewControllers {
                if let listVC = viewController as? ToDoListViewController {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        listVC.presenter.viewDidLoad()
                    }
                    break
                }
            }
        }
    }
    
    static func createModule(task: ToDoItem?) -> UIViewController {
        let view = TaskDetailViewController()
        let interactor = TaskDetailInteractor()
        let presenter = TaskDetailPresenter(task: task)
        let router = TaskDetailRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
