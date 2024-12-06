//
//  WishEventCell.swift
//  kunguenPW2
//
//  Created by Нгуен Куиет Чыонг on 04.12.2024.
//

import UIKit

// MARK: - WishEventCell
final class WishEventCell: UICollectionViewCell {
    // MARK: - Constants
    static let reuseIdentifier: String = "WishEventCell"
    
    private enum Constants {
        static let offset: CGFloat = 10
        static let cornerRadius: CGFloat = 20
        static let backgroundColor: UIColor = .white
        static let textColor: UIColor = .black
        static let titleTop: CGFloat = 10
        static let titleLeading: CGFloat = 10
        static let titleFont: CGFloat = 20
        static let descriptionFont: CGFloat = 16
        static let dateTrailing: CGFloat = 10
        static let dateFont: CGFloat = 16
    }
    
    // MARK: - Properties
    private let wrapView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let startDateLabel = UILabel()
    private let endDateLabel = UILabel()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureWrap()
        configureTitleLabel()
        configureDescriptionLabel()
        configureStartDateLabel()
        configureEndDateLabel()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Methods
    private func formatDate(_ date: Date?) -> String? {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    // MARK: - Configuration
    func configure(with event: WishEvent) {
        titleLabel.text = event.title
        descriptionLabel.text = event.descriptionText
        startDateLabel.text = formatDate(event.startDate)
        endDateLabel.text = formatDate(event.endDate)
    }

    // MARK: - UI Configuration
    private func configureWrap() {
        wrapView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(wrapView)
        wrapView.pinTop(to: self.topAnchor, Constants.offset)
        wrapView.pinBottom(to: self.bottomAnchor, Constants.offset)
        wrapView.pinLeft(to: self.leadingAnchor, Constants.offset)
        wrapView.pinRight(to: self.trailingAnchor, Constants.offset)
        wrapView.layer.cornerRadius = Constants.cornerRadius
        wrapView.backgroundColor = Constants.backgroundColor
    }
    
    private func configureTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        titleLabel.textColor = Constants.textColor
        titleLabel.pinTop(to: wrapView, Constants.titleTop)
        titleLabel.pinLeft(to: wrapView, Constants.titleLeading)
        titleLabel.font = titleLabel.font.withSize(Constants.titleFont)
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(descriptionLabel)
        descriptionLabel.textColor = Constants.textColor
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, Constants.offset)
        descriptionLabel.pinLeft(to: wrapView, Constants.titleLeading)
        descriptionLabel.font = descriptionLabel.font.withSize(Constants.descriptionFont)
    }
    
    private func configureStartDateLabel() {
        startDateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(startDateLabel)
        startDateLabel.textColor = Constants.textColor
        startDateLabel.pinTop(to: wrapView, Constants.offset)
        startDateLabel.pinRight(to: wrapView, Constants.dateTrailing)
        startDateLabel.font = startDateLabel.font.withSize(Constants.dateFont)
    }
    
    private func configureEndDateLabel() {
        endDateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(endDateLabel)
        endDateLabel.textColor = Constants.textColor
        endDateLabel.pinBottom(to: wrapView.bottomAnchor, Constants.offset)
        endDateLabel.pinRight(to: wrapView, Constants.dateTrailing)
        endDateLabel.font = endDateLabel.font.withSize(Constants.dateFont)
    }
}
