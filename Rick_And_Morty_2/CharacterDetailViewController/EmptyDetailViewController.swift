//
//  EmptyDetailViewController.swift
//  Rick_And_Morty_2
//
//  Created by Никита Анонимов on 01.07.2022.
//

import UIKit

class EmptyDetailViewController: UIViewController {
   
    @IBOutlet var backVisualEffect: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backVisualEffect.layer.cornerRadius = 10
        backVisualEffect.layer.masksToBounds = true
    }
}
