//
//  CameraViewController.swift
//  MyLittleAssistant
//
//  Created by imac on 27/03/24.
//

import UIKit
import MapKit
class CameraViewController: UIViewController {
  

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
        setearMapa()
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
