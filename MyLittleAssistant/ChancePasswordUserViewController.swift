//
//  ChancePasswordUserViewController.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 01/04/24.
//

import UIKit
class ChancePasswordUserViewController: UIViewController{

    @IBOutlet weak var old_password: UITextField!
    
    
    @IBOutlet weak var password: UITextField!
    
    
    
    @IBOutlet weak var password_confirmation: UITextField!
    
    
    @IBAction func edit(_ sender: Any) {
        editPassword()
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
        
        password_confirmation.layer.cornerRadius = 10
        password_confirmation.layer.borderWidth = 1
        password_confirmation.layer.borderColor = UIColor.lightGray.cgColor
        password_confirmation.layer.shadowColor = UIColor.gray.cgColor
        password_confirmation.layer.shadowOffset = CGSize(width: 0, height: 2)
        password_confirmation.layer.shadowOpacity = 0.5
        password_confirmation.layer.shadowRadius = 2
        
        password.layer.cornerRadius = 10
        password.layer.borderWidth = 1
        password.layer.borderColor = UIColor.lightGray.cgColor
        password.layer.shadowColor = UIColor.gray.cgColor
        password.layer.shadowOffset = CGSize(width: 0, height: 2)
        password.layer.shadowOpacity = 0.5
        password.layer.shadowRadius = 2
        
        old_password.layer.cornerRadius = 10
        old_password.layer.borderWidth = 1
        old_password.layer.borderColor = UIColor.lightGray.cgColor
        old_password.layer.shadowColor = UIColor.gray.cgColor
        old_password.layer.shadowOffset = CGSize(width: 0, height: 2)
        old_password.layer.shadowOpacity = 0.5
        old_password.layer.shadowRadius = 2
        
    }
    
    
    func editPassword() {
        let url = URL(string: "http://backend.mylittleasistant.online:8000/api/user/update/password")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 50)
        request.httpMethod = "PUT"
        let token = userData.jwt
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        guard let oldPasswordText = old_password.text,
              let newPasswordText = password.text,
              let confirmPasswordText = password_confirmation.text else {
            print("Campos de contraseña vacíos")
            return
        }
        
        let requestBody: [String: Any] = [
            "old_password": oldPasswordText,
            "password": newPasswordText,
            "password_confirmation": confirmPasswordText
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
                    self.logout()
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
    
    
    func logout() {
        let url = URL(string:"http://backend.mylittleasistant.online:8000/api/user/logout")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        
        let token = userData.jwt
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error en el request: \(error)")
                return
            }
            
            guard let data = data else {
                print("No se recibió data en la respuesta")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP recibido: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode == 200 {
                    do {
                        let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                        print("Respuesta del servidor: \(responseJSON)")
                        
                        DispatchQueue.main.async {
                            self.userData.jwt = ""
                            self.userData.rememberMe = false
                            self.performSegue(withIdentifier: "sgLogout01", sender: self)
                        }
                    } catch {
                        print("Error al convertir la respuesta a JSON: \(error)")
                    }
                } else {
                    print("Error en la solicitud: Código de estado HTTP \(httpResponse.statusCode)")
                }
            } else {
                print("No se recibió una respuesta HTTP válida")
            }
            
            print("El usuario ha abandonado My Little Assistant")
        }
        
        task.resume()
    }

}
