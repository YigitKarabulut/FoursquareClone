//
//  MapViewController.swift
//  FoursquareClone
//
//  Created by Yigit on 8.09.2022.
//

import UIKit
import MapKit
import Parse
class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    
    @IBOutlet weak var mapKit: MKMapView!
    
    var locationManager = CLLocationManager()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(btnBackClickedd))
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(btnSaveClicked))
        
        
        mapKit.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation))
        gesture.minimumPressDuration = 3
        mapKit.addGestureRecognizer(gesture)
        
        
        
        
    }
    
    @objc func chooseLocation(gesture: UILongPressGestureRecognizer){
        if gesture.state == .began {
            let touchPoint = gesture.location(in: self.mapKit)
            let touchedCoordinate = self.mapKit.convert(touchPoint, toCoordinateFrom: self.mapKit)
            
            PlaceModel.sharedInstance.placeLatitude = String(touchedCoordinate.latitude)
            PlaceModel.sharedInstance.placeLongitude = String(touchedCoordinate.longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinate
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            self.mapKit.addAnnotation(annotation)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.35, longitudeDelta: 0.35)
        let region = MKCoordinateRegion(center: location, span: span)
        mapKit.setRegion(region, animated: true)
    }
    
    
    @objc func btnBackClickedd(){
        self.dismiss(animated: true)
    }
    

    @objc func btnSaveClicked(){
        let placeModel = PlaceModel.sharedInstance
        
        let object = PFObject(className: "Places")
        object["name"] = placeModel.placeName
        object["type"] = placeModel.placeType
        object["atmosphere"] = placeModel.placeAtmosphere
        object["latitude"] = placeModel.placeLatitude
        object["longitude"] = placeModel.placeLongitude
        
        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5) {
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
        }
        object.saveInBackground { success, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error ")
            } else {
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
            }
        }
        
    
    }
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    

}
