//
//  CoreDataManager.swift
//  ToDo List
//
//  Created by Евгений Васильев on 10.09.2025.
//
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    // MARK: - Task Operations
    
    func createTask(id: Int, todo: String, completed: Bool, userId: Int) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let taskEntity = TaskEntity(context: backgroundContext)
            taskEntity.id = Int64(id)
            taskEntity.todo = todo
            taskEntity.completed = completed
            taskEntity.userId = Int64(userId)
            do {
                try backgroundContext.save()
            } catch {
                print("Error saving task: \(error)")
            }
        }
    }
    
    func fetchTasks(completion: @escaping ([ToDoItem]) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            do {
                let entities = try backgroundContext.fetch(request)
                let tasks = entities.map { entity in
                    ToDoItem(
                        id: Int(entity.id),
                        todo: entity.todo ?? "",
                        completed: entity.completed,
                        userId: Int(entity.userId)
                    )
                }
                DispatchQueue.main.async {
                    completion(tasks)
                }
            } catch {
                print("Error fetching tasks: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    func updateTask(_ task: ToDoItem) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", task.id)
            
            do {
                if let entity = try backgroundContext.fetch(request).first {
                    entity.todo = task.todo
                    entity.completed = task.completed
                    try backgroundContext.save()
                }
            } catch {
                print("Error updating task: \(error)")
            }
        }
    }
    
    func deleteTask(_ task: ToDoItem) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", task.id)
            
            do {
                if let entity = try backgroundContext.fetch(request).first {
                    backgroundContext.delete(entity)
                    try backgroundContext.save()
                }
            } catch {
                print("Error deleting task: \(error)")
            }
        }
    }
    
    func searchTasks(query: String, completion: @escaping ([ToDoItem]) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let request: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            request.predicate = NSPredicate(format: "todo CONTAINS[cd] %@", query)
            let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            do {
                let entities = try backgroundContext.fetch(request)
                let tasks = entities.map { entity in
                    ToDoItem(
                        id: Int(entity.id),
                        todo: entity.todo ?? "",
                        completed: entity.completed,
                        userId: Int(entity.userId)
                    )
                }
                DispatchQueue.main.async {
                    completion(tasks)
                }
            } catch {
                print("Error searching tasks: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
}
