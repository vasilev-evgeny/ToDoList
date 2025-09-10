//  ToDoViewController.swift
//  ToDo List
//
//  Created by Евгений Васильев on 04.09.2025.
//
import UIKit

protocol ToDoListViewProtocol: AnyObject {
    func showTasks(_ tasks: [ToDoItem])
    func showError(_ error: String)
    func showLoading()
    func hideLoading()
    func updateTasksCount(_ count: Int)
}

class ToDoListViewController: UIViewController {
    
    var presenter: ToDoListPresenterProtocol!

    private var tasks: [ToDoItem] = []
    
    //MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.text = "Задачи"
        label.textColor = .white
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search"
        bar.backgroundImage = UIImage()
        bar.backgroundColor = UIColor(hex: "#272729")
        if let textField = bar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor(hex: "#272729")
            textField.textColor = .white
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 141/255, green: 141/255, blue: 142/255, alpha: 1)]
            )
        }
        let glassImage = UIImage(systemName: "magnifyingglass")?
            .withTintColor(UIColor(red: 141/255, green: 141/255, blue: 142/255, alpha: 1), renderingMode: .alwaysOriginal)
        let micImage = UIImage(systemName: "mic.fill")?
            .withTintColor(UIColor(red: 141/255, green: 141/255, blue: 142/255, alpha: 1), renderingMode: .alwaysOriginal)
        bar.setImage(glassImage, for: .search, state: .normal)
        bar.setImage(micImage, for: .bookmark, state: .normal)
        bar.showsBookmarkButton = true
        bar.layer.cornerRadius = 10
        bar.layer.masksToBounds = true
        bar.tintColor = UIColor(red: 141/255, green: 141/255, blue: 142/255, alpha: 1)
        return bar
    }()
    
    private let tasksTableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.separatorStyle = .singleLine
        view.backgroundColor = .clear
        view.separatorColor = .darkGray
        return view
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#272729")
        return view
    }()
    
    private let tasksCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.text = "0 Задач"
        label.textColor = .white
        return label
    }()
    
    private let addTaskButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addtaskImage"), for: .normal)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setupTableView()
        setupActions()
        presenter.viewDidLoad()
    }
    
    //MARK: - Setup Methods
    
    private func setupViews() {
        view.backgroundColor = .black
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(bottomView)
        bottomView.addSubview(tasksCountLabel)
        bottomView.addSubview(addTaskButton)
        view.addSubview(tasksTableView)
    }
    
    private func setupTableView() {
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        tasksTableView.register(ToDoCell.self, forCellReuseIdentifier: "ToDoCell")
        tasksTableView.tableFooterView = UIView()
    }
    
    private func setupActions() {
        addTaskButton.addTarget(self, action: #selector(addTaskTapped), for: .touchUpInside)
        searchBar.delegate = self
    }
    
    @objc private func addTaskTapped() {
    }
    
    private func toggleTaskCompletion(at indexPath: IndexPath) {
            var task = tasks[indexPath.row]
            task.completed.toggle()
            tasks[indexPath.row] = task
            tasksTableView.reloadRows(at: [indexPath], with: .automatic)
            
            // Здесь можно вызвать метод презентера для обновления на сервере/бд
            // presenter.toggleTaskCompletion(task)
        }
    
    private func showDeleteConfirmation(for task: ToDoItem, at indexPath: IndexPath) {
            let alert = UIAlertController(
                title: "Удалить задачу?",
                message: "Задача \"\(task.todo)\" будет удалена",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
            alert.addAction(UIAlertAction(title: "Удалить", style: .destructive) { _ in
                self.tasks.remove(at: indexPath.row)
                self.tasksTableView.deleteRows(at: [indexPath], with: .automatic)
                self.updateTasksCount(self.tasks.count)
                
                // Здесь можно вызвать метод презентера для удаления из сервера/бд
                // presenter.deleteTask(task)
            })
            
            present(alert, animated: true)
        }
    
    
    //MARK: - Constraints
    
    private func setConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        tasksTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tasksTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            tasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tasksTableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
        ])
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 83)
        ])
        
        tasksCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tasksCountLabel.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 20),
            tasksCountLabel.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor)
        ])
        
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addTaskButton.centerYAnchor.constraint(equalTo: tasksCountLabel.centerYAnchor),
            addTaskButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -24),
            addTaskButton.heightAnchor.constraint(equalToConstant: 28),
            addTaskButton.widthAnchor.constraint(equalToConstant: 28)
        ])
    }
}

