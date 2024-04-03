//
//  SspViewController.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 22/03/24.
//

import UIKit
class SspViewController: UIViewController {
    
    @IBOutlet weak var Logo: UIImageView!
    
    let userData = UserData.sharedData()
    
     override func viewDidLoad() {
         super.viewDidLoad()
         Logo.frame.origin.y = view.frame.height
         Logo.frame.origin.x = (view.frame.width - Logo.frame.width)/2.0
     }
     
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1, delay: 0.5, options: .curveLinear) {
            self.Logo.frame.origin.y = (self.view.frame.height - self.Logo.frame.height)/2.0
        } completion: { res in
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
                if self.userData.rememberMe == false {
                    self.performSegue(withIdentifier: "sgSplash", sender: nil)
                } else if self.userData.rememberMe == true && self.userData.jwt.count > 1 {
                    self.performSegue(withIdentifier: "sgRememberMe", sender: self)
                } else {
                    self.performSegue(withIdentifier: "sgSplash", sender: nil)
                }
            }
        }
    }
 }
    
