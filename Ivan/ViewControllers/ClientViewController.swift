//
//  ClientViewController.swift
//  Ivan
//
//  Created by Olga Pirogova on 20.01.2020.
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

class ClientViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var servicenotice: UILabel!
    @IBOutlet weak var userordertitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bookBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    var timer = Timer()
    var dater = Date()
    //firebase databse declare!
    var ref: DatabaseReference!
    //tableview class declare!
    var usersDic: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookBtn.layer.cornerRadius = 5
        cancelBtn.layer.cornerRadius = 5
        
        //MARK:- notification call
        let debitOverdraftNotifCategory = UNNotificationCategory(identifier: "debitOverdraftNotification", actions: [], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([debitOverdraftNotifCategory])

        registerLocal()
        
        
        //MARK: font control
        servicenotice.font = UIFont.boldSystemFont(ofSize: 20)
        userordertitle.font = UIFont.boldSystemFont(ofSize: 20)
        // Do any additional setup after loading the view.
        getCurrentTime()
        dateLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
        dateLabel.textColor = UIColor.green
        timeLabel.textColor = UIColor.systemBlue
        ref = Database.database().reference()
        self.tableView.reloadData()
        self.ReadUserData()//read data func call
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
        
        ref.child("Clients").observe(.value, with: { (snapshot) in
            
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
    //MARK: -booking proposal
    @IBAction func onBookBtn(_ sender: Any) {
        //status checking
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
            if let value = snapshot.value as? NSDictionary{
                let status = value["isEnabled"] as! String
                let allow = status
                if allow == "0" {
                    //booking and save to database
                    
                    let timestamp = NSDate().timeIntervalSince1970
                    let userID = Auth.auth().currentUser!.uid
                    let username = ModelData.shared.userName
                    let phone = ModelData.shared.phoneNumber
                    self.ref.child("Clients").child(userID).setValue(["userName":username, "orderNumber": timestamp, "requestTime": self.timeLabel.text!, "phoneNumber":phone, "uid":userID, "state": "REQUESTED", "ready": "false"])
                }else {
                    //booking cancel
                    let alertController = UIAlertController(title: "Caution!", message: ("You can't booking now"), preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "Yes", style: .default) { (_) in
                        
                    }
                    alertController.addAction(confirmAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
          }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    //MARK:- booking cancellation
    @IBAction func cancelBtn(_ sender: Any) {
        let alertController = UIAlertController(title: "Caution!", message: ("Are you sure cancellation?"), preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            let userID = Auth.auth().currentUser!.uid
            self.ref.child("Clients").child(userID).removeValue()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
//MARK:- tableview controller
extension ClientViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientList", for: indexPath) as! ClientTableViewCell
        
        cell.listname.text = self.usersDic[indexPath.row].userName!
        cell.bookingTime.text = self.usersDic[indexPath.row].requestTime!
        cell.statusBtnLabel.setTitle(self.usersDic[indexPath.row].state!, for: .normal)
        cell.layer.cornerRadius = 8
        //border color setting
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.gray.cgColor
        //owner booking status
        let userID = Auth.auth().currentUser!.uid
        if usersDic[indexPath.row].uid == userID {
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.red.cgColor
        }
        //status change
        if self.usersDic[indexPath.row].state == "REQUESTED" {
            cell.statusBtnLabel.setTitleColor(UIColor.yellow, for: .normal)
        }
        if self.usersDic[indexPath.row].state == "STARTED" {
            cell.statusBtnLabel.setTitleColor(UIColor.red, for: .normal)
        }
        if self.usersDic[indexPath.row].state == "COMPLETED" {
            cell.statusBtnLabel.setTitleColor(UIColor.systemBlue, for: .normal)
        }
        if self.usersDic[indexPath.row].state == "REQUESTED" || self.usersDic[indexPath.row].ready == "true" {
            scheduleLocal()
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("tableView cell selected")
    }
    //MARK:-notification pemission func
    func registerLocal() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                
            } else {

            }
        }
    }
    //MARK:- notification receive func
    func scheduleLocal() {

                    UNUserNotificationCenter.current().getNotificationSettings { (settings) in

                        guard settings.authorizationStatus == .authorized else { return }

                        let content = UNMutableNotificationContent()

                        content.categoryIdentifier = "debitOverdraftNotification"

                        content.title = "Hello!"
                        content.subtitle = "Ivan says to you."
                        content.body = "You are next. Please come to our BarberShop!"
                        content.sound = UNNotificationSound.default

                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

                        let uuidString = UUID().uuidString
                        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

                        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                        

    }
}
       


}
