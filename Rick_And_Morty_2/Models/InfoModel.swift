//
//  InfoModel.swift
//  Rick_And_Morty_2
//
//  Created by Никита Анонимов on 12.06.2022.
//

import UIKit

struct InfoModel: Decodable {
    var count: Int
    var pages: Int
    var next: String
    var prev: String?
    
    init() {
        count = 0
        pages = 0
        next = ""
        prev = nil
    }
}
