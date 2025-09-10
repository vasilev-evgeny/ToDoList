//
//  AppDelegate.swift
//  ToDo List
//
//  Created by Евгений Васильев on 04.09.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // В application(_:didFinishLaunchingWithOptions:) или в ToDoListViewController viewDidLoad
        func checkAndLoadInitialData() {
            CoreDataManager.shared.fetchTasks { tasks in
                if tasks.isEmpty {
                    print("📦 CoreData is empty, loading from network...")
                    // Загружаем из сети если CoreData пусто
                    NetworkManager.shared.fetchTasks { result in
                        switch result {
                        case .success(let networkTasks):
                            // Сохраняем в CoreData
                            let backgroundContext = CoreDataManager.shared.persistentContainer.newBackgroundContext()
                            backgroundContext.perform {
                                for task in networkTasks {
                                    let taskEntity = TaskEntity(context: backgroundContext)
                                    taskEntity.id = Int64(task.id)
                                    taskEntity.todo = task.todo
                                    taskEntity.completed = task.completed
                                    taskEntity.userId = Int64(task.userId)
                                }
                                try? backgroundContext.save()
                                print("✅ Initial data loaded from network and saved to CoreData")
                            }
                        case .failure(let error):
                            print("❌ Failed to load initial data: \(error)")
                        }
                    }
                } else {
                    print("✅ CoreData already has \(tasks.count) tasks")
                }
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

