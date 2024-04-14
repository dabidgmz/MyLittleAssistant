//
//  MapaViewController.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 08/04/24.
//

import UIKit
import MapKit
class MapaViewController: UIViewController {
    //.satelliteFlyover
    
    @IBOutlet weak var mapCiudad: MKMapView!
    let userData = UserData.sharedData()
    let marcador = Marcador()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapaGet()
        aplicarFondoGradiente()
        startPolling()
    }
    
    func MapaGet() {
        self.userData.load()
        let token = self.userData.jwt
        guard let deviceCode = Device.loadDeviceCode() else {
            print("Código de dispositivo no encontrado")
            return
        }
        print("Código de dispositivo enviado en la solicitud:", deviceCode)
        let urlString = "http://backend.mylittleasistant.online:8000/api/gps/lastone/\(deviceCode)"
        guard let url = URL(string: urlString) else {
            print("URL inválida")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Respuesta inválida")
                return
            }
            if let error = error {
                print("Error en la solicitud:", error)
                return
            }
            switch httpResponse.statusCode {
            case 200:
                guard let data = data else {
                    print("No se recibió data en la respuesta")
                    return
                }
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        print("No se pudo convertir el JSON en un diccionario")
                        return
                    }
                    //print("JSON recibido:", json)
                    if let dataArray = json["data"] as? [[String: Any]], let firstData = dataArray.first, let valor = firstData["Valor"] as? String {
                        let coordenadas = valor.components(separatedBy: ", ")
                        if coordenadas.count == 2, let latitud = Double(coordenadas[0]), let longitud = Double(coordenadas[1]) {
                            DispatchQueue.main.async {
                                self.agregarMarcador(latitud: latitud, longitud: longitud)
                                self.setearMapa(latitud: latitud, longitud: longitud)
                            }
                        } else {
                            print("No se pudo parsear el valor de las coordenadas")
                        }
                    } else {
                        print("No se encontró el valor de las coordenadas en la respuesta")
                    }
                } catch {
                    print("Error al convertir los datos en JSON:", error)
                }
            default:
                print("Error en la solicitud. Código de estado:", httpResponse.statusCode)
            }
        }
        task.resume()
    }
    
    func agregarMarcador(latitud: Double, longitud: Double) {
           marcador.coordinate = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
           marcador.title = "Ubicación actual"
           mapCiudad.addAnnotation(marcador)
           setearMapa(latitud: latitud, longitud: longitud)
       }

       func setearMapa(latitud: Double, longitud: Double) {
           let region = MKCoordinateRegion(
               center: CLLocationCoordinate2D(latitude: latitud, longitude: longitud),
               span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
           )
           mapCiudad.setRegion(region, animated: true)
           mapCiudad.mapType = .satelliteFlyover
       }

    func aplicarFondoGradiente() {
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

    func startPolling() {
            timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
                self?.MapaGet()
            }
        MapaGet()
    }
}
