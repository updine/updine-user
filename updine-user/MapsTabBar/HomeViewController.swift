//
//  ViewController.swift
//  verticalScroll
//
//  Created by Yasin Ehsan on 1/25/20.
//  Copyright © 2020 Yasin Ehsan. All rights reserved.
//

import UIKit
import MapKit
import FlyoverKit

class HomeViewController: UIViewController {
    @IBOutlet weak var blackView: UIView!
    var animator: UIViewPropertyAnimator?
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 30000
    var currentCoordinate: CLLocationCoordinate2D?
    
    let markerTitle: String = "Get Directions"
    
    
     func centerViewOnUserLocation() {
              if let location = locationManager.location?.coordinate {
                  let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
                  mapView.setRegion(region, animated: true)
              }
          }
    
    func setupLocationManager() {
             locationManager.delegate = self
             locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
        let pinOne = MKPointAnnotation()
        pinOne.title = markerTitle
        pinOne.coordinate = CLLocationCoordinate2D(latitude: 40.692040, longitude: -73.987590)
        
        
        let pinTwo = MKPointAnnotation()
        pinTwo.title = markerTitle
        pinTwo.coordinate = CLLocationCoordinate2D(latitude: 40.7484, longitude: -73.9857)
        
        let timesSqaureAnnotation = MKPointAnnotation()
               timesSqaureAnnotation.title = markerTitle
               timesSqaureAnnotation.coordinate = CLLocationCoordinate2D(latitude: 40.6602, longitude: -73.9985)
               
               let empireStateAnnotation = MKPointAnnotation()
               empireStateAnnotation.title = markerTitle
               empireStateAnnotation.coordinate = CLLocationCoordinate2D(latitude: 40.7484, longitude: -73.9857)
               
        //HOLY COW DINER
               let brooklynBridge = MKPointAnnotation()
               brooklynBridge.title = markerTitle
               brooklynBridge.coordinate = CLLocationCoordinate2D(latitude: 40.714720, longitude: -73.991130)
               
               let prospectPark = MKPointAnnotation()
               prospectPark.title = markerTitle
               prospectPark.coordinate = CLLocationCoordinate2D(latitude: 40.6602, longitude: -73.9690)
               
               let jersey = MKPointAnnotation()
               jersey.title = markerTitle
               jersey.coordinate = CLLocationCoordinate2D(latitude: 40.7178, longitude: -74.0431)
               
               mapView.addAnnotation(timesSqaureAnnotation)
               mapView.addAnnotation(empireStateAnnotation)
               mapView.addAnnotation(brooklynBridge)
               mapView.addAnnotation(prospectPark)
               mapView.addAnnotation(jersey)
        
        
        
        mapView.addAnnotation(pinOne)
        mapView.addAnnotation(pinTwo)
        
//        mapView.selectAnnotation(pinOne, animated: true)
//        mapView.selectAnnotation(pinTwo, animated: true)
    }
    
    //GPS ROUTE
    func showRoute() {
           let sourceLocation = currentCoordinate ?? CLLocationCoordinate2D(latitude: 40.692040, longitude: -73.9857)
           let destinationLocation = CLLocationCoordinate2D(latitude: 40.714720, longitude: -73.991130)
           
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
    
    func flyKitSetup() {
//        self.mapView.mapType = .hybridFlyover
        
//        self.mapView.mapType = .hybridFlyover
        self.mapView.showsBuildings = true
//        self.mapView.isZoomEnabled = true
        self.mapView.isScrollEnabled = true
        
        let camera = FlyoverCamera(mapView: self.mapView, configuration: FlyoverCamera.Configuration(duration: 5.0, altitude: 20000, pitch: 45.0, headingStep: 40.0))
        camera.start(flyover: FlyoverAwesomePlace.newYork)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(20), execute:{
            camera.stop()
        })
    }
    
    
    
    
    
    
    //MARK BOTTOM VIEW SEGUE START HERE

       func createBottomView() {
           guard let sub = storyboard!.instantiateViewController(withIdentifier: "BottomSheetViewController") as? BottomSheetViewController else { return }
           self.addChild(sub)
           self.view.addSubview(sub.view)
           sub.didMove(toParent: self)
           sub.view.frame = CGRect(x: 0, y: view.frame.maxY, width: view.frame.width, height: view.frame.height)
           sub.minimize(completion: nil)
       }

       func subViewGotPanned(_ percentage: Int) {
           guard let propAnimator = animator else {
               animator = UIViewPropertyAnimator(duration: 3, curve: .linear, animations: {
                   self.blackView.alpha = 1
//                   self.someView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8).concatenating(CGAffineTransform(translationX: 0, y: -20))
               })
               animator?.startAnimation()
               animator?.pauseAnimation()
               return
           }
           propAnimator.fractionComplete = CGFloat(percentage) / 100
       }

       func receiveNotification(_ notification: Notification) {
           guard let percentage = notification.userInfo?["percentage"] as? Int else { return }
           subViewGotPanned(percentage)
       }

    
    //MARK BOTTOM VIEW SEGUE END HERE
    
    
       override func viewDidLoad() {
           super.viewDidLoad()
           createBottomView()
            checkLocationServices()
            mapView.delegate = self
            flyKitSetup()

           let name = NSNotification.Name(rawValue: "BottomViewMoved")
           NotificationCenter.default.addObserver(forName: name, object: nil, queue: nil, using: receiveNotification(_:))
       }


}

extension HomeViewController: CLLocationManagerDelegate {
      
      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
            //Dif between last and first? ...locations.first / .last chk array in given input
          guard let latestLocation = locations.first else { return }
        
            //to make user location in center of mapview chnage the center coord
            //is there a cicumference for the span what user views
            //below span is the exact same as the setreigon above span is like pertange of lat long instead of 10k meters
           let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                 let region = MKCoordinateRegion(center: latestLocation.coordinate, span: span)
        
//          mapView.setRegion(region, animated: true)
        
          //invoke once at launch (most likely)
          if currentCoordinate == nil{
//              centerViewOnUserLocation()
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

extension HomeViewController: MKMapViewDelegate {
    
   
    
    //add pin hover over diner
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            //we dont want to do anything because of this is the blue dot we want only custom pins
            return nil
        }
        else{
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            
            pin.canShowCallout = true
            
            pin.image = UIImage(named: "marker")
            
            
            //the button when tapped goto gps
            pin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return pin
        }
    }
    
    //segue to details vc
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        showRoute() //for destination gps
//         let annView = view.annotation
//
//       let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//       guard let detailVC = storyboard.instantiateViewController(withIdentifier: "DineDetailsViewController") as? DineDetailsViewController else {
//           print("detals vc not founds")
//           return
//       }
//
//
//
//       self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    //color overlay over the geofences
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
         let renderer = MKPolylineRenderer(overlay: overlay)
               renderer.strokeColor = UIColor.green
               renderer.lineWidth = 4.0
               return renderer
    }
}

