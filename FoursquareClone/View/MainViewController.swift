//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Yigit on 7.09.2022.
//

import UIKit
import Parse
class MainViewController: UIViewController {

    
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        -- ADD DATA --
//        let parseObject = PFObject(className: "Fruits")
//        parseObject["name"] = "Apple"
//        parseObject["calories"] = 100
//        parseObject.saveInBackground { success, error in
//            if error != nil {
//                print(error?.localizedDescription)
//            } else {
//                print("success")
//            }
//        }
        
        
        
//        -- GET DATA --
//        let query = PFQuery(className: "Fruits")
//        query.findObjectsInBackground { object, error in
//            if error != nil {
//                print(error?.localizedDescription)
//            } else {
//                print(object!)
//            }
//        }
        
        
       
       
        
        
    }
    
    
    @IBAction func btnSignInClicked(_ sender: Any) {
        
        if txtUsername.text != "" && txtPassword.text != "" {
            
            PFUser.logInWithUsername(inBackground: txtUsername.text!, password: txtPassword.text!) { user, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
        } else {
            self.makeAlert(title: "Error", message: "Username and password can not be empty!")
        }
        
    }
    

    @IBAction func btnSignUpClicked(_ sender: Any) {
        
        if txtUsername.text != "" && txtPassword.text != "" {
            let user = PFUser()
            user.username = txtUsername.text!
            user.password = txtPassword.text!
            user.signUpInBackground { success, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Sign up error")
                } else {
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        } else {
            makeAlert(title: "Error", message: "Username and password can not be empty!")
        }
        
        
    }
    
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}

