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
        mapCiudad.mapType = .satellite
        let pin = MKPointAnnotation()
        pin.coordinate = region.center
        pin.title = "Ubicación"
        pin.subtitle = "Carr. Torreón - Matamoros S/N-Km 10, Ejido el Águila, 27400 Torreón, Coah."
        mapCiudad.setRegion(region, animated: true)
        mapCiudad.addAnnotation(pin)
    }

}
