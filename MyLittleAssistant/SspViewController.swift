//
//  SspViewController.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 22/03/24.
//

import UIKit

class SspViewController: UIViewController {

    @IBOutlet weak var Logo: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1.5, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [.curveEaseInOut], animations: {
            self.Logo.center = self.view.center
            self.Logo.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.Logo.alpha = 1.0
        }) { (finished) in
            if finished {
                self.startRotationAnimation()
                self.performSegue(withIdentifier: "sgSplash", sender: nil)
            }
        }
    }
    
    func startRotationAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = 10
        rotationAnimation.repeatCount = .infinity
        
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = UIColor.clear.cgColor
        colorAnimation.toValue = UIColor.systemBlue.cgColor
        colorAnimation.duration = 10
        colorAnimation.autoreverses = true
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [rotationAnimation, colorAnimation]
        groupAnimation.duration = 10
        groupAnimation.repeatCount = .infinity
        Logo.layer.add(groupAnimation, forKey: "rotationAndColorAnimation")
    }
}
