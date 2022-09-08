//
//  DetailsViewController.swift
//  FoursquareClone
//
//  Created by Yigit on 8.09.2022.
//

import UIKit
import MapKit
import Parse

class DetailsViewController: UIViewController , MKMapViewDelegate{

    
    @IBOutlet weak var imageDetail: UIImageView!
    
    @IBOutlet weak var lblDetailPlaceName: UILabel!
    
    
    @IBOutlet weak var lblDetailPlaceType: UILabel!
    
    @IBOutlet weak var lblDetailPlaceAtmosphere: UILabel!
    
    @IBOutlet weak var mapKitDetail: MKMapView!
    
    var chosenPlaceId = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDataFromParse()
        mapKitDetail.delegate = self
        
       
    }
        
    

    func getDataFromParse(){
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId).findObjectsInBackground { objects, error in
            if error != nil {
                
            } else {
                if objects != nil {
                    if objects!.count > 0 {
                        let chosenPlaceObject = objects![0]
                        if let placeName = chosenPlaceObject.object(forKey: "name") as? String {
                            self.lblDetailPlaceName.text = "Place name: \(placeName)"
                        }
                        
                        if let placeType = chosenPlaceObject.object(forKey: "type") as? String {
                            self.lblDetailPlaceType.text = "Place type: \(placeType)"
                        }
                        
                        if let placeAtmosphere = chosenPlaceObject.object(forKey: "atmosphere") as? String {
                            self.lblDetailPlaceAtmosphere.text = "Place atmosphere: \(placeAtmosphere)"
                        }
                        
                        if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String {
                            if let placeLatitudeDouble = Double(placeLatitude) {
                                self.chosenLatitude = placeLatitudeDouble
                            }
                        }
                        
                        if let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String {
                            if let placeLongitudeDouble = Double(placeLongitude) {
                                self.chosenLongitude = placeLongitudeDouble
                            }
                        }
                        
                        if let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject {
                            imageData.getDataInBackground { data, error in
                                if error == nil {
                                    if data != nil {
                                        self.imageDetail.image = UIImage(data: data!)
                                    }
                                }
                            }
                        }
                        let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        let region = MKCoordinateRegion(center: location, span: span)
                        self.mapKitDetail.setRegion(region, animated: true)
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = self.lblDetailPlaceName.text
                        annotation.subtitle = self.lblDetailPlaceType.text
                        self.mapKitDetail.addAnnotation(annotation)
                        
                    }
                    
                    
                }
            }
        }
    
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapKitDetail.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if self.chosenLatitude != 0.0 && self.chosenLongitude != 0.0 {
            let requestLocaiton = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocaiton) { placemarks, error in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.lblDetailPlaceName.text
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
        
    }



}
