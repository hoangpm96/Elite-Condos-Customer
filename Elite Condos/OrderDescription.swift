//
//  OrderDescription.swift
//  Elite Condos
//
//  Created by Khoa on 3/16/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation
import CoreLocation
class OrderDescription{
    var description: String
    var photos: [String]!
    var address: String
    var location: CLLocationDegrees
    
    init(description: String, photos: [String], address: String,location: CLLocationDegrees ) {
        self.description = description
        self.photos = photos
        self.address = address
        self.location = location
    }
}
