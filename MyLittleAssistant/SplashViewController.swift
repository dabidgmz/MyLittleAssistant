//
//  SplashViewController.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 22/03/24.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        logo.alpha = 0.0
        logo.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        logo.center  = CGPoint(x: view.center.x, y: -logo.frame.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1.5, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [.curveEaseInOut], animations: {
            self.logo.center = self.view.center
            self.logo.transform = .identity
            self.logo.alpha = 1.0
        }) { (finished) in
            if finished {
                self.performSegue(withIdentifier: "sgSplash", sender: nil)
            }
        }
    }
}
