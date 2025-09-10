//
//  ToDoCell.swift
//  ToDo List
//
//  Created by Евгений Васильев on 04.09.2025.
import UIKit

class ToDoCell: UITableViewCell {
    
    var onCheckboxTapped: ((Bool) -> Void)?
    
    //MARK: - Create UI
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    let checkBoxButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "taskCheckBoxEmptyImage"), for: .normal)
        button.setImage(UIImage(named: "taskCheckBoxFillImage"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    //MARK: - Func
    
    private func setupActions() {
        checkBoxButton.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
    }
    
    @objc private func checkboxTapped() {
        let newState = !checkBoxButton.isSelected
        checkBoxButton.isSelected = newState
        updateTextAppearance(for: newState)
        onCheckboxTapped?(newState)
    }
    
    private func updateTextAppearance(for isCompleted: Bool) {
        if isCompleted {
            // Зачеркнутый текст серого цвета для выполненной задачи
            let attributedString = NSAttributedString(
                string: titleLabel.text ?? "",
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.gray
                ]
            )
            titleLabel.attributedText = attributedString
            detailLabel.textColor = .gray
        } else {
            // Обычный текст белого цвета без зачеркивания
            titleLabel.attributedText = nil
            titleLabel.textColor = .white
            detailLabel.textColor = .white
        }
    }
    
    func configure(with task: ToDoItem) {
        // Сначала сбрасываем все атрибуты
        titleLabel.attributedText = nil
        
        // Устанавливаем обычный текст
        titleLabel.text = "Задача #\(task.id)"
        detailLabel.text = task.todo
        // Сбрасываем цвета
        titleLabel.textColor = .white
        detailLabel.textColor = .white
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // Устанавливаем состояние кнопки
        checkBoxButton.isSelected = task.completed
        
        // Обновляем внешний вид текста
        updateTextAppearance(for: task.completed)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Сбрасываем состояние при переиспользовании ячейки
        titleLabel.attributedText = nil
        detailLabel.attributedText = nil
        titleLabel.text = nil
        detailLabel.text = nil
        titleLabel.textColor = .white
        detailLabel.textColor = .white
        checkBoxButton.isSelected = false
        onCheckboxTapped = nil
    }
    
    //MARK: - Setup
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setConstraints()
        setupActions()
        selectionStyle = .none
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
            checkBoxButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkBoxButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkBoxButton.widthAnchor.constraint(equalToConstant: 24),
            checkBoxButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: checkBoxButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: checkBoxButton.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            detailLabel.leadingAnchor.constraint(equalTo: checkBoxButton.trailingAnchor, constant: 12),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 6),
            dateLabel.leadingAnchor.constraint(equalTo: checkBoxButton.trailingAnchor, constant: 12),
        ])
    }
}
