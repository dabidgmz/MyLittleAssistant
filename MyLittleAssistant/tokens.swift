//
//  tokens.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 28/03/24.
//

import UIKit

class tokens: UIViewController {
    @IBOutlet weak var num1TF: UITextField!
    

    @IBOutlet weak var num2TF: UITextField!
    
    
    @IBOutlet weak var num3TF: UITextField!
    
    @IBOutlet weak var num4TF: UITextField!
    
    
    
    @IBOutlet weak var btnverificar: UIButton!
    
    
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
        
        maxLenghts[num1TF] = 1
        maxLenghts[num2TF] = 1
        maxLenghts[num3TF] = 1
        maxLenghts[num4TF] = 1
        btnverificar.isEnabled = false
    }
    

    @IBAction func verificar(_ sender: Any) {
        activarCuenta()
    }
    
    func activarCuenta(){
        let url = URL(string:"https://verificar")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        let codigo = num1TF.text! + num2TF.text! + num3TF.text! + num4TF.text!
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == num1TF {
            num2TF.becomeFirstResponder()
        } else if textField == num2TF {
            num2TF.resignFirstResponder()
        }
        
        if textField == num2TF {
            num3TF.becomeFirstResponder()
        } else if textField == num3TF {
            num3TF.resignFirstResponder()
        }
        
        if textField == num3TF {
            num4TF.becomeFirstResponder()
        } else if textField == num4TF {
            num4TF.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLenght = maxLenghts[textField] ?? Int.max
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
    
        return newString.length <= maxLenght
    }
    @IBAction func numerounoChange(_ sender: Any) {
        if let numeroUno = num1TF.text {
            print(numeroUno)
           checkForm()
        }
    }
    
    @IBAction func numerodosChange(_ sender: Any) {
        if let numeroDos = num2TF.text {
            print(numeroDos)
           checkForm()
        }
    }
    
    @IBAction func numerotresChange(_ sender: Any) {
        if let numeroTres = num3TF.text {
            print(numeroTres)
           checkForm()
        }
    }
    
    @IBAction func numerocuatroChange(_ sender: Any) {
        if let numeroCuatro = num4TF.text {
            print(numeroCuatro)
           checkForm()
        }
    }
    
    func checkForm() {
        if num1TF.text?.count == 1 && num2TF.text?.count == 1 && num3TF.text?.count == 1 && num4TF.text?.count == 1 {
            btnverificar.isEnabled = true
        } else {
            btnverificar.isEnabled = false
        }
    }
}
    
