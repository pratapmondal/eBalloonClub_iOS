//
//  MyProfileViewController.swift
//  E Balloon
//
//  Created by VAP on 03/07/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
class PrfileTableviewCell:UITableViewCell{
    @IBOutlet weak var lblProfile: UILabel!
    @IBOutlet weak var imgProfileArrow: UIImageView!
}


class MyProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableviewMyProfile: UITableView!
    var arrProfile:NSArray = ["My Account","My Order","Notification","Address Book","Reminder List","Send","Change Password"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Profile"
        self.NavigationBarSetUp()
        tableviewMyProfile.delegate = self
        tableviewMyProfile.dataSource = self
        tableviewMyProfile.reloadData()
    }
    
    func NavigationBarSetUp() {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:Tabalview Delegate and Datasource...
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProfile.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 5 {
            return 50.0
        }else{
            return 0.0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrfileTableviewCell", for: indexPath) as!  PrfileTableviewCell
            cell.lblProfile.text = arrProfile[indexPath.row] as? String
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrfileTableviewCell", for: indexPath) as!  PrfileTableviewCell
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "MyAccountViewController") as! MyAccountViewController
            self.navigationController?.pushViewController(controllerObj, animated: true)
            break
        case 1:
            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "MyOrderViewController") as! MyOrderViewController
            self.navigationController?.pushViewController(controllerObj, animated: true)
            
            break
        case 2:
            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
            self.navigationController?.pushViewController(controllerObj, animated: true)
            
            break
        case 3:
            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "AddressBookViewController") as! AddressBookViewController
            self.navigationController?.pushViewController(controllerObj, animated: true)
            
            break
        case 4:
            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "ReminderListViewController") as! ReminderListViewController
            self.navigationController?.pushViewController(controllerObj, animated: true)
            
            break
        case 5:
            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "SendViewController") as! SendViewController
            self.navigationController?.pushViewController(controllerObj, animated: true)
            
            break
        case 6:
            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
            self.navigationController?.pushViewController(controllerObj, animated: true)
            
            break
            
        default:
            break
        }
    }
 
}
