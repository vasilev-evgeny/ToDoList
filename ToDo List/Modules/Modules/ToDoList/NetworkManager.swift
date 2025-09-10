//
//  NetworkManager.swift
//  ToDo List
//
//  Created by Евгений Васильев on 08.09.2025.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchTasks(completion: @escaping (Result<[ToDoItem], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(TodosResponse.self, from: data)
                completion(.success(response.todos))
            } catch {
                print("Ошибка парсинга: \(error)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

struct TodosResponse: Codable {
    let todos: [ToDoItem]
    let total: Int
    let skip: Int
    let limit: Int
}

enum NetworkError: Error {
    case invalidURL
    case noData
}
