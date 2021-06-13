//
//  MKPointAnnotation-ObservableObject.swift
//  BucketList
//
//  Created by Akifumi Fujita on 2021/06/12.
//

import MapKit

extension MKPointAnnotation: ObservableObject {
    public var wrappedTitle: String {
        get {
            title ?? "Unknown value"
        }
        set {
            title = newValue
        }
    }
    
    public var wrappedSubtitle: String {
        get {
            subtitle ?? "Unknown value"
        }
        set {
            subtitle = newValue
        }
    }
}
