//
//  MapViewController.swift
//  updine-user
//
//  Created by Yasin Ehsan on 1/14/20.
//  Copyright © 2020 Yasin Ehsan. All rights reserved.
//

import UIKit
import MapKit

class MapsViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 300
    var currentCoordinate: CLLocationCoordinate2D?
    
    
  override func viewDidLoad() {
          super.viewDidLoad()
          checkLocationServices()
      }
      
      
      func setupLocationManager() {
          locationManager.delegate = self
          locationManager.desiredAccuracy = kCLLocationAccuracyBest
      }
      
      
      func centerViewOnUserLocation() {
          if let location = locationManager.location?.coordinate {
              let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
              mapView.setRegion(region, animated: true)
          }
      }
      
      
      func checkLocationServices() {
          if CLLocationManager.locationServicesEnabled() {
              setupLocationManager()
              checkLocationAuthorization()
          } else {
              // Show alert letting the user know they have to turn this on.
          }
      }
      
      
      func checkLocationAuthorization() {
          switch CLLocationManager.authorizationStatus() {
          case .authorizedWhenInUse:
              mapView.showsUserLocation = true
              centerViewOnUserLocation()
              locationManager.startUpdatingLocation()
              break
          case .denied:
              // Show alert instructing them how to turn on permissions
              break
          case .notDetermined:
              locationManager.requestWhenInUseAuthorization()
          case .restricted:
              // Show an alert letting them know what's up
              break
          case .authorizedAlways:
              break
          @unknown default:
            print("fatal erroe unkown in case chk location")
        }
      }
    
     func zoomIn(_ coordinate: CLLocationCoordinate2D){
         let zoomRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
         mapView.setRegion(zoomRegion, animated: true)
     }
     
     func addAnnotations(){
         let timesSqaureAnnotation = MKPointAnnotation()
         timesSqaureAnnotation.title = "9/11 Day of Service"
         timesSqaureAnnotation.coordinate = CLLocationCoordinate2D(latitude: 40.6602, longitude: -73.9985)
         
         let empireStateAnnotation = MKPointAnnotation()
         empireStateAnnotation.title = "Hurricane Dorian Clothing Drive"
         empireStateAnnotation.coordinate = CLLocationCoordinate2D(latitude: 40.7484, longitude: -73.9857)
         
         let brooklynBridge = MKPointAnnotation()
         brooklynBridge.title = "Food Pantry Delivery"
         brooklynBridge.coordinate = CLLocationCoordinate2D(latitude: 40.7061, longitude: -73.9969)
         
         let prospectPark = MKPointAnnotation()
         prospectPark.title = "Feed The Homeless Soup Kitchen"
         prospectPark.coordinate = CLLocationCoordinate2D(latitude: 40.6602, longitude: -73.9690)
         
         let jersey = MKPointAnnotation()
         jersey.title = "It's My Park"
         jersey.coordinate = CLLocationCoordinate2D(latitude: 40.7178, longitude: -74.0431)
         
         mapView.addAnnotation(timesSqaureAnnotation)
         mapView.addAnnotation(empireStateAnnotation)
         mapView.addAnnotation(brooklynBridge)
         mapView.addAnnotation(prospectPark)
         mapView.addAnnotation(jersey)
     }
  }


  extension MapsViewController: CLLocationManagerDelegate {
      
      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
            //Dif between last and first? ...locations.first / .last chk array in given input
          guard let latestLocation = locations.first else { return }
        
            //to make user location in center of mapview chnage the center coord
           let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                 let region = MKCoordinateRegion(center: latestLocation.coordinate, span: span)
        
          mapView.setRegion(region, animated: true)
        
          if currentCoordinate == nil{
              zoomIn(latestLocation.coordinate)
              addAnnotations()
          }
          
          currentCoordinate = latestLocation.coordinate
      }
      
      
      func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
          checkLocationAuthorization()
      }
    
    //GEOFENCES
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    print("entrer")
    }
     
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    print("left")
    }
    
    /**Some where above
        let geoFenceRegion: CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(43.61871, -116.214607), radius: 100, identifier: "boise")
         
        locationManager.startMonitoring(for: geoFenceRegion)
    
     */
    
    
  }



