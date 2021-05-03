//
//  Meteorite.swift
//  MeteoritesSwiftUI
//
//  Created by Adam Salih on 28.04.2021.
//

import Foundation
import MapKit

struct Meteorite: Codable, Identifiable {
    static func == (lhs: Meteorite, rhs: Meteorite) -> Bool {
        lhs.id == rhs.id
    }
    
    let name, id: String
    let nametype: String
    let recclass: String
    let mass: String?
    let fall: String
    let year, reclat, reclong: String?
    let geolocation: Geolocation?
    let computedRegionCbhkFwbd, computedRegionNnqa25F4: String?
    
    var locationCoordinate: CLLocationCoordinate2D {
        guard let geolocation = geolocation else {
            return .init(latitude: 0, longitude: 0)
        }
        return .init(latitude: geolocation.coordinates[1], longitude: geolocation.coordinates[0])
    }

    enum CodingKeys: String, CodingKey {
        case name, id, nametype, recclass, mass, fall, year, reclat, reclong, geolocation
        case computedRegionCbhkFwbd = ":@computed_region_cbhk_fwbd"
        case computedRegionNnqa25F4 = ":@computed_region_nnqa_25f4"
    }
}

struct Geolocation: Codable, Hashable {
    let type: String
    let coordinates: [Double]
}
