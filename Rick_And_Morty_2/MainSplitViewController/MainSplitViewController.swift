//
//  MainSplitViewController.swift
//  Rick_And_Morty_2
//
//  Created by Никита Анонимов on 16.06.2022.
//

import UIKit

final class MainSplitViewController: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
}

extension MainSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        .primary
    }
}
