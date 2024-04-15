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
/*
  se creo variables para asignar que era lo maximo que se podia ampliar la resolucion
  se crearon metodos para sobrescirbir como funcionaba el reproductor de video y su ajuste de resolucion
 se comneto el codigo principal en caso de que se quiera regresar a su funcionalidad
 si gustas eliminar los metodos viewWillAppear y viewWillLayoutSubviews es de tu gusto fue la unica solucion que vi para que la resolucion se ajustara
 */

class CameraViewController: UIViewController {

    @IBOutlet weak var webcam: UIView!
    
    func highlightButton(_ button: UIButton) {
        let originalBackgroundColor = button.backgroundColor
        button.backgroundColor = .white
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            button.backgroundColor = originalBackgroundColor
        }
    }


    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    let maxPlayerLayerWidth: CGFloat = 500
    let pin = Marcador()
    let Token = AuthController.sharedData()
    let userData = UserData.sharedData()
    let coordenadasLugar = (latitud: 25.5315, longitud: -103.3219)
    override func viewDidLoad() {
        super.viewDidLoad()
       /* guard let videoURL = URL(string: "https://cdn.pixabay.com/video/2020/08/27/48420-453832153_large.mp4") else {
            print("La URL del video no es válida")
            return
        }
        */
        
        fetchDevices()
        /*player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        webcam.layer.addSublayer(playerLayer!)*/
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          
          guard let videoURL = URL(string: "https://cdn.pixabay.com/video/2020/08/27/48420-453832153_large.mp4") else {
              print("La URL del video no es válida")
              return
          }
          player = AVPlayer(url: videoURL)
          playerLayer = AVPlayerLayer(player: player)
          playerLayer?.videoGravity = .resizeAspectFill
          webcam.layer.addSublayer(playerLayer!)
          
          player?.play()
      }
    
    
    override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            guard let playerLayer = playerLayer else { return }
            var playerLayerWidth = webcam.bounds.width
            if playerLayerWidth > maxPlayerLayerWidth {
                playerLayerWidth = maxPlayerLayerWidth
            }
            playerLayer.frame = CGRect(x: 0, y: 0, width: playerLayerWidth, height: webcam.bounds.height)
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
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Respuesta inválida")
                return
            }
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
                                //
                            }
                        } else {
                            print("No se encontraron dispositivos")
                        }
                    } else {
                        print("No se encontró el arreglo 'data' en el JSON")
                    }
                } catch {
                    print("Error al convertir los datos JSON:", error)
                }
            } else if httpResponse.statusCode == 404 {
                print("No se encontraron dispositivos")
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Error", message: "No se encontraron dispositivos.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                        self.performSegue(withIdentifier: "sgNoDevices", sender: self)
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            } else {
                print("Error en el request. Status code:", httpResponse.statusCode)
            }
        }
        task.resume()
    }
    
    //controles para mover Device
    
    @IBAction func Adelante(_ sender: Any) {
    PostControllersDevice(to: "http://controller.mylittleasistant.online/api/mqtt/w")
        highlightButton(sender as! UIButton)
    }
    
    
    @IBAction func Atras(_ sender: Any) {
    PostControllersDevice(to: "http://controller.mylittleasistant.online/api/mqtt/s")
        highlightButton(sender as! UIButton)
    }
    
    
    @IBAction func Derecha(_ sender: Any) {
    PostControllersDevice(to: "http://controller.mylittleasistant.online/api/mqtt/d")
        highlightButton(sender as! UIButton)
    }
    
    @IBAction func Izquierda(_ sender: Any) {
    PostControllersDevice(to: "http://controller.mylittleasistant.online/api/mqtt/a")
        highlightButton(sender as! UIButton)
    }
    
    
    //Controles de Brazo Mecanico
    
    @IBAction func Subir(_ sender: Any) {
        PostControllersDevice(to: "http://controller.mylittleasistant.online/api/mqtt/u")
        highlightButton(sender as! UIButton)
    }
    
    
    @IBAction func Bajar(_ sender: Any) {
        PostControllersDevice(to: "http://controller.mylittleasistant.online/api/mqtt/j")
        highlightButton(sender as! UIButton)
    }
    
    //Accionadores
    
    @IBAction func Bocina(_ sender: Any) {
    PostControllersDevice(to: "http://controller.mylittleasistant.online/api/mqtt/e")
        highlightButton(sender as! UIButton)
    }
    
    
    
    @IBAction func Luces(_ sender: Any) {
        if let switchControl = sender as? UISwitch {
               //print("Tipo de sender:", type(of: switchControl))
               if switchControl.isOn {
                   PostControllersDevice(to: "http://controller.mylittleasistant.online/api/mqtt/1")
               } else {
                   PostControllersDevice(to: "http://controller.mylittleasistant.online/api/mqtt/2")
               }
           }
    }
    
    
    //Controles Camara
    
    @IBAction func IzqCamara(_ sender: Any) {
        PostControllersDevice(to: "http://controller.mylittleasistant.online/api/mqtt/i")
            highlightButton(sender as! UIButton)

    }
    
    

    @IBAction func CenCamara(_ sender: Any) {
        PostControllersDevice(to: "http://controller.mylittleasistant.online/api/mqtt/o")
            highlightButton(sender as! UIButton)

    }
    
    
    @IBAction func DerCamara(_ sender: Any) {
        PostControllersDevice(to: "http://controller.mylittleasistant.online/api/mqtt/i")
            highlightButton(sender as! UIButton)

    }
    
    
    func PostControllersDevice(to url: String) {
        guard let url = URL(string: url) else {
            print("URL inválida")
            return
        }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        let authToken = Token.Auth
        print("Valor de Auth:", authToken)
        request.addValue(authToken, forHTTPHeaderField: "Auth")
        
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
                if let responseData = data {
                    if let responseString = String(data: responseData, encoding: .utf8) {
                        print("Respuesta de error:", responseString)
                    } else {
                        print("No se pudo convertir la respuesta de error a String")
                    }
                } else {
                    print("No se recibieron datos en la respuesta de error")
                }
            }
        }
        
        task.resume()
    }

}
