//
//  ToDoInteractor.swift
//  ToDo List
//
//  Created by Евгений Васильев on 08.09.2025.
//
import Foundation

protocol ToDoListInteractorProtocol: AnyObject {
    func loadTasks()
    func searchTasks(query: String)
}

class ToDoListInteractor: ToDoListInteractorProtocol {
    
    weak var presenter: ToDoListPresenter!
    
    func loadTasks() {
        NetworkManager.shared.fetchTasks { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tasks):
                    self?.presenter.didLoadTasks(tasks)
                case .failure(let error):
                    self?.presenter.didFailWithError(error.localizedDescription)
                }
            }
        }
    }
    
    func searchTasks(query: String) {
        NetworkManager.shared.fetchTasks { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tasks):
                    let filtered = tasks.filter { $0.todo.localizedCaseInsensitiveContains(query) }
                    self?.presenter.didLoadTasks(filtered)
                case .failure(let error):
                    self?.presenter.didFailWithError(error.localizedDescription)
                }
            }
        }
    }
}
