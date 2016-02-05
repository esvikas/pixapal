//
//  LocationManager.swift
//  Pixapals
//
//  Created by DARI on 2/5/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    private var location: CLLocation!
    
    private var authorised: Bool!
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        self.location = newLocation
        
        manager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if case 0...2 = status.rawValue {
            authorised = false
        } else {
            authorised = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if error.code == CLError.Denied.rawValue {
            self.authorised = false
            self.manager.stopUpdatingLocation()
        }
    }
    
    func getLocation() -> EitherOr <(Double, Double), Bool> {
        if let authorised = authorised  where authorised == true {
            return EitherOr.Either(self.location.coordinate.latitude, self.location.coordinate.longitude)
        } else {
            appDelegate.ShowAlertView("Location Not Enabled", message: "Please change location preference of app from settings.")
            return EitherOr.Or(self.authorised)
        }
    }
}

enum EitherOr<T1, T2> {
    case Either(T1)
    case Or(T2)
}