//
//  VerifyViewController.swift
//  Ivan
//
//  Created by Olga Pirogova on 20.01.2020.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import UserNotifications

class VerifyViewController: UIViewController {

    @IBOutlet weak var verifycode: UITextField!
    @IBOutlet weak var verifyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verifyBtn.layer.cornerRadius = 5
        verifycode.layer.cornerRadius = 15
        configureKeyboardDismissOnTap()
        // Do any additional setup after loading the view.
        
    }
    //MARK: -go to home screen
    @IBAction func toHome(_ sender: Any) {
        let tohome = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(tohome, animated: true)
    }
    //MARK: -check verify code and go to ClientViewController
    @IBAction func tobarber(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authID")!, verificationCode: verifycode.text!)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error != nil {
            // ...
            let alertController = UIAlertController(title: "Warning!", message: ("Your verify code is wrong!."+"Are you sure re-entry phone number?"), preferredStyle: .alert)
            
            //the confirm action taking the inputs
            let confirmAction = UIAlertAction(title: "Yes", style: .default) { (_) in
                
                    let toHome = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    self.navigationController?.pushViewController(toHome, animated: true)
                
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
                //MARK: app close when click cancel buttton
                UIControl().sendAction(#selector(NSXPCConnection.suspend),
                to: UIApplication.shared, for: nil)
            }
            
            
            //adding the action to dialogbox
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            //finally presenting the dialog box
            self.present(alertController, animated: true, completion: nil)
            return
          }
          // User is signed in
          // go to client channel
            let toClient = self.storyboard?.instantiateViewController(withIdentifier: "ClientViewController") as! ClientViewController
            self.navigationController?.pushViewController(toClient, animated: true)
        }
    }
   
}
