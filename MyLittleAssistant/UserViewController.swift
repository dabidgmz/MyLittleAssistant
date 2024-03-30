//
//  UserViewController.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 25/03/24.
//

import UIKit

class UserViewController: UIViewController {

   
    
    
    @IBOutlet weak var Nombre_LBL: UILabel!
    
    
    @IBOutlet weak var name_txt: UILabel!
    
    
    
    
    @IBOutlet weak var Email_LBL: UILabel!
    
    
    
    @IBOutlet weak var email_txt: UILabel!
    
    
    
    
    @IBAction func LogOut(_ sender: Any) {
        logout()
    }
    
    
    
    let userData = UserData.sharedData()
    var user: User = User(id: 0, name: "", email: "")
    var userName = ""
    var emailUser = ""
    var maxLenghts = [UITextField: Int]()
    override func viewDidLoad() {
        
        getUser()
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
        
                configureLabelDesign(Nombre_LBL)
                configureLabelDesign(Email_LBL)
    }
    
    func configureLabelDesign(_ label: UILabel) {
             label.textColor = UIColor.white
               label.font = UIFont.boldSystemFont(ofSize: 18)
               label.layer.cornerRadius = 3
               label.clipsToBounds = true
               label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
               label.layer.borderWidth = 1.0
               label.layer.borderColor = UIColor.gray.cgColor
                       
    }
    
    func getUser() {
           let url = URL(string: "http://backend.mylittleasistant.online:8000/api/user/info")!
           var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 50)
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
               if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                   do {
                       let responseJSON = try JSONSerialization.jsonObject(with: data, options: [])
                       print("Respuesta: \(responseJSON)")
                       
                       if let jsonDict = responseJSON as? [String: Any],
                          let dataDict = jsonDict["data"] as? [String: Any],
                          let name = dataDict["name"] as? String, let email = dataDict["email"] as? String {
                           DispatchQueue.main.async {
                               self.name_txt.text = name
                               self.email_txt.text = email
                           }
                       }
                   } catch {
                       print("Error al convertir la respuesta a JSON: \(error)")
                   }
               }
           }
           
           task.resume()
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
                            self.performSegue(withIdentifier: "sgLogout", sender: self)
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
