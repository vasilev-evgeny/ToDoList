//
//  ToDoPresenter.swift
//  ToDo List
//
//  Created by Евгений Васильев on 08.09.2025.
//
protocol ToDoListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func addNewTask()
    func didSelectTask(_ task: ToDoItem)
    func searchTask(query: String)
}

class ToDoListPresenter: ToDoListPresenterProtocol {
    
    weak var view: ToDoListViewProtocol!
    var interactor: ToDoListInteractorProtocol!
    var router: ToDoListRouterProtocol!
    
    private var tasks: [ToDoItem] = []
    
    func viewDidLoad() {
        view.showLoading()
        interactor.loadTasks()
    }
    
    func addNewTask() {
        router.navigateToCreateTask()
    }
    
    func didSelectTask(_ task: ToDoItem) {
        router.navigateToTaskDetails(task: task)
    }
    
    func searchTask(query: String) {
        if query.isEmpty {
            view.showTasks(tasks) 
        } else {
            interactor.searchTasks(query: query)
        }
    }
    
    // MARK: - Callbacks from Interactor
    
    func didLoadTasks(_ tasks: [ToDoItem]) {
        self.tasks = tasks
        view.hideLoading()
        view.showTasks(tasks)
    }
    
    func didFailWithError(_ error: String) {
        view.hideLoading()
        view.showError(error)
    }
}
