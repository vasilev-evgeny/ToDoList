//
//  ToDoDetailInterractor.swift
//  ToDo List
//
//  Created by Евгений Васильев on 04.09.2025.
//
class TaskDetailInteractor: TaskDetailInteractorProtocol {
    
    weak var presenter: TaskDetailPresenter!
    
    func updateTask(_ task: ToDoItem) {
        // Здесь можно:
        // - Сохранить в UserDefaults
        // - Отправить на сервер
        // - Обновить в списке
        print("Задача обновлена: \(task.todo)")
        // Можно вызвать callback, чтобы обновить список
    }
}
