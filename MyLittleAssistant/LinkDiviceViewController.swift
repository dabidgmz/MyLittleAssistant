//
//  LinkDiviceViewController.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 29/03/24.
//

import UIKit

class LinkDiviceViewController: UIViewController {

    @IBOutlet weak var Code_txt: UITextField!
    
    
    @IBOutlet weak var Errors_txt: UILabel!
    
    
    
    @IBAction func Vincular_btn(_ sender: Any) {
        VincularDivice()
    }
    
    let userData = UserData.sharedData()
    var hasErrors = true
    var maxLenghts = [UITextField: Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Code_txt.layer.cornerRadius = 10
        Code_txt.layer.borderWidth = 1
        Code_txt.layer.borderColor = UIColor.lightGray.cgColor
        Code_txt.layer.shadowColor = UIColor.gray.cgColor
        Code_txt.layer.shadowOffset = CGSize(width: 0, height: 2)
        Code_txt.layer.shadowOpacity = 0.5
        Code_txt.layer.shadowRadius = 2
        
        
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
    
    func VincularDivice() {
        guard let device_code = Code_txt.text, !device_code.isEmpty else {
                showError(message: "Favor de proporcionar un código")
                return
        }
        let url = URL(string: "http://backend.mylittleasistant.online:8000/api/user/link/device")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 50)
        request.httpMethod = "POST"
        let token = userData.jwt
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let requestBody: [String: Any] = [
            "device_code": device_code,
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
                self.showError(message: "Error en la solicitud: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("No se recibió una respuesta HTTP válida")
                self.showError(message: "No se recibió una respuesta HTTP válida")
                return
            }
            
            let statusCode = httpResponse.statusCode
            print("Código de estado HTTP recibido: \(statusCode)")
            
            if let data = data {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Respuesta JSON: \(responseJSON)")
                    if statusCode == 400 {
                        self.showError(message: "Dispositivo ya vinculado")
                        return
                    }
                } catch {
                    print("Error al convertir la respuesta a JSON: \(error)")
                }
            } else {
                print("No se recibió data en la respuesta")
            }
            
            if statusCode == 200 {
                print("Dispositivo vinculado correctamente")
                self.showSuccess(message: "Vinculado correctamente")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "sgVincular", sender: self)
                    if let data = data,
                       let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let signedRoute = jsonDict["url"] as? String {
                        self.userData.signedRoute = signedRoute
                        self.hasErrors = false
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
            self.Errors_txt.isHidden = false
            self.Errors_txt.textColor = .red
            self.Errors_txt.text = message
            self.Errors_txt.textAlignment = .center
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.Errors_txt.isHidden = true
            }
        }
    }
    func showSuccess(message: String) {
        DispatchQueue.main.async {
            self.Errors_txt.isHidden = false
            self.Errors_txt.textColor = .green
            self.Errors_txt.text = message
            self.Errors_txt.textAlignment = .center
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.Errors_txt.isHidden = true
            }
        }
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "sgVincular" {
            if !hasErrors {
                return true
            }
            
            return false
        }
            
        return false
    }
}
