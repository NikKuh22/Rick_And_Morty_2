//
//  Extension.swift
//  Rick_And_Morty_2
//
//  Created by Никита Анонимов on 01.06.2022.
//

import UIKit

extension UIImageView {
    private static let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(memoryCapacity: 300 * 1024 * 1024, diskCapacity: 300 * 1024 * 1024)
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: configuration)
    }()
    
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        
        Self.session.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }.resume()
    }
}
