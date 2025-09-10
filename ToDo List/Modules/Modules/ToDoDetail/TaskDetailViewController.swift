//
//  ToDoDetailView.swift
//  ToDo List
//
//  Created by Евгений Васильев on 04.09.2025.
//
import UIKit

class TaskDetailViewController: UIViewController {
    
    var presenter: TaskDetailPresenterProtocol!

    //MARK: - Create UI
    
    let taskTitleTextView: UITextView = {
        let view = UITextView()
        view.textAlignment = .left
        view.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        view.backgroundColor = .clear
        view.textColor = .white
        view.isEditable = true
        return view
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.isHidden = true // Скрываем дату, так как её нет в данных
        return label
    }()
    
    let taskBodyTextView: UITextView = {
        let view = UITextView()
        view.textAlignment = .left
        view.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        view.textColor = .white
        view.backgroundColor = .clear
        view.isEditable = true
        return view
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Создать", for: .normal)
        button.backgroundColor = UIColor(hex: "#FED702")
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.isHidden = true
        return button
    }()
    
    private func setupNavigationBar() {
        if presenter.isCreatingNewTask() {
            // Для создания новой задачи
            let cancelButton = UIButton(type: .system)
            cancelButton.setTitle("Отмена", for: .normal)
            cancelButton.tintColor = UIColor(hex: "#FED702")
            cancelButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            let cancelBarButtonItem = UIBarButtonItem(customView: cancelButton)
            navigationItem.leftBarButtonItem = cancelBarButtonItem
            
            let createButton = UIButton(type: .system)
            createButton.setTitle("Создать", for: .normal)
            createButton.tintColor = UIColor(hex: "#FED702")
            createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
            let createBarButtonItem = UIBarButtonItem(customView: createButton)
            navigationItem.rightBarButtonItem = createBarButtonItem
            
            navigationItem.title = "Новая задача"
        } else {
            // Для редактирования существующей задачи
            let backButton = UIButton(type: .system)
            backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
            backButton.setTitle(" Назад", for: .normal)
            backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            backButton.tintColor = UIColor(hex: "#FED702")
            backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            let backBarButtonItem = UIBarButtonItem(customView: backButton)
            navigationItem.leftBarButtonItem = backBarButtonItem
            
            navigationItem.title = "Редактирование"
        }
    }
    
    //MARK: - Action Func
    
    @objc private func backButtonTapped() {
        presenter.didRequestToClose()
    }
    
    @objc private func createButtonTapped() {
        let taskDescription = taskBodyTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        presenter.createNewTask(title: "Новая задача", description: taskDescription)
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setupNavigationBar()
        presenter.viewDidLoad()
        setupTextViewDelegates()
    }
    
    private func setupViews() {
        view.backgroundColor = .black
        view.addSubview(taskTitleTextView)
        view.addSubview(dateLabel)
        view.addSubview(taskBodyTextView)
        view.addSubview(saveButton)
    }
    
    private func setupTextViewDelegates() {
        taskTitleTextView.delegate = self
        taskBodyTextView.delegate = self
    }
    
    //MARK: - setConstraints
    
    private func setConstraints() {
        taskTitleTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskTitleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            taskTitleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskTitleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            taskTitleTextView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: taskTitleTextView.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        taskBodyTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskBodyTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            taskBodyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskBodyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            taskBodyTextView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: taskBodyTextView.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: - UITextViewDelegate

extension TaskDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == taskTitleTextView {
            presenter.updateTaskTitle(textView.text)
        } else if textView == taskBodyTextView {
            presenter.updateTaskDescription(textView.text)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == taskTitleTextView {
            presenter.updateTaskTitle(textView.text)
        } else if textView == taskBodyTextView {
            presenter.updateTaskDescription(textView.text)
        }
    }
}

// MARK: - View Protocol Implementation
extension TaskDetailViewController: TaskDetailViewProtocol {
    func displayTask(_ task: ToDoItem) {
        taskBodyTextView.text = task.todo
        taskTitleTextView.text = "Задача#\(task.id)"
    }
    
    func setupForCreateMode() {
        taskTitleTextView.text = "Новая задача"
        taskBodyTextView.text = ""
        taskBodyTextView.becomeFirstResponder() // Фокус на поле ввода
    }
}
