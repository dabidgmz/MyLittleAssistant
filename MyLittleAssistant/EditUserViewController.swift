//
//  EditUserViewController.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 29/03/24.
//

import UIKit





class EditUserViewController: UIViewController {

    @IBOutlet weak var Name_txt: UITextField!
    
    
    
    @IBOutlet weak var Email_txt: UITextField!
    
    
    
    @IBOutlet weak var password_txt: UITextField!
    
    
    
    @IBOutlet weak var Password_Confirmation: UITextField!
    
    
    
    
    @IBAction func Confirm_Edit(_ sender: Any) {
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Password_Confirmation.layer.cornerRadius = 10
        Password_Confirmation.layer.borderWidth = 1
        Password_Confirmation.layer.borderColor = UIColor.lightGray.cgColor
        Password_Confirmation.layer.shadowColor = UIColor.gray.cgColor
        Password_Confirmation.layer.shadowOffset = CGSize(width: 0, height: 2)
        Password_Confirmation.layer.shadowOpacity = 0.5
        Password_Confirmation.layer.shadowRadius = 2
        
        password_txt.layer.cornerRadius = 10
        password_txt.layer.borderWidth = 1
        password_txt.layer.borderColor = UIColor.lightGray.cgColor
        password_txt.layer.shadowColor = UIColor.gray.cgColor
        password_txt.layer.shadowOffset = CGSize(width: 0, height: 2)
        password_txt.layer.shadowOpacity = 0.5
        password_txt.layer.shadowRadius = 2
                
        Name_txt.layer.cornerRadius = 10
        Name_txt.layer.borderWidth = 1
        Name_txt.layer.borderColor = UIColor.lightGray.cgColor
        Name_txt.layer.shadowColor = UIColor.gray.cgColor
        Name_txt.layer.shadowOffset = CGSize(width: 0, height: 2)
        Name_txt.layer.shadowOpacity = 0.5
        Name_txt.layer.shadowRadius = 2
                
        Email_txt.layer.cornerRadius = 10
        Email_txt.layer.borderWidth = 1
        Email_txt.layer.borderColor = UIColor.lightGray.cgColor
        Email_txt.layer.shadowColor = UIColor.gray.cgColor
        Email_txt.layer.shadowOffset = CGSize(width: 0, height: 2)
        Email_txt.layer.shadowOpacity = 0.5
        Email_txt.layer.shadowRadius = 2
        
        
        let gradientLayer = CAGradientLayer()
             gradientLayer.frame = view.bounds
             gradientLayer.colors = [
                 UIColor(red: 1/255, green: 26/255, blue: 64/255, alpha: 1).cgColor,
                 UIColor.black.cgColor
             ]
                gradientLayer.locations = [0.1, 0.2]
                gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
               gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
               
               view.layer.insertSublayer(gradientLayer, at: 0)
    }
    


}
