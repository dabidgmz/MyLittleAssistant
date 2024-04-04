//
//  tokens.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 28/03/24.
//

import UIKit

class tokens: UIViewController {
 
    

    
    
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
   
    }
    

    @IBAction func verificar(_ sender: Any) {
        activarCuenta()
    }
    
    func activarCuenta(){
        let url = URL(string:"https://verificar")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        let codigo = ""
        let requestBody: [String: Any] = [
            "codigo": codigo,
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
                    
                    DispatchQueue.main.async {
                        self.hasErrors = false
                        self.performSegue(withIdentifier: "sgVerificar", sender: self)
                    }
                } catch {
                    print("Error al convertir la respuesta a JSON: \(error)")
                }
            }else {
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Respuesta: \(responseJSON)")
                    
                    if let jsonDict = responseJSON as? [String: Any],
                       let message = jsonDict["message"] as? String {
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
}
    
