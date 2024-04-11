//
//  ViewController.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 01/03/24.
//

import UIKit
import UserNotifications
class ViewController: UIViewController, UNUserNotificationCenterDelegate{

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
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Permiso concedido para mostrar notificaciones")
            } else {
                print("Permiso denegado para mostrar notificaciones")
            }
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ocultarTeclado))
        view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func ocultarTeclado(){
        view.endEditing(true)
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
        let url = URL(string: "http://backend.mylittleasistant.online:8000/api/user/login")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 50)
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
                    
                    if httpResponse.statusCode == 201 {
                        if let jsonDict = responseJSON as? [String: Any],
                           let userDataDict = jsonDict["data"] as? [String: Any],
                           let userID = userDataDict["id"] as? Int{
                            DispatchQueue.main.async {
                                self.hasErrors = false
                                self.userData.email = email
                                self.userData.password = password
                                self.userData.id = userID
                                self.userData.rememberMe = true
                                print("Correo electrónico guardado: \(self.userData.email)")
                                print("Contraseña guardada: \(self.userData.password)")
                                self.performSegue(withIdentifier: "sgLogin", sender: self)
                                self.showWelcomeNotification()
                                print("hasErrors: \(self.hasErrors)")
                                print("UserID: \(userID)")
                                print("RememberMe: \(self.userData.rememberMe)")
                                self.userData.save()
                                self.EmailVerifyCode()
                            }
                        }
                    }else if httpResponse.statusCode == 404 {
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
        if identifier == "sgLogin" {
            if !hasErrors {
                return true
            }
            
            return false
        }
            
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == Email_TxT {
            Password_txt.becomeFirstResponder()
        } else if textField == Password_txt {
            Password_txt.resignFirstResponder()
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLenght = maxLenghts[textField] ?? Int.max
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
    
        return newString.length <= maxLenght
    }
    
    func showWelcomeNotification() {
        let content = UNMutableNotificationContent()
        content.title = "¡Bienvenido a My Little Assistant!"
        content.body = "¡Gracias por iniciar sesión!"
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "welcomeNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error al agregar la solicitud de notificación de bienvenida: \(error.localizedDescription)")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
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
    
    func EmailVerifyCode() {
        let id = userData.id
        let url = URL(string: "http://backend.mylittleasistant.online:8000/api/emailsend/\(id)")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 50)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
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
            
            if statusCode == 200 {
                print("Código enviado con éxito")
            } else {
                print("Error en la solicitud: Código de estado HTTP \(statusCode)")
                self.hasErrors = true
            }
        }
        task.resume()
    }

}

