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

    @IBOutlet weak var video: WKWebView!
    @IBOutlet weak var mapCiudad: MKMapView!
    @IBOutlet weak var webcam: UIView!
   
    let pin = Marcador()
    let userData = UserData.sharedData()
    let coordenadasLugar = (latitud: 25.5315, longitud: -103.3219)
    override func viewDidLoad() {
        super.viewDidLoad()
        setearMapa()
        reproducirVideo()
        fetchDevices()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        
        reproducirVideo(videoURL: "https://cdn.pixabay.com/video/2020/08/27/48420-453832153_large.mp4")
        video.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            video.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            video.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            video.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            video.heightAnchor.constraint(equalTo: video.widthAnchor, multiplier: 9.0/16.0)
        ])
        setearMapa()
    }
    
    func reproducirVideo(videoURL: String) {
        guard let url = URL(string: videoURL + "?autoplay=0") else {
            return
        }
        let request = URLRequest(url: url)
        video.load(request)
    }
    
    func setearMapa() {
        var region = MKCoordinateRegion()
        mapCiudad.removeAnnotations(mapCiudad.annotations)
        region.center.latitude = coordenadasLugar.latitud
        region.center.longitude = coordenadasLugar.longitud
        region.span.latitudeDelta = 0.05
        region.span.longitudeDelta = 0.05
        mapCiudad.isZoomEnabled = true
        mapCiudad.isScrollEnabled = true
        mapCiudad.mapType = .satellite // si no lo quieres satelital lo quitas
        let pin = MKPointAnnotation()
        pin.coordinate = region.center
        pin.title = "Ubicación"
        pin.subtitle = "Carr. Torreón - Matamoros S/N-Km 10, Ejido el Águila, 27400 Torreón, Coah."
        mapCiudad.setRegion(region, animated: true)
        mapCiudad.addAnnotation(pin)
    }
    func reproducirVideo() {
          
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

}
