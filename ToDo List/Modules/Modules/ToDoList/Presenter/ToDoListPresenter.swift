//
//  ToDoPresenter.swift
//  ToDo List
//
//  Created by Евгений Васильев on 08.09.2025.
//
protocol ToDoListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func refreshTasks()
    func addNewTask()
    func didSelectTask(_ task: ToDoItem)
    func searchTask(query: String)
    func toggleTaskCompletion(_ task: ToDoItem)
    func deleteTask(_ task: ToDoItem)
    func createTask(todo: String, completed: Bool)
}

class ToDoListPresenter: ToDoListPresenterProtocol {
    
    weak var view: ToDoListViewProtocol!
    var interactor: ToDoListInteractorProtocol!
    var router: ToDoListRouterProtocol!
    
    private(set) var tasks: [ToDoItem] = []
    
    func viewDidLoad() {
        view.showLoading()
        interactor.loadTasks()
        CoreDataManager.shared.setup { [weak self] success in
            guard success else {
                return
            }
            self?.interactor.loadTasks()
        }
    }
    
    func refreshTasks() {
        view.showLoading()
        interactor.refreshTasks()
    }
    
    func addNewTask() {
        router.navigateToCreateTask()
    }
    
    func didSelectTask(_ task: ToDoItem) {
        router.navigateToTaskDetails(task: task)
    }
    
    func searchTask(query: String) {
        interactor.searchTasks(query: query)
    }
    
    func toggleTaskCompletion(_ task: ToDoItem) {
        interactor.toggleTaskCompletion(task)
    }
    
    func deleteTask(_ task: ToDoItem) {
        interactor.deleteTask(task)
    }
    
    func createTask(todo: String, completed: Bool) {
        interactor.createTask(todo: todo, completed: completed)
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
