//
//  Marcador.swift
//  MyLittleAssistant
//
//  Created by david gomez herrera on 03/04/24.
//

import UIKit
import MapKit

class Marcador: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    override init() {
        coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
}
