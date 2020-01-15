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
      
      //best practices for location permishh settings
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
     
    //JSON DATA of DIner lat long magic here
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
    
    //GPS ROUTE
    func showRoute() {
           let sourceLocation = currentCoordinate ?? CLLocationCoordinate2D(latitude: 40.6742, longitude: -73.8418)
           let destinationLocation = CLLocationCoordinate2D(latitude: 40.7484, longitude: -73.9857)
           
           let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
           let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
           
           let directionRequest = MKDirections.Request()
           directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
           directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
           directionRequest.transportType = .automobile
           
           let directions = MKDirections(request: directionRequest)
           directions.calculate {(response, error) in
               guard let directionResponse = response else {
                   if let error = error{
                       print("There was an error getting directions==\(error.localizedDescription)")
                   }
                   return
               }
               let route = directionResponse.routes[0]
               self.mapView.addOverlay(route.polyline, level: .aboveRoads)
               
               let rect = route.polyline.boundingMapRect
                //below not being called set Region two more
               self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
           }
           
           self.mapView.delegate = self
       }
  }


  extension MapsViewController: CLLocationManagerDelegate {
      
      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
            //Dif between last and first? ...locations.first / .last chk array in given input
          guard let latestLocation = locations.first else { return }
        
            //to make user location in center of mapview chnage the center coord
            //is there a cicumference for the span what user views
           let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                 let region = MKCoordinateRegion(center: latestLocation.coordinate, span: span)
        
          mapView.setRegion(region, animated: true)
        
          //invoke once at launch (most likely)
          if currentCoordinate == nil{
              centerViewOnUserLocation()
              addAnnotations()
          }
          
          currentCoordinate = latestLocation.coordinate
      }
      
      //best practices to check and catch exceptions for location permisshh
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

extension MapsViewController: MKMapViewDelegate {
    //add pin hover over diner
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        else{
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            
            pin.canShowCallout = true
            pin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return pin
        }
    }
    
    //segue to details vc
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        showRoute() for destination gps
       
       let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
       guard let detailVC = storyboard.instantiateViewController(withIdentifier: "DineDetailsViewController") as? DineDetailsViewController else {
           print("detals vc not founds")
           return
       }
       
       
       
       self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //color overlay over the geofences
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
         let renderer = MKPolylineRenderer(overlay: overlay)
               renderer.strokeColor = UIColor.green
               renderer.lineWidth = 4.0
               return renderer
    }
}



