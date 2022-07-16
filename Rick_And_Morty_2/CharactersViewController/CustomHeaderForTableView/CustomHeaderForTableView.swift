//
//  HeaderForTableView.swift
//  Rick_And_Morty_2
//
//  Created by Никита Анонимов on 25.06.2022.
//

import UIKit

class CustomHeaderForTableView: UITableViewHeaderFooterView {
    
    @IBOutlet private var titleLabel: UILabel!
    
    func config(with title: String) {
        titleLabel.text = title
    }
}
