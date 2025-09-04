//
//  ToDoViewController.swift
//  ToDo List
//
//  Created by Евгений Васильев on 04.09.2025.
//
import UIKit

class ToDoListView : UIViewController {
    
    
    enum Constants {
        
    }
    
    //MARK: - Create UI
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.text = "Задачи"
        label.textColor = .white
        return label
    }()
    
    let searchBar : UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search"
        bar.backgroundColor = UIColor(hex: "#272729", alpha: 1.0)
        bar.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
        bar.layer.cornerRadius = 10
        bar.layer.masksToBounds = true
        return bar
    }()
    
    let tasksTableView : UITableView = {
        let view = UITableView(frame: .zero)
        view.separatorStyle = .singleLine
        view.backgroundColor = .clear
        view.separatorColor = .darkGray 
        return view
    }()
    
    let bottomView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#272729")
        return view
    }()
    
    let tasksCountLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.text = "7 Задач"
        label.textColor = .white
        return label
    }()
    
    let addTaskButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "addtaskImage"), for: .normal)
        return button
    }()
    
    //MARK: - Properties
    
    func setDelegates() {
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        tasksTableView.register(ToDoCell.self, forCellReuseIdentifier: "ToDoCell")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        setDelegates()
    }
    
    private func setupViews() {
        view.backgroundColor = .black
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(bottomView)
        bottomView.addSubview(tasksCountLabel)
        bottomView.addSubview(addTaskButton)
        view.addSubview(tasksTableView)
    }
    
    //MARK: - setConstraints
    
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
            tasksTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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

//MARK: - Extensions

extension ToDoListView :  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
        return cell
    }
}
