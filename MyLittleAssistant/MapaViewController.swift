//
//  MapaViewController.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 08/04/24.
//

import UIKit
import MapKit
class MapaViewController: UIViewController {
    
    
    @IBOutlet weak var mapCiudad: MKMapView!
    let pin = Marcador()
    let userData = UserData.sharedData()
    let coordenadasLugar = (latitud: 25.5315, longitud: -103.3219)
    override func viewDidLoad() {
        super.viewDidLoad()
        setearMapa()
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
    
    func setearMapa() {
        var region = MKCoordinateRegion()
        mapCiudad.removeAnnotations(mapCiudad.annotations)
        region.center.latitude = coordenadasLugar.latitud
        region.center.longitude = coordenadasLugar.longitud
        region.span.latitudeDelta = 0.03
        region.span.longitudeDelta = 0.03
        mapCiudad.isZoomEnabled = true
        mapCiudad.isScrollEnabled = true
        mapCiudad.mapType = .satelliteFlyover
        let pin = MKPointAnnotation()
        pin.coordinate = region.center
        pin.title = "Carrito"
        pin.subtitle = "Carr. Torreón - Matamoros S/N-Km 10, Ejido el Águila, 27400 Torreón, Coah."
        mapCiudad.setRegion(region, animated: true)
        mapCiudad.addAnnotation(pin)
    }

}
