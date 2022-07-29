//
//  NotificationViewController.swift
//  NotificationContent
//
//  Created by Никита Анонимов on 26.07.2022.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    private let gradientLayer = CAGradientLayer()
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imageAvatar: UIImageView!
    @IBOutlet var dateCreateLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var stackWithAllLabel: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let size = view.bounds.size
        let sizeStack = stackWithAllLabel.bounds.size
        preferredContentSize = CGSize(width: size.width, height: sizeStack.height + 20)
        
        imageAvatar.layer.cornerRadius = 15
        imageAvatar.layer.cornerCurve = .continuous
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    func didReceive(_ notification: UNNotification) {
        
        let content = notification.request.content
        
        let color = UIColor.blue
        
        gradientLayer.colors = [
            color.withAlphaComponent(0.35).cgColor as Any,
            color.withAlphaComponent(0.15).cgColor as Any
        ]
        gradientLayer.startPoint = .init(x: 0, y: 0)
        gradientLayer.endPoint = .init(x: 1, y: 1)
        gradientLayer.locations = [0, 0.4]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        self.nameLabel.text = content.title
        self.infoLabel.text = content.body
        
        if let data = content.userInfo["dateCreated"] as? Date {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_UK")
            formatter.dateStyle = .long
            formatter.timeStyle = .medium
            self.dateCreateLabel.text = formatter.string(from: data)
        }
        
        if let imageURL = content.attachments.first?.url,
           let imageData = try? Data(contentsOf: imageURL) {
            imageAvatar.image = UIImage(data: imageData)
        }
    }
}

