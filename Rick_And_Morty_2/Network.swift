//
//  Network.swift
//  Rick_And_Morty_2
//
//  Created by Никита Анонимов on 05.06.2022.
//

import UIKit

class Network {
    static private let apiURL = URL(string: "https://rickandmortyapi.com/api")!
    
    func fetchCharacter(page: String, completion: @escaping (ResultsModel) -> Void) {
        guard let url = URL(string: page) else {
//            completion(ResultsModel)
            return
        }

        fetchCharacterResult(from: url, completion: completion)
    }
    
    func fetchCharacters(completion: @escaping (CharacterModel) -> Void) {
        let url = Self.apiURL.appendingPathComponent("character")
        
        fetch(from: url, completion: completion)
    }
    
    func fetchNextCharacters(page: String, completion: @escaping (CharacterModel) -> Void) {
        guard let url = URL(string: page) else {
            completion(CharacterModel())
            return
        }
        
        fetch(from: url, completion: completion)
    }
    
    private func fetchCharacterResult(from url: URL, completion: @escaping (ResultsModel) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }

            do {
                let task = try JSONDecoder().decode(ResultsModel.self, from: data)
                DispatchQueue.main.async {
                    completion(task)
                }
            } catch {
                print(error)
            }

        }.resume()
    }
    
    private func fetch(from url: URL, completion: @escaping (CharacterModel) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let task = try JSONDecoder().decode(CharacterModel.self, from: data)
                DispatchQueue.main.async {
                    completion(task)
                }
            } catch {
                print(error)
            }
            
        }.resume()
    }
}
