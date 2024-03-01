//
//  ViewController.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 01/03/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(red: 7/255, green: 153/255, blue: 182/255, alpha: 1).cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0, 0.5]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }


}