//MARK: - UITableView Delegate & DataSource
extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
        let task = tasks[indexPath.row]
        cell.configure(with: task)
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let task = tasks[indexPath.row]
        presenter.didSelectTask(task)
    }
    
    func tableView(_ tableView: UITableView,
                      contextMenuConfigurationForRowAt indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        
        let task = tasks[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: {
            // Создаем preview контроллер
            let previewVC = UIViewController()
            previewVC.view.backgroundColor = .black
            
            let label = UILabel()
            label.text = task.todo
            label.textColor = .white
            label.textAlignment = .center
            label.numberOfLines = 0
            previewVC.view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: previewVC.view.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: previewVC.view.centerYAnchor),
                label.leadingAnchor.constraint(equalTo: previewVC.view.leadingAnchor, constant: 20),
                label.trailingAnchor.constraint(equalTo: previewVC.view.trailingAnchor, constant: -20)
            ])
            return previewVC
        }) { _ in
            // Создаем actions для меню
            let editAction = UIAction(
                title: "Редактировать",
                image: UIImage(named: "edit")
            ) { [weak self] _ in
                let task = self?.tasks[indexPath.row]
                self?.presenter.didSelectTask(task!)
            }
            let completeAction = UIAction(
                title: "Поделиться",
                image: UIImage(named: "export")
            ) { [weak self] _ in
                print("share")
            }
            let deleteAction = UIAction(
                title: "Удалить",
                image: UIImage(named: "trash"),
                attributes: .destructive
            ) { [weak self] _ in
                let task = self?.tasks[indexPath.row]
                self?.showDeleteConfirmation(for: task!, at: indexPath)
            }
            return UIMenu(children: [completeAction, editAction, deleteAction])
        }
    }
    
    func tableView(_ tableView: UITableView,
                      willDisplayContextMenu configuration: UIContextMenuConfiguration,
                      animator: UIContextMenuInteractionAnimating?) {
            
            if let indexPath = configuration.identifier as? IndexPath,
               let cell = tableView.cellForRow(at: indexPath) {
                UIView.animate(withDuration: 0.2) {
                    cell.backgroundColor = UIColor(hex: "#272729")
                    cell.layer.cornerRadius = 10
                }
            }
        }
    
    func tableView(_ tableView: UITableView,
                   previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        guard let indexPath = configuration.identifier as? IndexPath,
              let cell = tableView.cellForRow(at: indexPath) else {
            return nil
        }
        
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = UIBezierPath(rect: cell.bounds)
        let target = UIPreviewTarget(container: cell, center: CGPoint(x: cell.bounds.midX, y: cell.bounds.midY))
        return UITargetedPreview(view: cell, parameters: parameters, target: target)
    }
    
    func tableView(_ tableView: UITableView,
                      willEndContextMenuInteraction configuration: UIContextMenuConfiguration,
                      animator: UIContextMenuInteractionAnimating?) {
            if let indexPath = configuration.identifier as? IndexPath,
               let cell = tableView.cellForRow(at: indexPath) {
                UIView.animate(withDuration: 0.2) {
                    cell.backgroundColor = .clear
                }
            }
        }
}

//MARK: - UISearchBarDelegate
extension ToDoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

// MARK: - View Protocol
extension ToDoListViewController: ToDoListViewProtocol {
    func showTasks(_ tasks: [ToDoItem]) {
        self.tasks = tasks
        tasksTableView.reloadData()
        updateTasksCount(tasks.count)
    }
    
    func showError(_ error: String) {
        let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showLoading() {
        // Можно добавить индикатор
        print("Загрузка...")
    }
    
    func hideLoading() {
        print("Загрузка завершена")
    }
    
    func updateTasksCount(_ count: Int) {
        tasksCountLabel.text = "\(count) Задач"
    }
}
