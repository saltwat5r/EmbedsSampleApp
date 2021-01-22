//
//  ViewController.swift
//  EmbedsSampleApp
//
//

import UIKit
import WebKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton(type: .custom)
        button.setTitle("Show news", for: .normal)
        button.setTitleColor(.black, for: .normal)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        let showAction = UIAction { (action) in
            self.show(NewsViewController(), sender: nil)
        }
        button.addAction(showAction, for: .touchUpInside)
    }
}
