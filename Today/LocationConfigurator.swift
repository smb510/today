//
//  LocationConfigurator.swift
//  Today
//
//  Created by Scottie Biddle on 10/22/17.
//  Copyright © 2017 Scottie Biddle. All rights reserved.
//

import Foundation
import CoreLocation

class LocationConfigurator : NSObject, CLLocationManagerDelegate {
  
  let locationManager = CLLocationManager()
  @objc var location: CLLocation?
  
  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if (status == .authorizedWhenInUse) {
      locationManager.requestLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let position = locations[0].coordinate
    NSLog("You are at \(position.latitude) and  \(position.longitude)")
    location = locations[0]
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    location = nil
    NSLog("Error getting location: \(error.localizedDescription)")
  }
  
  
}
