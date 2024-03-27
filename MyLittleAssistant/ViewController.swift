//
//  ViewController.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 01/03/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Errores_lbl: UILabel!
    
    
    @IBOutlet weak var Password_txt: UITextField!
    
    
    @IBOutlet weak var Email_TxT: UITextField!
    
    
    var maxLenghts = [UITextField: Int]()
    let userData = UserData.sharedData()
    var hasErrors = true
    override func viewDidLoad() {
        super.viewDidLoad()
        Password_txt.layer.cornerRadius = 10
        Password_txt.layer.borderWidth = 1
        Password_txt.layer.borderColor = UIColor.lightGray.cgColor
        Password_txt.layer.shadowColor = UIColor.gray.cgColor
        Password_txt.layer.shadowOffset = CGSize(width: 0, height: 2)
        Password_txt.layer.shadowOpacity = 0.5
        Password_txt.layer.shadowRadius = 2
                
                Email_TxT.layer.cornerRadius = 10
                Email_TxT.layer.borderWidth = 1
                Email_TxT.layer.borderColor = UIColor.lightGray.cgColor
                Email_TxT.layer.shadowColor = UIColor.gray.cgColor
                Email_TxT.layer.shadowOffset = CGSize(width: 0, height: 2)
                Email_TxT.layer.shadowOpacity = 0.5
                Email_TxT.layer.shadowRadius = 2
        
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
        
        maxLenghts[Password_txt] = 20
        
    }
            
    @IBAction func loginButton(_ sender: UIButton) {
        guard let email = Email_TxT.text, !email.isEmpty else {
              showError(message: "Por favor, ingresa tu correo electrónico.")
              return
          }
          
          guard let password = Password_txt.text, !password.isEmpty else {
              showError(message: "Por favor, ingresa tu contraseña.")
              return
          }
          
          if email.isEmpty && password.isEmpty {
              showError(message: "Por favor, llenar todos los campos.")
              return
          }
          
          if isValidEmail(email) {
              Errores_lbl.isHidden = true
              login()
          } else {
              showError(message: "Por favor, ingresa un correo electrónico válido.")
          }
      }
      
      func isValidEmail(_ email: String) -> Bool {
          return email.contains("@")
      }
      
      func showError(message: String) {
          Errores_lbl.isHidden = false
          Errores_lbl.textColor = .red
          Errores_lbl.text = message
          DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
              self.Errores_lbl.isHidden = true
          }
      }
      
      func login() {
          let url = URL(string: "https:/login")! 
          var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
          request.httpMethod = "POST"
          
          let email = Email_TxT.text!
          let password = Password_txt.text!
          
          let requestBody: [String: Any] = [
              "email": email,
              "password": password
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
                  return
              }
              
              guard let data = data else {
                  print("No se recibió data en la respuesta")
                  return
              }
              
              if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                  do {
                      let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                      print("Respuesta: \(responseJSON)")
                      
                      if let jsonDict = responseJSON as? [String: Any], let jwt = jsonDict["jwt"] as? String {
                          DispatchQueue.main.async {
                              self.hasErrors = false
                              self.userData.jwt = jwt
                              self.performSegue(withIdentifier: "sgLogin", sender: self)
                          }
                      }
                  } catch {
                      print("Error al convertir la respuesta a JSON: \(error)")
                  }
              } else {
                  do {
                      let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                      print("Respuesta: \(responseJSON)")
                      
                      if let jsonDict = responseJSON as? [String: Any], let message = jsonDict["message"] as? String {
                          DispatchQueue.main.async {
                              let error = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                              let ok = UIAlertAction(title: "Aceptar", style: .default)
                              error.addAction(ok)
                              self.present(error, animated: true)
                          }
                      }
                  } catch {
                      print("Error al convertir la respuesta a JSON: \(error)")
                  }
              }
          }
          
          task.resume()
      }
    
}


