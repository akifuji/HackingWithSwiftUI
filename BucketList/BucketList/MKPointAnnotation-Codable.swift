//
//  MKPointAnnotation-Codable.swift
//  BucketList
//
//  Created by Akifumi Fujita on 2021/06/13.
//

import MapKit

class CodableMKPointAnnotation: MKPointAnnotation, Codable {
    enum CodingKeys: CodingKey {
        case title, subtitle, latitude, longitude
    }
    
    override init() {
        super.init()
    }
    
    public required init(from decoder: Decoder) throws {
        super.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: CodingKeys.title)
        subtitle = try container.decode(String.self, forKey: CodingKeys.subtitle)
        
        let latitude = try container.decode(CLLocationDegrees.self, forKey: CodingKeys.latitude)
        let longitude = try container.decode(CLLocationDegrees.self, forKey: CodingKeys.longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: CodingKeys.title)
        try container.encode(subtitle, forKey: CodingKeys.subtitle)
        try container.encode(coordinate.latitude, forKey: CodingKeys.latitude)
        try container.encode(coordinate.longitude, forKey: CodingKeys.longitude)
    }
}
