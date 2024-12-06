//
//  WishEventCreationView.swift
//  kunguenPW2
//
//  Created by Нгуен Куиет Чыонг on 05.12.2024.
//

import UIKit
import CoreData

// MARK: - WishEventCreationView
final class WishEventCreationView: UIViewController {
    // MARK: - Properties
    var onEventCreated: (() -> Void)?
    private let titleField = UITextField()
    private let descriptionField = UITextField()
    private let startDateField = UITextField()
    private let endDateField = UITextField()
    private let saveButton = UIButton(type: .system)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [titleField, descriptionField, startDateField, endDateField, saveButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        titleField.placeholder = "Event Title"
        descriptionField.placeholder = "Event Description"
        startDateField.placeholder = "Start Date (dd.MM.yyyy)"
        endDateField.placeholder = "End Date (dd.MM.yyyy)"
        saveButton.setTitle("Save Event", for: .normal)
        saveButton.addTarget(self, action: #selector(saveEvent), for: .touchUpInside)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    // MARK: - Actions
    @objc private func saveEvent() {
        guard let title = titleField.text, !title.isEmpty,
              let description = descriptionField.text, !description.isEmpty,
              let startDateText = startDateField.text, !startDateText.isEmpty,
              let endDateText = endDateField.text, !endDateText.isEmpty else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        guard let startDate = dateFormatter.date(from: startDateText),
              let endDate = dateFormatter.date(from: endDateText) else { return }

        let context = CoreDataManager.shared.context
        let newEvent = NSEntityDescription.insertNewObject(forEntityName: "WishEvent", into: context) as! WishEvent
        newEvent.title = title
        newEvent.descriptionText = description
        newEvent.startDate = startDate
        newEvent.endDate = endDate

        CoreDataManager.shared.saveContext()

        let calendarEventModel = CalendarEventModel(title: title, startDate: startDate, endDate: endDate, note: description)
        let calendarManager = CalendarManager()
        let isEventCreated = calendarManager.create(eventModel: calendarEventModel)

        if isEventCreated {
            print("Event was successfully added to the calendar.")
        } else {
            print("Failed to add event to the calendar.")
        }

        onEventCreated?()
        dismiss(animated: true)
    }
}
