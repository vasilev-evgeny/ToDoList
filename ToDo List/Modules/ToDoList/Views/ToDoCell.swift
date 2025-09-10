//
//  ToDoCell.swift
//  ToDo List
//
//  Created by Евгений Васильев on 04.09.2025.
//
import UIKit
class ToDoCell : UITableViewCell {
    
    var onCheckboxTapped: ((Bool) -> Void)?
    
    // Добавляем свойства для хранения оригинального текста
    private var originalTitleText: String = ""
    private var originalDetailText: String = ""
    
    //MARK: - Create UI
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    let detailLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
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
    
    private func setupActions() {
        checkBoxButton.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
    }
    
    @objc private func checkboxTapped() {
        let newState = !checkBoxButton.isSelected
        checkBoxButton.isSelected = newState
        checkBoxButton.setImage(
            newState ? UIImage(named: "taskCheckBoxFillImage") : UIImage(named: "taskCheckBoxEmptyImage"),
            for: .normal
        )
        onCheckboxTapped?(newState)
        updateTextAppearance(for: newState)
    }
    
    private func updateTextAppearance(for isCompleted: Bool) {
        if isCompleted {
            // Зачеркиваем текст
            let titleAttributedString = NSMutableAttributedString(string: originalTitleText)
            let detailAttributedString = NSMutableAttributedString(string: originalDetailText)
            
            titleAttributedString.addAttribute(.strikethroughStyle,
                                             value: 1,
                                             range: NSRange(location: 0, length: titleAttributedString.length))
            detailAttributedString.addAttribute(.strikethroughStyle,
                                              value: 1,
                                              range: NSRange(location: 0, length: detailAttributedString.length))
            
            titleLabel.attributedText = titleAttributedString
            detailLabel.attributedText = detailAttributedString
            titleLabel.textColor = .gray
            detailLabel.textColor = .gray
        } else {
            // Возвращаем обычный текст - убираем зачеркивание
            titleLabel.attributedText = nil
            detailLabel.attributedText = nil
            titleLabel.text = originalTitleText
            detailLabel.text = originalDetailText
            titleLabel.textColor = .white
            detailLabel.textColor = .white
        }
    }
    
    func configure(with task: ToDoItem) {
        // Сохраняем оригинальный текст
        originalTitleText = "Задача #\(task.id)"
        originalDetailText = task.todo
        
        // Устанавливаем текст
        titleLabel.text = originalTitleText
        detailLabel.text = originalDetailText
        dateLabel.text = "02/10/24"
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // Устанавливаем состояние кнопки
        checkBoxButton.isSelected = task.completed
        checkBoxButton.setImage(
            task.completed ? UIImage(named: "taskCheckBoxFillImage") : UIImage(named: "taskCheckBoxEmptyImage"),
            for: .normal
        )
        
        // Обновляем внешний вид текста
        updateTextAppearance(for: task.completed)
    }
    
    //MARK: - Setup
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setConstraints()
        setupActions()
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
