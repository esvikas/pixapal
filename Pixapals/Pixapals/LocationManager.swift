//
//  LocationManager.swift
//  Pixapals
//
//  Created by DARI on 2/5/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import CoreLocation
import UIKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    typealias CompletionHandler = CLLocationCoordinate2D? -> UIViewController?
    
    private var completionHandler: CompletionHandler!
    
    required init(completionHandler: CompletionHandler) {
        super.init()
        
        self.completionHandler = completionHandler
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        self.completionHandler(newLocation.coordinate)
        manager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if error.code == CLError.Denied.rawValue {
            let vc = self.completionHandler(nil)
            if let vc = vc {
                PixaPalsErrorType.LocationAccessDeniedError.show(vc)
            }
            manager.stopUpdatingLocation()
        }
    }
}