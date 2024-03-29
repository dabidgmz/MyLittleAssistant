//
//  RegisterViewController.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 01/03/24.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var Email_Txt: UITextField!
   
    
    
    @IBOutlet weak var Name_Txt: UITextField!
    
    
    
    @IBOutlet weak var Password_Txt: UITextField!
    
    
    
    @IBOutlet weak var Confirm_Password_Txt: UITextField!
    
    
    
    
    @IBAction func Register(_ sender: Any) {
        register()
    }
    
    
    
    
    @IBOutlet weak var Errores_lbl: UILabel!
    
    
    
  
    
    let userData = UserData.sharedData()
    var hasErrors = true
    var maxLenghts = [UITextField: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Confirm_Password_Txt.layer.cornerRadius = 10
        Confirm_Password_Txt.layer.borderWidth = 1
        Confirm_Password_Txt.layer.borderColor = UIColor.lightGray.cgColor
        Confirm_Password_Txt.layer.shadowColor = UIColor.gray.cgColor
        Confirm_Password_Txt.layer.shadowOffset = CGSize(width: 0, height: 2)
        Confirm_Password_Txt.layer.shadowOpacity = 0.5
        Confirm_Password_Txt.layer.shadowRadius = 2
        
        Password_Txt.layer.cornerRadius = 10
        Password_Txt.layer.borderWidth = 1
        Password_Txt.layer.borderColor = UIColor.lightGray.cgColor
        Password_Txt.layer.shadowColor = UIColor.gray.cgColor
        Password_Txt.layer.shadowOffset = CGSize(width: 0, height: 2)
        Password_Txt.layer.shadowOpacity = 0.5
        Password_Txt.layer.shadowRadius = 2
                
        Name_Txt.layer.cornerRadius = 10
        Name_Txt.layer.borderWidth = 1
        Name_Txt.layer.borderColor = UIColor.lightGray.cgColor
        Name_Txt.layer.shadowColor = UIColor.gray.cgColor
        Name_Txt.layer.shadowOffset = CGSize(width: 0, height: 2)
        Name_Txt.layer.shadowOpacity = 0.5
        Name_Txt.layer.shadowRadius = 2
                
        Email_Txt.layer.cornerRadius = 10
        Email_Txt.layer.borderWidth = 1
        Email_Txt.layer.borderColor = UIColor.lightGray.cgColor
        Email_Txt.layer.shadowColor = UIColor.gray.cgColor
        Email_Txt.layer.shadowOffset = CGSize(width: 0, height: 2)
        Email_Txt.layer.shadowOpacity = 0.5
        Email_Txt.layer.shadowRadius = 2
        maxLenghts[Name_Txt] = 40
        maxLenghts[Password_Txt] = 20
        maxLenghts[Confirm_Password_Txt] = 20
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
    
    
    func register() {
        let url = URL(string: "http://backend.mylittleasistant.online:8000/api/user/register")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 50)
        request.httpMethod = "POST"
        
        let name = Name_Txt.text!
        let email = Email_Txt.text!
        let password = Password_Txt.text!
        let password_confirmation = Confirm_Password_Txt.text!
          
        let requestBody: [String: Any] = [
            "name": name,
            "email": email,
            "password": password,
            "password_confirmation" : password_confirmation
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
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
            
            if statusCode == 201 {
                self.showSuccess(message: "Registrado correctamente")
                DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "sgRegister", sender: self)
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
                self.hasErrors = true
            }
        }
        
        task.resume()
    }


    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "sgRegister" {
            if !hasErrors {
                return true
            }
            
            return false
        }
            
        return false
    }

    
    func validateAndRegister() {
        guard let name = Name_Txt.text, let email = Email_Txt.text, let password = Password_Txt.text, let confirmPassword = Confirm_Password_Txt.text else {
            showError(message: "Por favor, completa todos los campos.")
            return
        }

        if let nameError = validateName(name) {
            showError(message: nameError)
            return
        }

        if let emailError = validateEmail(email) {
            showError(message: emailError)
            return
        }

        if let passwordError = validatePassword(password) {
            showError(message: passwordError)
            return
        }

        if let confirmPasswordError = validateConfirmPassword(password, confirmPassword) {
            showError(message: confirmPasswordError)
            return
        }
        register()
    }

    func validateEmail(_ email: String) -> String? {
            if email.isEmpty {
                return "El correo electrónico es obligatorio."
            }
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            if !emailPredicate.evaluate(with: email) {
                return "Formato de correo electrónico inválido."
            }
            return nil
        }

    func validatePassword(_ password: String) -> String? {
        if password.isEmpty {
            return "La contraseña es obligatoria."
        }
        if password.count < 5 {
            return "La contraseña debe tener al menos 5 caracteres."
        }
        let digitRegex = ".*[0-9]+.*"
        let digitPredicate = NSPredicate(format: "SELF MATCHES %@", digitRegex)
        if !digitPredicate.evaluate(with: password) {
            return "La contraseña debe contener al menos un dígito."
        }
        return nil
    }

        func validateConfirmPassword(_ password: String, _ confirmPassword: String) -> String? {
            if password != confirmPassword {
                return "Las contraseñas no coinciden."
            }
            return nil
        }

        func validateName(_ name: String) -> String? {
            if name.isEmpty {
                return "El nombre es obligatorio."
            }
            if name.count < 3 {
                return "El nombre debe tener al menos 3 caracteres."
            }
            if name.count > 40 {
                return "El nombre debe tener como máximo 40 caracteres."
            }
            return nil
        }

    func showError(message: String) {
        DispatchQueue.main.async {
            self.Errores_lbl.isHidden = false
            self.Errores_lbl.textColor = .red
            self.Errores_lbl.text = message
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.Errores_lbl.isHidden = true
            }
        }
    }
    func showSuccess(message: String) {
        DispatchQueue.main.async {
            self.Errores_lbl.isHidden = false
            self.Errores_lbl.textColor = .green
            self.Errores_lbl.text = message
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.Errores_lbl.isHidden = true
            }
        }
    }

    
}
