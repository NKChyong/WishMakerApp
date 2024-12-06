//
//  WishCalendarViewController.swift
//  kunguenPW2
//
//  Created by Нгуен Куиет Чыонг on 06.12.2024.
//

import UIKit
import CoreData

// MARK: - WishCalendarViewController
final class WishCalendarViewController: UIViewController {
    // MARK: - Constants
    private enum Constants {
        static let contentInset: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        static let collectionTop: CGFloat = 10
    }

    // MARK: - Properties
    private let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    private var events: [WishEvent] = []
    var backgroundColor: UIColor?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor ?? .white
        setupNavigationBar()
        configureCollectionView()
        fetchEvents()
    }

    // MARK: - Navigation Bar Configuration
    private func setupNavigationBar() {
        title = "Wish Calendar"
        let addEventButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addEventButtonTapped)
        )
        navigationItem.rightBarButtonItem = addEventButton
    }

    // MARK: - Actions
    @objc private func addEventButtonTapped() {
        let creationVC = WishEventCreationView()
        creationVC.modalPresentationStyle = .fullScreen
        creationVC.onEventCreated = { [weak self] in
            self?.fetchEvents() // Refresh the list of events
        }
        present(creationVC, animated: true)
    }

    // MARK: - Collection View Configuration
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = backgroundColor ?? .white
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = Constants.contentInset

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 10
        }

        collectionView.register(WishEventCell.self, forCellWithReuseIdentifier: WishEventCell.reuseIdentifier)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.collectionTop),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Fetch Events
    private func fetchEvents() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<WishEvent> = WishEvent.fetchRequest()

        do {
            events = try context.fetch(fetchRequest)
            collectionView.reloadData()
        } catch {
            print("Failed to fetch events: \(error)")
        }
    }
}

// MARK: - UICollectionViewDataSource
extension WishCalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WishEventCell.reuseIdentifier, for: indexPath)
        guard let wishCell = cell as? WishEventCell else { return cell }
        let event = events[indexPath.item]
        wishCell.configure(with: event)
        return wishCell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WishCalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 20, height: 120)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = events[indexPath.item]
        print("Selected event: \(event.title ?? "Unknown")")
    }
}
