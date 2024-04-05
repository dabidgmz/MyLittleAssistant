//
//  tokens.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 28/03/24.
//

import UIKit

class tokens: UIViewController {
 
 
    @IBOutlet weak var code_txt: UITextField!
    
    

    @IBAction func verificar(_ sender: Any) {
        activarCuenta()
    }
    
    
    @IBOutlet weak var Errors_lbl: UILabel!
    
    var maxLenghts = [UITextField: Int]()
    let userData = UserData.sharedData()
    var hasErrors = true
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
   
        code_txt.layer.cornerRadius = 10
        code_txt.layer.borderWidth = 1
        code_txt.layer.borderColor = UIColor.lightGray.cgColor
        code_txt.layer.shadowColor = UIColor.gray.cgColor
        code_txt.layer.shadowOffset = CGSize(width: 0, height: 2)
        code_txt.layer.shadowOpacity = 0.5
        code_txt.layer.shadowRadius = 2
    }
        
    func activarCuenta() {
        self.userData.load()
        print("Correo electrónico cargado: \(self.userData.email)")
        print("Contraseña cargada: \(self.userData.password)")
        let url = URL(string: "http://backend.mylittleasistant.online:8000/api/user/login")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 50)
        request.httpMethod = "POST"
        let codigo = code_txt.text!
        guard !codigo.isEmpty && codigo.count <= 6 else {
        showError(message: "El código debe tener entre 1 y 6 caracteres.")
        return
        }
        let email = userData.email
        let password = userData.password
        let requestBody: [String: Any] = [
            "email": email,
            "password": password,
            "codigo": codigo
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
                if (error as NSError).code == NSURLErrorTimedOut {
                    self.showAlert()
                }
                return
            }
            
            guard let data = data else {
                print("No se recibió data en la respuesta")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("Código de estado HTTP recibido: \(httpResponse.statusCode)")
                
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Respuesta JSON: \(responseJSON)")
                    
                    if httpResponse.statusCode == 200 {
                        if let jsonDict = responseJSON as? [String: Any],
                           let token = jsonDict["jwt"] as? String,
                           let userDataDict = jsonDict["data"] as? [String: Any],
                           let userID = userDataDict["id"] as? Int {
                            DispatchQueue.main.async {
                            self.hasErrors = false
                            self.userData.jwt = token
                            self.userData.id = userID
                            self.userData.rememberMe = true
                            self.performSegue(withIdentifier: "sgVerificar", sender: self)
                                print("hasErrors: \(self.hasErrors)")
                                print("JWT token: \(token)")
                                print("UserID: \(userID)")
                                print("RememberMe: \(self.userData.rememberMe)")
                                self.userData.save()
                            }
                        }
                    } else if httpResponse.statusCode == 404 {
                        DispatchQueue.main.async {
                            self.showError(message: "Usuario no encontrado")
                        }
                    } else if httpResponse.statusCode == 401 {
                        DispatchQueue.main.async {
                            self.showError(message: "Contraseña incorrecta")
                        }
                    } else if httpResponse.statusCode == 403 {
                        DispatchQueue.main.async {
                         self.showError(message: "Correo no verificado")
                        }
                    }else if httpResponse.statusCode == 405{
                        DispatchQueue.main.async {
                         self.showError(message: "Codigo incorrecto.")
                        }
                    } else {
                        if let jsonDict = responseJSON as? [String: Any],
                           let message = jsonDict["message"] as? String {
                            DispatchQueue.main.async {
                                let error = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                                let ok = UIAlertAction(title: "Aceptar", style: .default)
                                error.addAction(ok)
                                self.present(error, animated: true)
                            }
                        }
                    }
                } catch {
                    print("Error al convertir la respuesta a JSON: \(error)")
                }
            }
        }
        
        task.resume()
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "sgVerificar" {
            if !hasErrors {
                return true
            }
            
            return false
        }
            
        return false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @objc func showAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "La solicitud ha tardado demasiado. ¿Quieres intentarlo de nuevo?", preferredStyle: .alert)
            let retryAction = UIAlertAction(title: "Reintentar", style: .default) { _ in
            }
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { _ in
            }
            alert.addAction(retryAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showError(message: String) {
        Errors_lbl.isHidden = false
        Errors_lbl.textColor = .red
        Errors_lbl.text = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.Errors_lbl.isHidden = true
        }
    }
}
