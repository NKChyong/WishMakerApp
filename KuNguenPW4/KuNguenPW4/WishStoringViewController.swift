//
//  WishStoringViewController.swift
//  kunguenPW2
//
//  Created by Нгуен Куиет Чыонг on 05.11.2024.
//

import UIKit

final class WishStoringViewController: UIViewController {
    // MARK: - Constants
    enum Constants {
        static let tableCornerRadius: CGFloat = 20
        static let tableOffset: CGFloat = 20
        static let numberOfSections = 2
        static let numberOfRowsInSection0: Int = 1
        static let addWishButtonOffset: CGFloat = 20
        static let buttonHeight: CGFloat = 50
        static let buttonBottom: CGFloat = 40
        static let buttonSide: CGFloat = 20
        static let buttonText = "Add Wish"
        static let buttonRadius: CGFloat = 20
        static let wishesKey = "wishesKey"
    }

    // MARK: - Properties
    private let addWishButton = UIButton(type: .system)
    private let table = UITableView(frame: .zero)
    private var wishArray: [String] = []
    private var currentWishText = ""
    private let defaults = UserDefaults.standard
    var backgroundColor: UIColor?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor ?? .blue
        loadWishes()
        configureAddWishButton()
        configureTable()
    }

    // MARK: - UI Configuration
    private func configureTable() {
        view.addSubview(table)
        table.backgroundColor = .gray
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .none
        table.layer.cornerRadius = Constants.tableCornerRadius
        table.pinCenterX(to: view)
        table.pinLeft(to: view, Constants.tableOffset)
        table.pinRight(to: view, Constants.tableOffset)
        table.pinTop(to: view, Constants.tableOffset)
        table.pinBottom(to: addWishButton.topAnchor, Constants.tableOffset)
        table.register(WrittenWishCell.self, forCellReuseIdentifier: WrittenWishCell.reuseId)
        table.register(AddWishCell.self, forCellReuseIdentifier: AddWishCell.reuseId)
    }

    private func configureAddWishButton() {
        view.addSubview(addWishButton)
        addWishButton.setHeight(Constants.buttonHeight)
        addWishButton.pinBottom(to: view, Constants.buttonBottom)
        addWishButton.pinHorizontal(to: view, Constants.buttonSide)
        addWishButton.backgroundColor = .white
        addWishButton.setTitleColor(backgroundColor, for: .normal)
        addWishButton.setTitle(Constants.buttonText, for: .normal)
        addWishButton.layer.cornerRadius = Constants.buttonRadius
        addWishButton.addTarget(self, action: #selector(addWishButtonPressed), for: .touchUpInside)
    }

    // MARK: - Actions
    @objc private func addWishButtonPressed() {
        guard !currentWishText.isEmpty else { return }
        wishArray.append(currentWishText)
        currentWishText = ""
        saveWishes()
        if let addWishCell = table.cellForRow(at: IndexPath(row: 0, section: 1)) as? AddWishCell {
            addWishCell.resetText()
        }
        table.reloadData()
    }

    // MARK: - Data Persistence
    private func saveWishes() {
        defaults.set(wishArray, forKey: Constants.wishesKey)
    }

    private func loadWishes() {
        if let savedWishes = defaults.array(forKey: Constants.wishesKey) as? [String] {
            wishArray = savedWishes
        }
    }
}

// MARK: - UITableViewDataSource
extension WishStoringViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? 1 : wishArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddWishCell.reuseId, for: indexPath)
            if let addWishCell = cell as? AddWishCell {
                addWishCell.addWish = { [weak self] text in
                    self?.currentWishText = text
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: WrittenWishCell.reuseId, for: indexPath)
            if let wishCell = cell as? WrittenWishCell {
                wishCell.configure(with: wishArray[indexPath.row])
            }
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension WishStoringViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.section == 0 else { return nil }
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            self?.wishArray.remove(at: indexPath.row)
            self?.saveWishes()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            let wishToEdit = self.wishArray[indexPath.row]
            self.showEditAlert(for: wishToEdit, at: indexPath.row)
            completionHandler(true)
        }
        editAction.backgroundColor = .blue
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }

    private func showEditAlert(for wish: String, at index: Int) {
        let alertController = UIAlertController(title: "Edit Wish", message: "Modify your wish", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = wish
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alertController] _ in
            guard let newText = alertController?.textFields?.first?.text, !newText.isEmpty else { return }
            self?.wishArray[index] = newText
            self?.saveWishes()
            self?.table.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}
