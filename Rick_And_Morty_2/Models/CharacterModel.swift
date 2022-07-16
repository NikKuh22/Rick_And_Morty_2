//
//  Struct.swift
//  Rick_And_Morty_2
//
//  Created by Никита Анонимов on 01.06.2022.
//

import UIKit

struct CharacterModel: Decodable {
    var info: InfoModel
    var results: [ResultsModel]
    
    init() {
        info = InfoModel()
        results = [ResultsModel]()
    }
}
