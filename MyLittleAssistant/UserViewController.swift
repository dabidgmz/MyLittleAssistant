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
          guard let url = URL(string: "https://getuser") else {
              print("URL inválida")
              return
          }
          var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
          request.httpMethod = "GET"
          if let token = userData.jwt {
              request.addValue("application/json", forHTTPHeaderField: "Content-Type")
              request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
          } else {
              print("No se encontró token de autenticación")
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
              do {
                  let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                  if let userData = json?["data"] as? [String: Any],
                     let name = userData["name"] as? String,
                     let email = userData["email"] as? String {
                      DispatchQueue.main.async {
                          self.name_txt.text = name
                          self.email_txt.text = email
                      }
                  } else {
                      print("No se pudo obtener la información del usuario desde la respuesta")
                  }
              } catch {
                  print("Error al convertir la respuesta a JSON: \(error)")
              }
          }

          task.resume()
      }
    
}
