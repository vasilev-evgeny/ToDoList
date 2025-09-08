//
//  ToDoDetailPresenter.swift
//  ToDo List
//
//  Created by Евгений Васильев on 04.09.2025.
//
class TaskDetailPresenter: TaskDetailPresenterProtocol {
    
    weak var view: TaskDetailViewProtocol!
    var interactor: TaskDetailInteractorProtocol!
    var router: TaskDetailRouterProtocol!
    
    private var task: ToDoItem
    
    init(task: ToDoItem) {
        self.task = task
    }
    
    func viewDidLoad() {
        view.displayTask(task)
    }
    
    func didRequestToClose() {
        interactor.updateTask(task)
        router.close()
    }
    
    func updateTaskTitle(_ title: String) {
        task.todo = title
    }
}
