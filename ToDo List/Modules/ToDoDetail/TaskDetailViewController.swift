//
//  ToDoDetailView.swift
//  ToDo List
//
//  Created by Евгений Васильев on 04.09.2025.
//
import UIKit


class TaskDetailViewController : UIViewController {
    enum Constants {
        
    }
    
    var presenter: TaskDetailPresenterProtocol!

    //MARK: - Create UI
    
    let taskTitleTextView : UITextView = {
        let view = UITextView()
        view.textAlignment = .left
        view.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        view.backgroundColor = .clear
        view.textColor = .white
        view.isEditable = true
        return view
    }()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "02/10/24"
        label.textColor = .gray
        return label
    }()
    
    let taskBodyTextView : UITextView = {
        let view = UITextView()
        view.textAlignment = .left
        view.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        view.textColor = .white
        view.backgroundColor = .clear
        view.isEditable = true
        return view
    }()
    
    private func setupNavigationBar() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.setTitle(" Назад", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        backButton.tintColor = UIColor(hex: "#FED702")
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    //MARK: - Action Func
    
    @objc private func backButtonTapped() {
        presenter.didRequestToClose()
       }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setupNavigationBar()
        presenter.viewDidLoad()
    }
    
    private func setupViews() {
        view.backgroundColor = .black
        view.addSubview(taskTitleTextView)
        view.addSubview(dateLabel)
        view.addSubview(taskBodyTextView)
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
    }
}

// MARK: - UITextViewDelegate

extension TaskDetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        presenter.updateTaskTitle(textView.text)
    }
}

// MARK: - View Protocol Implementation
extension TaskDetailViewController: TaskDetailViewProtocol {
    func displayTask(_ task: ToDoItem) {
        dateLabel.text = "02/10/24"
        taskBodyTextView.text = task.todo
        taskTitleTextView.text = "Задача#\(task.id)"
    }
}
