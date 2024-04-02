//
//  ForgotPasswordViewController.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 02/04/24.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var Email_txt: UITextField!
    
    
    
    @IBOutlet weak var Errors_lbl: UILabel!
    
    
    @IBAction func Confirm(_ sender: Any) {
        Ok()
    }
    
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
        
        Email_txt.layer.cornerRadius = 10
        Email_txt.layer.borderWidth = 1
        Email_txt.layer.borderColor = UIColor.lightGray.cgColor
        Email_txt.layer.shadowColor = UIColor.gray.cgColor
        Email_txt.layer.shadowOffset = CGSize(width: 0, height: 2)
        Email_txt.layer.shadowOpacity = 0.5
        Email_txt.layer.shadowRadius = 2
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
    
    func Ok() {
        let email = Email_txt.text!
        let url = URL(string: "http://backend.mylittleasistant.online:8000/api/recovery/password")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 50)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
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
                self.showSuccess(message: "Se ha enviado un correo electrónico correctamente")
                DispatchQueue.main.async {
                    self.showPasswordChangeAlert()
                }
            } else {
                print("Error en la solicitud: Código de estado HTTP \(statusCode)")
                self.showError(message: "Error en la solicitud: Código de estado HTTP \(statusCode)")
                self.hasErrors = true
            }
        }
        
        task.resume()
    }
    
    
    func showPasswordChangeAlert() {
        let alert = UIAlertController(title: "¡Atención!", message: "Se enviará un correo para restablecer tu contraseña.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Entendido", style: .default) { _ in
            self.performSegue(withIdentifier: "sgPassowrd", sender: self)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
