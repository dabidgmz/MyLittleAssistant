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
    
    
    
 
    @IBAction func Edit_Confirm(_ sender: Any) {
        UpdateUser()
    }
    
    
    
    
    @IBOutlet weak var Errors_lbl: UILabel!
    
    
    let userData = UserData.sharedData()
    var hasErrors = true
    var user: User = User(id: 0, name: "", email: "")
    var userName = ""
    var emailUser = ""
    var maxLenghts = [UITextField: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
    
    func UpdateUser() {
        let url = URL(string: "http://backend.mylittleasistant.online:8000/api/user/update")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 50)
        request.httpMethod = "PUT"
        
        let token = userData.jwt
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let name = Name_txt.text!
        let email = Email_txt.text!
        
        let requestBody: [String: Any] = [
            "name": name,
            "email": email
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error al convertir el cuerpo del request a JSON: \(error)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error en el request: \(error)")
                self.hasErrors = true
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("No se recibió una respuesta HTTP válida")
                self.hasErrors = true
                return
            }
            
            let statusCode = httpResponse.statusCode
            print("Código de estado HTTP recibido: \(statusCode)")
            
            if let data = data {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Respuesta JSON: \(responseJSON)")
                } catch {
                    print("Error al convertir la respuesta a JSON: \(error)")
                }
            } else {
                print("No se recibió data en la respuesta")
            }
            
            if statusCode == 200 {
                self.showSuccess(message: "Actualizado correctamente")
                DispatchQueue.main.async {
                    if let data = data,
                       let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let signedRoute = jsonDict["url"] as? String {
                        self.hasErrors = false
                        self.userData.name = name
                        self.userData.email = email
                        self.userData.signedRoute = signedRoute
                    }
                }
            } else {
                print("Error en la solicitud: Código de estado HTTP \(statusCode)")
                           self.showError(message: "Error en la solicitud: Código de estado HTTP \(statusCode)")
                           self.hasErrors = true
            }
        }
        
        task.resume()
    }

    
    func showError(message: String) {
        DispatchQueue.main.async {
            self.Errors_lbl.isHidden = false
            self.Errors_lbl.textColor = .red
            self.Errors_lbl.text = message
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.Errors_lbl.isHidden = true
            }
        }
    }
    func showSuccess(message: String) {
        DispatchQueue.main.async {
            self.Errors_lbl.isHidden = false
            self.Errors_lbl.textColor = .green
            self.Errors_lbl.text = message
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.Errors_lbl.isHidden = true
            }
        }
    }

}
