//  ToDoDetailPresenter.swift
//  ToDo List
//
//  Created by Евгений Васильев on 04.09.2025.
//

class TaskDetailPresenter: TaskDetailPresenterProtocol {
    
    weak var view: TaskDetailViewProtocol!
    var interactor: TaskDetailInteractorProtocol!
    var router: TaskDetailRouterProtocol!
    
    private var task: ToDoItem?
    private var isNewTask: Bool = false
    
    init(task: ToDoItem?) {
        self.task = task
        self.isNewTask = task == nil
    }
    
    func viewDidLoad() {
        if let task = task {
            view.displayTask(task)
        } else {
            view.setupForCreateMode()
        }
    }
    
    func didRequestToClose() {
        if isNewTask {
            router.close()
        } else if let task = task {
            interactor.updateTask(task)
            router.close()
        }
    }
    
    func updateTaskTitle(_ title: String) {
        task?.todo = title
    }
    
    func updateTaskDescription(_ description: String) {
        task?.todo = description
    }
    
    func createNewTask(title: String, description: String) {
        let id = Int.random(in: 1000...9999)
        let userId = 1
        
        interactor.createTask(
            id: id,
            todo: description.isEmpty ? "Новая задача" : description,
            completed: false,
            userId: userId
        )
        router.closeWithNewTask()
    }
    
    func isCreatingNewTask() -> Bool {
        return isNewTask
    }
}
