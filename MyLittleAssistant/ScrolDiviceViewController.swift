//
//  ScrolDiviceViewController.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 30/03/24.
//

import UIKit

let userData = UserData.sharedData()
var user: User = User(id: 0, name: "", email: "")
var userName = ""
var emailUser = ""
class ScrolDiviceViewController: UIViewController {
    
    
    
    @IBOutlet weak var scrDivice: UIScrollView!
    
    
    var devices: [Device] = []
    
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
        
        fetchDevices()
    }
    
    func fetchDevices() {
        let url = URL(string: "http://backend.mylittleasistant.online:8000/api/user/devices")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 50)
        request.httpMethod = "GET"
        let token = userData.jwt
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("Making request to URL:", url.absoluteString)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error en el request:", error)
                return
            }
            guard let data = data else {
                print("No se recibió data en la respuesta")
                return
            }
            print("Response received:", data)
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code:", httpResponse.statusCode)
            } else {
                print("No se recibió respuesta del servidor")
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Request successful. Status code: 200")
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        print("No se pudo convertir el JSON en un diccionario")
                        return
                    }
                    
                    if let devicesData = json["data"] as? [[String: Any]] {
                        DispatchQueue.main.async {
                            self.renderDevices(devicesData)
                        }
                    } else {
                        print("No se encontró el arreglo 'data' en el JSON")
                    }
                } catch {
                    print("Error al convertir los datos JSON:", error)
                }
            }
        }
        task.resume()
    }

    func renderDevices(_ devicesData: [[String: Any]]) {
        var yOffset = 10
        for deviceInfo in devicesData {
            let deviceView = UIView(frame: CGRect(x: 10, y: yOffset, width: Int(scrDivice.frame.width - 20), height: 100))
            deviceView.layer.cornerRadius = 10
            deviceView.layer.borderWidth = 2
            deviceView.layer.borderColor = UIColor.gray.cgColor
            deviceView.layer.masksToBounds = true
            
            let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 90, height: 90))
            imageView.image = UIImage(named: "carritouuu.png")
            imageView.contentMode = .scaleAspectFit
            
            let typeLabel = UILabel(frame: CGRect(x: 100, y: 5, width: Int(deviceView.frame.width - 105), height: 30))
            typeLabel.text = deviceInfo["type"] as? String ?? "Type not found"
            typeLabel.font = .boldSystemFont(ofSize: 22)
            typeLabel.minimumScaleFactor = 0.5
            typeLabel.adjustsFontSizeToFitWidth = true
            typeLabel.textColor = .white
            
            let modelLabel = UILabel(frame: CGRect(x: 100, y: 37, width: Int(deviceView.frame.width - 105), height: 28))
            modelLabel.text = deviceInfo["model"] as? String ?? "Model not found"
            modelLabel.font = .systemFont(ofSize: 17)
            modelLabel.textColor = .white
            
            let unlinkButton = UIButton(frame: CGRect(x: Int(deviceView.frame.width - 100 - 5), y: 20, width: 70, height: 30))
            unlinkButton.backgroundColor = .red
            unlinkButton.setTitle("Unlink", for: .normal)
            unlinkButton.titleLabel?.textAlignment = .center
            unlinkButton.addTarget(self, action: #selector(unlinkDevice(sender:)), for: .touchUpInside)
            

            deviceView.addSubview(imageView)
            deviceView.addSubview(typeLabel)
            deviceView.addSubview(modelLabel)
            deviceView.addSubview(unlinkButton)
            scrDivice.addSubview(deviceView)
            
            yOffset += 110
        }
        
        scrDivice.contentSize = CGSize(width: 0, height: yOffset)
    }

    @objc func unlinkDevice(sender: UIButton) {
        // Lógica para desvincular el dispositivo
    }

}
