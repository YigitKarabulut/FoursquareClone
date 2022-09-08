//
//  AddPlaceViewController.swift
//  FoursquareClone
//
//  Created by Yigit on 7.09.2022.
//

import UIKit

class AddPlaceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
  
    
    
    @IBOutlet weak var txtPlaceName: UITextField!
    
    @IBOutlet weak var txtPlaceType: UITextField!
    
    @IBOutlet weak var txtPlaceAtmosphere: UITextField!
    
    
    @IBOutlet weak var imagePlace: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(btnNextClicked))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(btnBackClicked))
        
        
        imagePlace.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imagePlace.addGestureRecognizer(gesture)
        
        
        
    }
    
    
    @objc func btnBackClicked(){
        self.dismiss(animated: true)
    }
    
    @objc func btnNextClicked(){
        
        if txtPlaceName.text != "" && txtPlaceType.text != "" && txtPlaceAtmosphere.text != "" {
            if let chosenImage = imagePlace.image {
                let placeModel = PlaceModel.sharedInstance
                placeModel.placeName = txtPlaceName.text!
                placeModel.placeType = txtPlaceType.text!
                placeModel.placeAtmosphere = txtPlaceAtmosphere.text!
                placeModel.placeImage = chosenImage
            }
            self.performSegue(withIdentifier: "toMapVC", sender: nil)
        } else {
            self.makeAlert(title: "Error", message: "Place name, type and atmosphere can not be empty!")
        }
    
        
        
    }
    
    @objc func chooseImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePlace.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
        
    }
    
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    
  
    
    

}
