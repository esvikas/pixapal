//
//  LocationManager.swift
//  Pixapals
//
//  Created by DARI on 2/5/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    typealias afterLocationCompletes = (CLLocationCoordinate2D) -> ()
    
    private let manager: CLLocationManager
    
    private var afterLocationGet: afterLocationCompletes!
    
    
    init(manager: CLLocationManager, afterLocationRetrived: afterLocationCompletes) {
        self.manager = manager
        self.afterLocationGet = afterLocationRetrived
        
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        self.afterLocationGet(newLocation.coordinate)
        manager.stopUpdatingLocation()
    }
    
//    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if case 0...2 = status.rawValue {
//            appDelegate.ShowAlertView("Access Denied", message: "Location access is denied. You can't proceed. Please change location preference to this app from setting.")
//        }
//    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if error.code == CLError.Denied.rawValue {
            appDelegate.ShowAlertView("Access Denied", message: "Location access is denied. You can't proceed. Please change location preference to this app from setting.")
            self.manager.stopUpdatingLocation()
        }
    }
    
    func getLocation(afterLocationGet: afterLocationCompletes){
        //self.afterLocationGet = afterLocationGet
    }
}

enum EitherOr<T1, T2> {
    case Either(T1)
    case Or(T2)
}