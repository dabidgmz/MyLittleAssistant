//
//  CameraViewController.swift
//  MyLittleAssistant
//
//  Created by imac on 27/03/24.
//

import UIKit
import MapKit
import AVKit
import WebKit


class CameraViewController: UIViewController {

    @IBOutlet weak var webcam: UIView!
    
    func highlightButton(_ button: UIButton) {
        let originalBackgroundColor = button.backgroundColor
        button.backgroundColor = .white
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            button.backgroundColor = originalBackgroundColor
        }
    }

    
    let pin = Marcador()
    let userData = UserData.sharedData()
    let coordenadasLugar = (latitud: 25.5315, longitud: -103.3219)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let videoURL = URL(string: "https://cdn.pixabay.com/video/2020/08/27/48420-453832153_large.mp4") else {
            print("La URL del video no es válida")
            return
        }


       fetchDevices()
        let player = AVPlayer(url: videoURL)

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = webcam.bounds
        playerLayer.videoGravity = .resizeAspectFill
        webcam.layer.addSublayer(playerLayer)
        player.play()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
       
    }
    func fetchDevices() {
        let url = URL(string: "http://backend.mylittleasistant.online:8000/api/user/devices")!
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 50)
        request.httpMethod = "GET"
        let token = userData.jwt
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("Making request to URL:", url.absoluteString)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
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
                if httpResponse.statusCode == 200 {
                    print("Request successful. Status code: 200")
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                            print("No se pudo convertir el JSON en un diccionario")
                            return
                        }
                        if let devicesData = json["data"] as? [[String: Any]] {
                            if !devicesData.isEmpty {
                                DispatchQueue.main.async {
                                   // self.performSegue(withIdentifier: "sgLinkDevice", sender: self)
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "sgNoDevices", sender: self)
                                }
                                print("No se encontraron dispositivos")
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "sgNoDevices", sender: self)
                            }
                            print("No se encontró el arreglo 'data' en el JSON")
                        }
                    } catch {
                        print("Error al convertir los datos JSON:", error)
                    }
                } else if httpResponse.statusCode == 404 {
                    print("No se encontraron dispositivos")
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Error", message: "No se encontraron dispositivos.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                } else {
                    print("Error en el request. Status code:", httpResponse.statusCode)
                }
            }
        }
        task.resume()
    }
    //controles para mover Device
    
    @IBAction func Adelante(_ sender: Any) {
    PostControllersDevice(to: "http://controller.mylittleasistant.online/api/mqtt/w")
    }
    
    
    @IBAction func Atras(_ sender: Any) {
    PostControllersDevice(to: "http://controller.mylittleasistant.online/api/mqtt/s")
    }
    
    
    @IBAction func Derecha(_ sender: Any) {
    PostControllersDevice(to: "http://controller.mylittleasistant.online/api/mqtt/d")
    }
    
    @IBAction func Izquierda(_ sender: Any) {
    PostControllersDevice(to: "http://controller.mylittleasistant.online/api/mqtt/a")
    }
    
    
    //Controles de Brazo Mecanico
    
    @IBAction func Subir(_ sender: Any) {
        
        highlightButton(sender as! UIButton)
    }
    
    
    @IBAction func Bajar(_ sender: Any) {
        
        highlightButton(sender as! UIButton)
    }
    
    //Accionadores
    
    @IBAction func Bocina(_ sender: Any) {
    PostControllersDevice(to: "http://controller.mylittleasistant.online/api/mqtt/e")
    }
    
    
    func PostControllersDevice(to url: String) {
        guard let url = URL(string: url) else {
            print("URL inválida")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error en la solicitud:", error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Respuesta inválida")
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let responseData = data {
                    if let responseString = String(data: responseData, encoding: .utf8) {
                        print("Respuesta recibida:", responseString)
                    } else {
                        print("No se pudo convertir la respuesta a String")
                    }
                } else {
                    print("No se recibieron datos en la respuesta")
                }
                print("Solicitud exitosa. Status code: 200")
            } else {
                print("Error en la solicitud. Status code:", httpResponse.statusCode)
            }
        }
        task.resume()
    }
    
    
   
}
