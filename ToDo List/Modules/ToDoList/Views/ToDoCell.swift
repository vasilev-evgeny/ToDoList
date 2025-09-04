//
//  ToDoCell.swift
//  ToDo List
//
//  Created by Евгений Васильев on 04.09.2025.
//
import UIKit

class ToDoCell : UITableViewCell {
    
    //MARK: - Create UI
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.text = "Уборка в квартире"
        label.textColor = .white
        return label
    }()
    
    let detailLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "Провести генеральную уборку в квартире"
        label.textColor = .white
        return label
    }()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "02/10/24"
        label.textColor = .gray
        return label
    }()
    
    let checkBoxButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "taskCheckBoxEmptyImage"), for: .normal)
        button.imageView!.contentMode = .scaleAspectFill
        return button
    }()
    
    //MARK: - Func
    
    
    //MARK: - Setup
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(checkBoxButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(dateLabel)
    }
    
    private func setConstraints() {
        checkBoxButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkBoxButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            checkBoxButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkBoxButton.heightAnchor.constraint(equalToConstant: 24),
            checkBoxButton.widthAnchor.constraint(equalToConstant: 24)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: checkBoxButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: checkBoxButton.trailingAnchor, constant: 8)
        ])
        
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            detailLabel.leadingAnchor.constraint(equalTo: checkBoxButton.trailingAnchor, constant: 8)
        ])
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 6),
            dateLabel.leadingAnchor.constraint(equalTo: checkBoxButton.trailingAnchor, constant: 8)
        ])
    }
    
}


