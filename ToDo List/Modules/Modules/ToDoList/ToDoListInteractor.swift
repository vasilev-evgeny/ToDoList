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
    func refreshTasks() // Добавляем новый метод
    func searchTasks(query: String)
    func toggleTaskCompletion(_ task: ToDoItem)
    func deleteTask(_ task: ToDoItem)
    func createTask(todo: String, completed: Bool)
}

class ToDoListInteractor: ToDoListInteractorProtocol {
    
    weak var presenter: ToDoListPresenter!
    private let operationQueue = OperationQueue()
    
    func loadTasks() {
        let operation = BlockOperation { [weak self] in
            CoreDataManager.shared.fetchTasks { tasks in
                if tasks.isEmpty {
                    self?.loadTasksFromNetwork()
                } else {
                    DispatchQueue.main.async {
                        self?.presenter.didLoadTasks(tasks)
                    }
                }
            }
        }
        operationQueue.addOperation(operation)
    }
    
    func refreshTasks() {
        // Принудительно загружаем свежие данные из CoreData
        let operation = BlockOperation { [weak self] in
            CoreDataManager.shared.fetchTasks { tasks in
                DispatchQueue.main.async {
                    print("🔄 Refreshed \(tasks.count) tasks from CoreData")
                    self?.presenter.didLoadTasks(tasks)
                }
            }
        }
        operationQueue.addOperation(operation)
    }
    
    private func loadTasksFromNetwork() {
        let operation = BlockOperation { [weak self] in
            NetworkManager.shared.fetchTasks { [weak self] result in
                switch result {
                case .success(let tasks):
                    self?.saveTasksToCoreData(tasks)
                    CoreDataManager.shared.fetchTasks { tasksFromCoreData in
                        DispatchQueue.main.async {
                            self?.presenter.didLoadTasks(tasksFromCoreData)
                        }
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
                print("✅ Successfully saved \(tasks.count) tasks to CoreData")
            } catch {
                print("❌ Error saving tasks to CoreData: \(error)")
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
            
            // Немедленно обновляем UI, а затем синхронизируем с CoreData
            DispatchQueue.main.async {
                // Сначала обновляем локальное состояние
                if let index = self.presenter.tasks.firstIndex(where: { $0.id == task.id }) {
                    var updatedTasks = self.presenter.tasks
                    updatedTasks[index] = updatedTask
                    self.presenter.didLoadTasks(updatedTasks)
                }
                
                // Затем обновляем из CoreData для гарантии consistency
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.refreshTasks()
                }
            }
        }
        operationQueue.addOperation(operation)
    }
    
    func deleteTask(_ task: ToDoItem) {
        let operation = BlockOperation {
            CoreDataManager.shared.deleteTask(task)
            
            // После удаления обновляем список
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.refreshTasks()
            }
        }
        operationQueue.addOperation(operation)
    }
    
    func createTask(todo: String, completed: Bool) {
        let operation = BlockOperation {
            let id = Int.random(in: 1000...9999)
            let userId = 1
            
            CoreDataManager.shared.createTask(
                id: id,
                todo: todo,
                completed: completed,
                userId: userId
            )
            
            // После создания обновляем список
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.refreshTasks()
            }
        }
        operationQueue.addOperation(operation)
    }
}
