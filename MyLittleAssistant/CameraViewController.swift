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
    let coordenadasLugar = (latitud: 25.5315, longitud: -103.3219)
    override func viewDidLoad() {
        super.viewDidLoad()
        setearMapa()
        reproducirVideo()
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
   
}
