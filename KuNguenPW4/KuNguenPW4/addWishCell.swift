//
//  AddWishCell.swift
//  kunguenPW2
//
//  Created by Нгуен Куиет Чыонг on 05.11.2024.
//

import UIKit

final class AddWishCell: UITableViewCell {
    
    // MARK: - Constants
    private enum Constants {
        static let wrapColor: UIColor = .white
        static let wrapRadius: CGFloat = 16
        static let wrapOffsetV: CGFloat = 5
        static let wrapOffsetH: CGFloat = 10
        static let addWishLabelOffset: CGFloat = 8
        static let placeholderText = "Enter your wish here..."
        static let placeholderColor = UIColor.lightGray
        static let textColor = UIColor.black
    }
    
    // MARK: - Properties
    static let reuseId: String = "addWishCell"
    private let addWishLabel = UITextView()
    var addWish: ((String) -> Void)?
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        setupPlaceholder()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        let wrap = UIView()
        wrap.backgroundColor = Constants.wrapColor
        wrap.layer.cornerRadius = Constants.wrapRadius
        wrap.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(wrap)
        
        NSLayoutConstraint.activate([
            wrap.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.wrapOffsetV),
            wrap.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.wrapOffsetV),
            wrap.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.wrapOffsetH),
            wrap.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.wrapOffsetH)
        ])
        
        wrap.addSubview(addWishLabel)
        addWishLabel.translatesAutoresizingMaskIntoConstraints = false
        addWishLabel.backgroundColor = .clear
        addWishLabel.font = UIFont.systemFont(ofSize: 16)
        addWishLabel.isScrollEnabled = false
        addWishLabel.delegate = self
        addWishLabel.textColor = Constants.textColor
        addWishLabel.isUserInteractionEnabled = true
        
        NSLayoutConstraint.activate([
            addWishLabel.topAnchor.constraint(equalTo: wrap.topAnchor, constant: Constants.addWishLabelOffset),
            addWishLabel.bottomAnchor.constraint(equalTo: wrap.bottomAnchor, constant: -Constants.addWishLabelOffset),
            addWishLabel.leadingAnchor.constraint(equalTo: wrap.leadingAnchor, constant: Constants.addWishLabelOffset),
            addWishLabel.trailingAnchor.constraint(equalTo: wrap.trailingAnchor, constant: -Constants.addWishLabelOffset)
        ])
    }
    
    // MARK: - Placeholder Management
    private func setupPlaceholder() {
        addWishLabel.text = Constants.placeholderText
        addWishLabel.textColor = Constants.placeholderColor
    }
    
    private func removePlaceholder() {
        if addWishLabel.text == Constants.placeholderText {
            addWishLabel.text = nil
            addWishLabel.textColor = Constants.textColor
        }
    }
    
    private func restorePlaceholderIfNeeded() {
        if addWishLabel.text.isEmpty {
            setupPlaceholder()
        }
    }
    
    func resetText() {
        addWishLabel.text = Constants.placeholderText
        addWishLabel.textColor = Constants.placeholderColor
    }
}

// MARK: - UITextViewDelegate
extension AddWishCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        removePlaceholder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        restorePlaceholderIfNeeded()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        addWish?(textView.text)
    }
}
