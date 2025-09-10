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
    func toggleTaskCompletion(_ task: ToDoItem)
    func deleteTask(_ task: ToDoItem)
    func createTask(todo: String, completed: Bool)
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
        interactor.searchTasks(query: query)
    }
    
    func toggleTaskCompletion(_ task: ToDoItem) {
        interactor.toggleTaskCompletion(task)
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].completed.toggle()
            view.showTasks(tasks)
        }
    }
    
    func deleteTask(_ task: ToDoItem) {
        interactor.deleteTask(task)
        tasks.removeAll { $0.id == task.id }
        view.showTasks(tasks)
    }
    
    func createTask(todo: String, completed: Bool) {
        interactor.createTask(todo: todo, completed: completed)
        // После создания перезагружаем задачи
        interactor.loadTasks()
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
