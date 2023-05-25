//
//  MapViewController.swift
//  ContactApp
//
//  Created by user238354 on 3/27/23.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var sgmtMapType: UISegmentedControl!
    var contacts: [Contact] = []
    
    
    var locationManager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func findUser(_ sender: Any) {
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation){
        var span = MKCoordinateSpan()
        span.latitudeDelta = 0.2
        span.longitudeDelta = 0.2
        let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        mapView.setRegion(viewRegion, animated: true)
        
        let mp = MapPoint(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        mp.title = "You"
        mp.subtitle = "Are here"
        mapView.addAnnotation(mp)
    }
    
    override func viewWillAppear(_ animated: Bool) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persitentContainer.viewContext
            let request = NSFetchRequest<NSManagedObject>(entityName: "Contact")
            var fetchedObjects:[NSManagedObject] = []
            do {
                fetchedObjects = try context.fetch(request)
            }catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
            contacts = fetchedObjects as! [Contact]
            self.mapView.removeAnnotations(self.mapView.annotations)
            for contact in contacts {
                let address = "\(contact.strAddress!),\(contact.city!), \(contact.state!)"
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(address) { (placemarks, error) in  self.processAddressResponse(contact, withPlacemarks: placemarks, error: error)}
            }
        }
        private func processAddressResponse(_ contact: Contact, withPlacemarks placemarks: [CLPlacemark]?,
                                            error: Error?){
            if let error = error {
                print("Geocode error: \(error)")
            }
            else{
                var bestMatch: CLLocation?
                if let placemarks = placemarks,placemarks.count > 0 {
                    bestMatch = placemarks.first?.location
                }
                if let coordinate = bestMatch?.coordinate {
                    let mp = MapPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    mp.title = contact.name
                    mp.subtitle = contact.strAddress
                    mapView.addAnnotation(mp)
                }
                else {
                    print("Didn't find anything")
                }
            }
        }
        
        
    @IBAction func mapTypeChanged(_ sender: Any) {
        
        switch sgmtMapType.selectedSegmentIndex {
                case 0:
                    mapView.mapType = .standard
                case 1:
                    mapView.mapType = .hybrid
                    
                case 2:
                    mapView.mapType = .satellite
                default: break
                }
    }
    
    
    
    
    
    
    

}
