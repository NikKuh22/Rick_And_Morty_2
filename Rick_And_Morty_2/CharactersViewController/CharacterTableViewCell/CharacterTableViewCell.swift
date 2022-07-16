//
//  CharacterTableViewCell.swift
//  Rick_And_Morty_2
//
//  Created by Никита Анонимов on 12.06.2022.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    @IBOutlet private var nameCharacter: UILabel!
    @IBOutlet private var imageAvatar: UIImageView!
    @IBOutlet private var speciesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageAvatar.layer.cornerRadius = 25
    }
    
    func configure(character: ResultsModel) {
        nameCharacter.text = character.name
        speciesLabel.text = character.species
        if let urlForImageAvatar = URL(string: character.image) {
            imageAvatar.downloaded(from: urlForImageAvatar)
        }
        
        imageAvatar.layer.borderColor = character.status.color?.cgColor
        imageAvatar.layer.borderWidth = 1.5
    }
}
