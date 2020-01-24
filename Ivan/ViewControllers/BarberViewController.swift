//
//  BarberViewController.swift
//  Ivan
//
//  Created by Olga Pirogova on 20.01.2020.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class BarberViewController: UIViewController{
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var orderlisttitle: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var adminMind: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearBtn: UIButton!
    
    //date and time variables
    var timer = Timer()
    var dater = Date()
    //Firebase
    var ref: DatabaseReference!
    //tableview class declare!
    var usersDic: [Item] = []
    
    override func viewDidLoad() {
                        
        super.viewDidLoad()
        adminMind.layer.cornerRadius = 5
        clearBtn.layer.cornerRadius = 5
        orderlisttitle.font = UIFont.boldSystemFont(ofSize: 20)
        getCurrentTime()
        dateLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
        dateLabel.textColor = UIColor.green
        timeLabel.textColor = UIColor.systemBlue
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        
        self.ReadUserData()//read data func call
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
               if let value = snapshot.value as? NSDictionary {
                   
                   let status = value["ISENABLED"] as! String
                   ModelData.shared.allow = status
                   let allow = status
                   if allow == "1" {
                    self.adminMind.setTitle("Enable", for: .normal)
                   }else {
                       
                   }
                   
               }
             }) { (error) in
               print(error.localizedDescription)
           }
    }
    private func getCurrentTime() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.currentTime) , userInfo: nil, repeats: true)
    }

    @objc func currentTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        timeLabel.text = formatter.string(from: Date())
    }
    //MARK: -read date from firebase database to tableview
    func ReadUserData() {
        //firebase data reading to realtime
        ref.child("user").observe(.value, with: { (snapshot) in
            
            self.usersDic.removeAll()
           
            if let value = snapshot.value as? NSDictionary {
                
                let temp = value.allValues
                
                for item1 in temp {
                    
                    let item2 = item1 as! NSDictionary
                    
                    let user = item2["userName"] as! String
                    let request = item2["requestTime"] as! String
                    let state = item2["state"] as! String
                    let order = item2["orderNumber"] as! Double
                    let phone = item2["phoneNumber"] as! String
                    let uid = item2["uid"] as! String
                    let ready = item2["ready"] as! String
                    
                    let item3 = Item(username: user, request: request, states: state, order: order, phone: phone, uid: uid, ready: ready)
                    self.usersDic.append(item3)
                    
                }
                
                self.usersDic = self.usersDic.sorted(by: {$0.orderNumber < $1.orderNumber})
                
                self.tableView.reloadData()
                
            }else {
                
                self.tableView.reloadData()
            }
            
           
        })
        
    }
    //MARK:- clear btn click event
    @IBAction func clearBtn(_ sender: Any) {
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
             // Get user value
        if let value = snapshot.value as? NSDictionary {
            
            let status = value["ISENABLED"] as! String
            ModelData.shared.allow = status
            let allow = status
            if allow == "0" {
                //MARK: now is enable hence admin can't clear list
                let alertController = UIAlertController(title: "Caution!", message: ("Now is Enable. Hence you can't clear order list."), preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "Yes", style: .default) { (_) in
                    
                }
                alertController.addAction(confirmAction)
                self.present(alertController, animated: true, completion: nil)
            }else {
                //MARK: all list clear
                let alertController = UIAlertController(title: "Caution!", message: ("Are you sure clear order list?"), preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "Yes", style: .default) { (_) in
                    self.ref.child("user").removeValue()
                    
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
                }
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
      }) { (error) in
        print(error.localizedDescription)
    }
}
    //MARK: -dont mind adding custom user
    @IBAction func toaddVC(_ sender: Any){
        let toaddVC = storyboard?.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        self.navigationController?.pushViewController(toaddVC, animated: true)
    }
    //MARK:- status change along admin mind
    @IBAction func statusChange(_ sender: Any) {
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
                 // Get user value
            if let value = snapshot.value as? NSDictionary {
                
                let status = value["ISENABLED"] as! String
                ModelData.shared.allow = status
                let allow = status
                if allow == "0" {
                    //MARK: status change to disable
                 self.ref.child("ISENABLED").setValue("1")
                 self.adminMind.setTitle("Enable", for: .normal)
                }else if allow == "1" {
                    //MARK: status change to enable
                 self.ref.child("ISENABLED").setValue("0")
                 self.adminMind.setTitle("Disable", for: .normal)
                }
            }
         }) { (error) in
           print(error.localizedDescription)
       }
    }
    //MARK:- now barber stauts and notification to next user
    @IBAction func StatusBtnFuc(_ sender: Any) {
        
        guard let cell = (sender as AnyObject).superview?.superview as? UserListTableViewCell else {
            return // or fatalError() or whatever
        }
        
        if let indexpath = self.tableView.indexPath(for: cell) {
            if indexpath.row < usersDic.count-1 {
                let uidstring = self.usersDic[indexpath.row].uid!
                
                let nextuidstring = self.usersDic[indexpath.row+1].uid!
                if self.usersDic[indexpath.row].state == "REQUESTED" {
                    self.ref.child("user").child(uidstring).updateChildValues(["state": "STARTED"])
                    self.ref.child("user").child(nextuidstring).updateChildValues(["ready": "true"])
                }
                if self.usersDic[indexpath.row].state == "STARTED" {
                    self.ref.child("user").child(uidstring).updateChildValues(["state": "COMPLETED"])
                }
            }else {
                let uidstring = self.usersDic[indexpath.row].uid!
                
                if self.usersDic[indexpath.row].state == "REQUESTED" {
                    self.ref.child("user").child(uidstring).updateChildValues(["state": "STARTED"])
                }
                if self.usersDic[indexpath.row].state == "STARTED" {
                    self.ref.child("user").child(uidstring).updateChildValues(["state": "COMPLETED"])
                }
            }
            
            

        }
        
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
//MARK:- tableview controller extension
extension BarberViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserList", for: indexPath) as! UserListTableViewCell
        
        cell.listname.text = self.usersDic[indexPath.row].userName!
        cell.bookingTime.text = self.usersDic[indexPath.row].requestTime!
        cell.statusBtnLabel.setTitle(self.usersDic[indexPath.row].state!, for: .normal)
        if self.usersDic[indexPath.row].state == "REQUESTED" {
            cell.statusBtnLabel.setTitleColor(UIColor.yellow, for: .normal)
        }else if self.usersDic[indexPath.row].state == "STARTED" {
            cell.statusBtnLabel.setTitleColor(UIColor.red, for: .normal)
        }else if self.usersDic[indexPath.row].state == "COMPLETED" {
            cell.statusBtnLabel.setTitleColor(UIColor.systemBlue, for: .normal)
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let alertController = UIAlertController(title: "User Infomation", message: self.usersDic[indexPath.row].phoneNumber, preferredStyle: .actionSheet)
        
        //dialing to user by admin mind
        let dialAction = UIAlertAction(title: "Call", style: .default) { (_) in
            self.makePhoneCall(phoneNumber: self.usersDic[indexPath.row].phoneNumber)
        }
        //user remove from list by admin
        let deleteAction = UIAlertAction(title: "Remove", style: .default) { (_) in
            
            let userUID = self.usersDic[indexPath.row].uid
            self.ref.child("user").child(userUID!).removeValue()
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addAction(dialAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    func makePhoneCall(phoneNumber: String) {
        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {
            let alert = UIAlertController(title: ("Call " + phoneNumber + "?"), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                UIApplication.shared.openURL(phoneURL as URL)
            }))
      
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}

