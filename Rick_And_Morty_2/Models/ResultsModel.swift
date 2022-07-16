//
//  Results.swift
//  Rick_And_Morty_2
//
//  Created by Никита Анонимов on 12.06.2022.
//

import UIKit

enum CharacterStatus: String, Decodable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown
    
    var color: UIColor? {
        switch self {
        case .alive: return UIColor(named: "AliveGreenColor")
        case .dead: return UIColor(named: "DeadRedColor")
        case .unknown: return UIColor(named: "UnknownGrayColor")
        }
    }
}

enum CharacterGender: String, Decodable {
    case male = "Male"
    case female = "Female"
    case genderless = "Genderless"
    case unknown
}

struct ResultsModel: Decodable {
    var id: Int
    var name: String
    var status: CharacterStatus
    var species: String
    var type: String
    var gender: CharacterGender
    var origin: OriginModel
    var location: LocationModel
    var image: String
    var episode: [String]
    var url: String
    var created: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case species
        case type
        case gender
        case origin
        case location
        case image
        case episode
        case url
        case created
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        status = try container.decode(CharacterStatus.self, forKey: .status)
        species = try container.decode(String.self, forKey: .species)
        type = try container.decode(String.self, forKey: .type)
        gender = try container.decode(CharacterGender.self, forKey: .gender)
        origin = try container.decode(OriginModel.self, forKey: .origin)
        location = try container.decode(LocationModel.self, forKey: .location)
        image = try container.decode(String.self, forKey: .image)
        episode = try container.decode([String].self, forKey: .episode)
        url = try container.decode(String.self, forKey: .url)
        let createdString = try container.decode(String.self, forKey: .created)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let date = formatter.date(from: createdString) {
            created = date
        } else {
            throw CharacterParseError.cannotParseDateFrom(createdString)
        }
    }
}

enum CharacterParseError: Error {
    case cannotParseDateFrom(String)
}
