//
//  RegisterViewController.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 01/03/24.
//

import UIKit

class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let gradientLayer = CAGradientLayer()
              gradientLayer.frame = view.bounds
              gradientLayer.colors = [UIColor(red: 7/255, green: 153/255, blue: 182/255, alpha: 1).cgColor, UIColor.white.cgColor]
              gradientLayer.locations = [0, 1]
              view.layer.insertSublayer(gradientLayer, at: 0)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
