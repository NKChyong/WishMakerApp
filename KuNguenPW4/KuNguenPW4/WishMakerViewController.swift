//
//  WishMakerViewController.swift
//  kunguenPW2
//
//  Created by Нгуен Куиет Чыонг on 04.11.2024.
//

import UIKit
final class WishMakerViewController: UIViewController {
    
    // MARK: - Constants
    
    enum Constants {
        static let sliderMin: Double = 0
        static let sliderMax: Double = 255
        static let red: String = "Red"
        static let green: String = "Green"
        static let blue: String = "Blue"
        static let title: String = "WishMaker"
        static let description: String = "This app will bring joy and will fulfill three of your wishes!" + "\n\t - The first wish is to change the background color."
        static let titleFontSize: CGFloat = 32
        static let stackRadius: CGFloat = 20
        static let stackBottom: CGFloat = -20
        static let stackLeading: CGFloat = 20
        static let titleLeading: CGFloat = 20
        static let titleTop: CGFloat = 50
        static let descriptionFontSize: CGFloat = 20
        static let descriptionLeading: CGFloat = 20
        static let descriptionTrailing: CGFloat = 20
        static let descriptionTop: CGFloat = 50
        static let stackCornerRadius: CGFloat = 20
        static let buttonHeight: CGFloat = 50
        static let buttonBottom: CGFloat = 40
        static let buttonSide: CGFloat = 20
        static let addWishButtonText = "Add more wishes"
        static let scheduleWishesButtonText = "Schedule wish granting"
        static let buttonRadius: CGFloat = 20
        static let spacing : CGFloat = 10
        static let actionStackBottom: CGFloat = 20
    }
    
    // MARK: - Properties
    private let addWishButton: UIButton = UIButton(type: .system)
    private let scheduleWishesButton: UIButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    public var redNumber: Double = 0
    public var greenNumber: Double = 0
    public var blueNumber: Double = 0
    private let actionStack: UIStackView = UIStackView()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        view.backgroundColor = .systemPink
        configureTitle()
        configureDescription()
        configureActionStack()
        configureSliders()
    }
    
    // MARK: - Title Configuration
    
    private func configureTitle() {
        titleLabel.textColor = UIColor.white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = Constants.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: Constants.titleFontSize)
        
        view.addSubview(titleLabel)
        titleLabel.pinCenterX(to: view.centerXAnchor)
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.titleTop)
    }
    
    // MARK: - Description Configuration

    private func configureDescription() {
        let descriptionLabel = UILabel()
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = Constants.description
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: Constants.descriptionFontSize)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.5

        view.addSubview(descriptionLabel)
        descriptionLabel.pinCenterX(to: view.centerXAnchor)
        descriptionLabel.pinLeft(to: view.leadingAnchor, Constants.descriptionLeading)
        descriptionLabel.pinRight(to: view.trailingAnchor, Constants.descriptionTrailing)
        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, Constants.descriptionTop)
    }
    
    // MARK: - Sliders Configuration
    
    private func configureSliders() {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        view.addSubview(stack)
        stack.layer.cornerRadius = Constants.stackCornerRadius
        stack.clipsToBounds = true
        
        let sliderRed = CustomSlider(title: Constants.red, min: Constants.sliderMin, max: Constants.sliderMax)
        let sliderGreen = CustomSlider(title: Constants.green, min: Constants.sliderMin, max: Constants.sliderMax)
        let sliderBlue = CustomSlider(title: Constants.blue, min: Constants.sliderMin, max: Constants.sliderMax)
        
        for slider in [sliderRed, sliderGreen, sliderBlue] {
            stack.addArrangedSubview(slider)
        }
        
        stack.pinCenterX(to: view.centerXAnchor)
        stack.pinLeft(to: view.leadingAnchor, Constants.stackLeading)
        stack.pinBottom(to: actionStack.topAnchor, -1 * Constants.stackBottom)
        
        sliderRed.valueChanged = { [weak self] value in
            guard let self = self else { return }
            self.redNumber = value / 255
            self.updateColors()
        }

        sliderGreen.valueChanged = { [weak self] value in
            guard let self = self else { return }
            self.greenNumber = value / 255
            self.updateColors()
        }

        sliderBlue.valueChanged = { [weak self] value in
            guard let self = self else { return }
            self.blueNumber = value / 255
            self.updateColors()
        }
    }
    
    // MARK: - Action Stack Configuration
    
    private func configureActionStack() {
        actionStack.axis = .vertical
        view.addSubview(actionStack)
        actionStack.spacing = Constants.spacing
        
        for button in [addWishButton, scheduleWishesButton] {
            actionStack.addArrangedSubview(button)
        }
        
        configureAddWishButton()
        configureScheduleWishesButton()
        
        actionStack.pinBottom(to: view, Constants.actionStackBottom)
        actionStack.pinHorizontal(to: view, Constants.stackLeading)
    }
    
    // MARK: - Button Configuration

    private func configureAddWishButton() {
        addWishButton.setHeight(Constants.buttonHeight)
        
        addWishButton.backgroundColor = .white
        addWishButton.setTitleColor(.systemPink, for: .normal)
        addWishButton.setTitle(Constants.addWishButtonText, for: .normal)
        
        addWishButton.layer.cornerRadius = Constants.buttonRadius
        addWishButton.addTarget(self, action: #selector(addWishButtonPressed), for: .touchUpInside)
    }
    
    private func configureScheduleWishesButton() {
        scheduleWishesButton.setHeight(Constants.buttonHeight)

        scheduleWishesButton.backgroundColor = .white
        scheduleWishesButton.setTitleColor(.systemPink, for: .normal)
        scheduleWishesButton.setTitle(Constants.scheduleWishesButtonText, for: .normal)
        
        scheduleWishesButton.layer.cornerRadius = Constants.buttonRadius
        scheduleWishesButton.addTarget(self, action: #selector(scheduleWishesButtonPressed), for: .touchUpInside)
    }
    
    @objc private func addWishButtonPressed() {
        let vc = WishStoringViewController()
        vc.backgroundColor = view.backgroundColor
        present(vc, animated: true)
    }
    
    @objc private func scheduleWishesButtonPressed() {
        let vc = WishCalendarViewController()
        vc.backgroundColor = view.backgroundColor
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Helper Methods
    
    private func updateColors() {
        let selectedColor = UIColor(
                    red: CGFloat(redNumber),
                    green: CGFloat(greenNumber),
                    blue: CGFloat(blueNumber),
                    alpha: 1
                )
        view.backgroundColor = selectedColor
        addWishButton.setTitleColor(selectedColor, for: .normal)
        scheduleWishesButton.setTitleColor(selectedColor, for: .normal)

    }
}
