//
//  ViewController.swift
//  Ivan
//
//  Created by Olga Pirogova on 20.01.2020.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SwiftToast
import UserNotifications

class ViewController: UIViewController {

    //MARK: variable declare!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueBtn.layer.cornerRadius = 5
        name.layer.cornerRadius = 15
        phone.layer.cornerRadius = 15
        configureKeyboardDismissOnTap()
        showAlertDialog() // admin check key func
        
        
    }
    //MARK:-to getting verify code
    @IBAction func toVerify(_ sender: Any) {
        //MARK: non character check and length limit!
        if name.text == "" || phone.text == ""{
            let alert = UIAlertController(title: "Warning!", message: "You must entry correct info.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: nil))

            self.present(alert, animated: true)
        }else{
            //MARK:- send verify code to users phone
            guard let phoneNum = phone.text else {
                return
            }
            let defaults = UserDefaults.standard
            
            defaults.set(phoneNum, forKey: "phonenum")
            
            
            let alertController = UIAlertController(title: "Phone Number", message: "Is this your phone number? \n \(phone.text!)", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
                        PhoneAuthProvider.provider().verifyPhoneNumber(("+1"+phoneNum), uiDelegate: nil) { (verificationID, error) in
                            ModelData.shared.phoneNumber = phoneNum
                            
                            if error != nil {
                            //MARK: wrong phone number action
                            self.Toast(Title: "Warning!", Text: "You can't verify via this number. Please again input correctly.", delay: 2)
                            }
                            //MARK: phone number is right
                           else {
                                let defaults = UserDefaults.standard
                                defaults.set(verificationID, forKey: "authID")
                                //MARK: go to verify ViewController
                                ModelData.shared.userName = self.name.text!
                                let toverifiVC = self.storyboard?.instantiateViewController(withIdentifier: "VerifyViewController") as! VerifyViewController
                            self.navigationController?.pushViewController(toverifiVC, animated: true)
                                
                            }
                        }
                    }
                    
                    let cancel = UIAlertAction(title: "No", style: .cancel, handler: nil)
                    
                    alertController.addAction(action)
                    alertController.addAction(cancel)
                    
                    self.present(alertController, animated: true, completion: nil)
            
            
        }
        
    }
    //MARK:- go to admin channel via admin key : 2580
    private func showAlertDialog(){
        let alertController = UIAlertController(title: "Are you admin?", message: "Enter admin key", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting the input values from user
            let key = alertController.textFields?[0].text
          
            if key == "2580" {
                let tobarberVC = self.storyboard?.instantiateViewController(withIdentifier: "BarberViewController") as! BarberViewController
                self.navigationController?.pushViewController(tobarberVC, animated: true)
            }else {
                self.showAlertDialog()
            }
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            if Auth.auth().currentUser != nil{
                let todirect = self.storyboard?.instantiateViewController(withIdentifier: "ClientViewController") as! ClientViewController
                self.navigationController?.pushViewController(todirect, animated: true)
            }else{
                return
            }
        }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter key"
            textField.keyboardType = UIKeyboardType.phonePad
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    //Show Alert View Controller
    func showAlert(_ title: String, message: String) {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alertView.view.tintColor = UIColor.init()
        
        self.present(alertView, animated: true, completion: nil)
    }
    //show Toast func
    func Toast(Title:String ,Text:String, delay:Int) -> Void {
        let alert = UIAlertController(title: Title, message: Text, preferredStyle: .alert)
        self.present(alert, animated: true)
        let deadlineTime = DispatchTime.now() + .seconds(delay)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            alert.dismiss(animated: true, completion: nil)
        })
    }
    
}

