//
//  ToDoInteractor.swift
//  ToDo List
//
//  Created by Евгений Васильев on 08.09.2025.
//
// ToDoInteractor.swift
import Foundation

protocol ToDoListInteractorProtocol: AnyObject {
    func loadTasks()
    func searchTasks(query: String)
    func toggleTaskCompletion(_ task: ToDoItem)
    func deleteTask(_ task: ToDoItem)
    func createTask(todo: String, completed: Bool)
    func loadTasksFromNetwork() // Новый метод для загрузки из сети
}

class ToDoListInteractor: ToDoListInteractorProtocol {
    
    weak var presenter: ToDoListPresenter!
    private let operationQueue = OperationQueue()
    
    func loadTasks() {
        let operation = BlockOperation { [weak self] in
            // Сначала проверяем, есть ли задачи в CoreData
            CoreDataManager.shared.fetchTasks { tasks in
                if tasks.isEmpty {
                    // Если задач нет, загружаем из сети
                    self?.loadTasksFromNetwork()
                } else {
                    // Если есть, показываем из CoreData
                    DispatchQueue.main.async {
                        self?.presenter.didLoadTasks(tasks)
                    }
                }
            }
        }
        operationQueue.addOperation(operation)
    }
    
    func loadTasksFromNetwork() {
        let operation = BlockOperation { [weak self] in
            NetworkManager.shared.fetchTasks { [weak self] result in
                switch result {
                case .success(let tasks):
                    // Сохраняем задачи в CoreData
                    self?.saveTasksToCoreData(tasks)
                    // Показываем задачи
                    DispatchQueue.main.async {
                        self?.presenter.didLoadTasks(tasks)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.presenter.didFailWithError(error.localizedDescription)
                    }
                }
            }
        }
        operationQueue.addOperation(operation)
    }
    
    private func saveTasksToCoreData(_ tasks: [ToDoItem]) {
        let backgroundContext = CoreDataManager.shared.persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            for task in tasks {
                let taskEntity = TaskEntity(context: backgroundContext)
                taskEntity.id = Int64(task.id)
                taskEntity.todo = task.todo
                taskEntity.completed = task.completed
                taskEntity.userId = Int64(task.userId)
            }
            
            do {
                try backgroundContext.save()
                print("Successfully saved \(tasks.count) tasks to CoreData")
            } catch {
                print("Error saving tasks to CoreData: \(error)")
            }
        }
    }
    
    func searchTasks(query: String) {
        let operation = BlockOperation { [weak self] in
            if query.isEmpty {
                CoreDataManager.shared.fetchTasks { tasks in
                    DispatchQueue.main.async {
                        self?.presenter.didLoadTasks(tasks)
                    }
                }
            } else {
                CoreDataManager.shared.searchTasks(query: query) { tasks in
                    DispatchQueue.main.async {
                        self?.presenter.didLoadTasks(tasks)
                    }
                }
            }
        }
        operationQueue.addOperation(operation)
    }
    
    func toggleTaskCompletion(_ task: ToDoItem) {
        let operation = BlockOperation {
            var updatedTask = task
            updatedTask.completed.toggle()
            CoreDataManager.shared.updateTask(updatedTask)
        }
        operationQueue.addOperation(operation)
    }
    
    func deleteTask(_ task: ToDoItem) {
        let operation = BlockOperation {
            CoreDataManager.shared.deleteTask(task)
        }
        operationQueue.addOperation(operation)
    }
    
    func createTask(todo: String, completed: Bool) {
        let operation = BlockOperation {
            // Генерируем уникальный ID
            let id = Int.random(in: 1000...9999)
            let userId = 1
            
            CoreDataManager.shared.createTask(
                id: id,
                todo: todo,
                completed: completed,
                userId: userId
            )
        }
        operationQueue.addOperation(operation)
    }
}
