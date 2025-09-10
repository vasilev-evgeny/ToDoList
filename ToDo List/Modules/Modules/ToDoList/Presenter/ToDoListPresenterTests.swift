//
//  ToDoListPresenterTests.swift
//  ToDo List
//
//  Created by Евгений Васильев on 10.09.2025.
//
//import XCTest
//@testable import ToDo_List
//
//class ToDoListPresenterTests: XCTestCase {
//    var presenter: ToDoListPresenter!
//    var mockView: MockToDoListView!
//    var mockInteractor: MockToDoListInteractor!
//    var mockRouter: MockToDoListRouter!
//    
//    override func setUp() {
//        super.setUp()
//        mockView = MockToDoListView()
//        mockInteractor = MockToDoListInteractor()
//        mockRouter = MockToDoListRouter()
//        
//        presenter = ToDoListPresenter()
//        presenter.view = mockView
//        presenter.interactor = mockInteractor
//        presenter.router = mockRouter
//    }
//    
//    func testViewDidLoadCallsLoadTasks() {
//        presenter.viewDidLoad()
//        XCTAssertTrue(mockInteractor.loadTasksCalled)
//    }
//    
//    func testDidLoadTasksUpdatesView() {
//        let testTasks = [ToDoItem(id: 1, todo: "Test", completed: false, userId: 1)]
//        presenter.didLoadTasks(testTasks)
//        
//        XCTAssertTrue(mockView.showTasksCalled)
//        XCTAssertEqual(mockView.shownTasks?.count, 1)
//    }
//}
//
//class MockToDoListView: ToDoListViewProtocol {
//    var showTasksCalled = false
//    var shownTasks: [ToDoItem]?
//    
//    func showTasks(_ tasks: [ToDoItem]) {
//        showTasksCalled = true
//        shownTasks = tasks
//    }
//    
//    func showError(_ error: String) {}
//    func showLoading() {}
//    func hideLoading() {}
//    func updateTasksCount(_ count: Int) {}
//}
//
//class MockToDoListInteractor: ToDoListInteractorProtocol {
//    var loadTasksCalled = false
//    
//    func loadTasks() {
//        loadTasksCalled = true
//    }
//    
//    func searchTasks(query: String) {}
//    func toggleTaskCompletion(_ task: ToDoItem) {}
//    func deleteTask(_ task: ToDoItem) {}
//    func createTask(todo: String, completed: Bool) {}
//}
//
//class MockToDoListRouter: ToDoListRouterProtocol {
//    func navigateToTaskDetails(task: ToDoItem) {}
//    func navigateToCreateTask() {}
//}
