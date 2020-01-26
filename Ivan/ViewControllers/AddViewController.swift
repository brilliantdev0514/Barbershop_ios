//
//  AddViewController.swift
//  Ivan
//
//  Created by Olga Pirogova on 20.01.2020.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class AddViewController: UIViewController {
    //MARK:- variable declare!
    var timer = Timer()
    var dater = Date()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var addname: UITextField!
    @IBOutlet weak var addphone: UITextField!
    //firebse database declare
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBtn.layer.cornerRadius = 5
        addname.layer.cornerRadius = 15
        addphone.layer.cornerRadius = 15
        configureKeyboardDismissOnTap()
        getCurrentTime()
        dateLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
        dateLabel.textColor = UIColor.green
        timeLabel.textColor = UIColor.systemBlue
        ref = Database.database().reference()
        
    }
    private func getCurrentTime() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.currentTime) , userInfo: nil, repeats: true)
    }

    @objc func currentTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        timeLabel.text = formatter.string(from: Date())
    }
    //MARK:- user add via admin to firebase database
    @IBAction func addsuccess(_ sender: Any) {
        if addname.text == "" || addphone.text == "" {
            self.Toast(Title: "Notice.", Text: "Please again check your input.", delay: 2)
        }else{
            let name = addname.text
            let phone = addphone.text
            let timeInterval = NSDate().timeIntervalSince1970
            let uuid = UUID().uuidString;
            self.ref.child("Clients").child(uuid).setValue(["userName":name, "orderNumber": timeInterval, "requestTime": timeLabel.text, "phoneNumber":phone, "uid": uuid, "state": "REQUESTED", "ready": "false"])
            //custom user add success and go to BarberViewController
            self.navigationController?.popViewController(animated: true)
                   
        }
       
    }
    //MARK:- back to BarberViewController
    @IBAction func gotoBarber(_ sender: Any) {
        let back = storyboard?.instantiateViewController(withIdentifier: "BarberViewController") as! BarberViewController
        self.navigationController?.pushViewController(back, animated: true)
    }
    //MARK:- toast func
    func Toast(Title:String ,Text:String, delay:Int) -> Void {
        let alert = UIAlertController(title: Title, message: Text, preferredStyle: .alert)
        self.present(alert, animated: true)
        let deadlineTime = DispatchTime.now() + .seconds(delay)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            alert.dismiss(animated: true, completion: nil)
        })
    }
    
}
