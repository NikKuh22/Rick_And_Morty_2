//
//  CharacterDetailViewController.swift
//  Rick_And_Morty_2
//
//  Created by Никита Анонимов on 12.06.2022.
//

import UIKit

final class CharacterDetailController {
    // Make this non-optional
    fileprivate let character: ResultsModel
    
    var name: String { character.name }
    var imageURL: URL? { URL(string: character.image) }
    var status: String { character.status.rawValue }
    var statusColor: UIColor? { character.status.color }
    var gender: String { character.gender.rawValue }
    var type: String { character.type }
    var created: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_UK")
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        let formattedString = formatter.string(from: character.created)
        return formattedString
    }
    var typeIsHidden: Bool { character.type.isEmpty }
    
    
    // Pass character via init
    init(character: ResultsModel) {
        self.character = character
    }
}

final class CharacterDetailViewController: UIViewController {
    
    var character: ResultsModel!
    
    var controller: CharacterDetailController!
    private let gradientLayer = CAGradientLayer()
    
    @IBOutlet private var avatarImageView: UIImageView!
    @IBOutlet var describingLabelForCreated: UILabel!
    @IBOutlet var describingLabelForType: UILabel!
    @IBOutlet var describingLabelForStatus: UILabel!
    @IBOutlet var describingLabelForGender: UILabel!
    @IBOutlet var statusVisualEffectView: UIVisualEffectView!
    @IBOutlet var typeVisualEffectView: UIVisualEffectView!
    @IBOutlet var createdVisualEffectView: UIVisualEffectView!
    @IBOutlet var genderVisualEffectView: UIVisualEffectView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var createdLabel: UILabel!
    @IBOutlet var genderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigation()
        createGradient()
        
        if let url = controller.imageURL {
            avatarImageView.downloaded(from: url)
        }
        
        statusLabel.text = "Status:"
        genderLabel.text = "Gender:"
        typeLabel.text = "Type:"
        createdLabel.text = "Created at:"
        
        statusVisualEffectView.layer.cornerRadius = 10
        typeVisualEffectView.layer.cornerRadius = 10
        createdVisualEffectView.layer.cornerRadius = 10
        genderVisualEffectView.layer.cornerRadius = 10
        avatarImageView.layer.cornerRadius = 15
        
        describingLabelForStatus.text = controller.status
        describingLabelForGender.text = controller.gender
        describingLabelForType.text = controller.type
        describingLabelForCreated.text = controller.created
        
        typeVisualEffectView.isHidden = controller.typeIsHidden
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientLayer.frame = view.bounds
    }
}

// MARK: - Private
private extension CharacterDetailViewController {
    func createGradient() {
        let color = controller.statusColor
        
        gradientLayer.colors = [
            color?.withAlphaComponent(0.35).cgColor as Any,
            color?.withAlphaComponent(0.15).cgColor as Any
        ]
        gradientLayer.startPoint = .init(x: 0, y: 0)
        gradientLayer.endPoint = .init(x: 1, y: 1)
        gradientLayer.locations = [0, 0.4]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func configureNavigation() {
        navigationItem.title = controller.name
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
