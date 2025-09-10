//
//  Entity.swift
//  ToDo List
//
//  Created by Евгений Васильев on 04.09.2025.
//
import Foundation

struct ToDoItem: Codable {
    var id: Int
    var todo: String
    var completed: Bool
    var userId: Int

}

