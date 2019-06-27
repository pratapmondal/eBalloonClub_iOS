//
//  MenuViewController.swift
//  VickyLloyd
//
//  Created by VAP on 26/10/17.
//  Copyright © 2017 VAP. All rights reserved.
//

import UIKit
class MenuProfileTableViewCell : UITableViewCell {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserType: UILabel!
    @IBOutlet weak var lblName: UILabel!
}


class MenuOptionTableViewCell : UITableViewCell {
    
    @IBOutlet weak var imgBtnMenuOption: UIButton!
    @IBOutlet weak var lblMenuOptions: UILabel!
    @IBOutlet weak var imgArrow: UIImageView!
}
//"Privacy Policy",
//"Send via",

private let menuTitlesArray = ["eBalloonClub","Custom","Membership","Categories","My Profile","Reminder","Eula Policy","About Us","Logout"]
private let guestMenuTitlesArray = ["eballoonClub","Custom","Membership","Categories","Eula Policy","About Us"]


class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewMenu: UITableView!
    
    private var imageCacheCategoryImage = [String:UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(LoggedInData), name: NSNotification.Name(rawValue: "MENU_RELOGIN"), object: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(LoggedInData), name: NSNotification.Name(rawValue: "MENU_RELOGIN"), object: nil)
        tableViewMenu.delegate = self
        tableViewMenu.dataSource = self
        tableViewMenu.reloadData()
    }
    
    @objc func LoggedInData(object:NSNotification){
        
        tableViewMenu.delegate = self
        tableViewMenu.dataSource = self
        tableViewMenu.reloadData()
    }
    
    // table view delegate and data source methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }else if section == 1 {
            if UserDefaults.standard.value(forKey: "custid") != nil {
                return menuTitlesArray.count
            }else{
                return guestMenuTitlesArray.count
            }
        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100.0
        }else if indexPath.section == 1 {
            return 50.0
        }else{
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuProfileTableViewCell", for: indexPath) as! MenuProfileTableViewCell
            
            cell.imgProfile.clipsToBounds = true
            //cell.imgProfile.layer.borderWidth = 3
            //cell.imgProfile.layer.borderColor = UIColor(hex: 0xFFFFFF)
            //print(UserDefaults.standard.value(forKey: "profilePic") as! String)
            if let strValue = UserDefaults.standard.value(forKey: "profilePic") {
                // gallery image
                
                let stringURL:String = UserDefaults.standard.value(forKey: "profilePic") as! String
                let urlNew:String = stringURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                
                //cell.imgProfile.contentMode = .scaleAspectFit
                cell.imgProfile.image = nil
                
                //-----------Load Image-----------------
                if stringURL != "" {
                    if let img = self.imageCacheCategoryImage[urlNew] {
                        cell.imgProfile.image = img
                    }else {
                        let request: NSURLRequest = NSURLRequest(url: NSURL(string: urlNew)! as URL)
                        let mainQueue = OperationQueue.main
                        
                        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                            if error == nil {
                                // Convert the downloaded data in to a UIImage object
                                let image = UIImage(data: data!)
                                // Store the image in to our cache
                                self.imageCacheCategoryImage[stringURL] = image
                                // Update the cell
                                DispatchQueue.main.async(execute: {
                                    cell.imgProfile.image = image
                                    //SharedGlobalVariables.logoChangeProfileUpUpload["imgProfile"] = image
                                    //cell.imgProfile.contentMode = .scaleAspectFit
                                })
                            }
                            else {
                                print("Error: \(error!.localizedDescription)")
                            }
                        })
                    }
                }
            }else{
                cell.imgProfile.image = #imageLiteral(resourceName: "profile")
            }
            
            if UserDefaults.standard.value(forKey: "custid") != nil {
                cell.lblUserName.text = ((UserDefaults.standard.value(forKey: "firstName") != nil) ? (UserDefaults.standard.value(forKey: "firstName") as! String).uppercased() : "John Dept")//"John Dept"
                cell.lblUserType.text = ((UserDefaults.standard.value(forKey: "Email_Id") != nil) ? UserDefaults.standard.value(forKey: "Email_Id") as! String : "jone.dept@gmail.com")//"Business Owner"
            }else{
                cell.lblUserName.text = ((UserDefaults.standard.value(forKey: "userName") != nil) ? (UserDefaults.standard.value(forKey: "userName") as! String).uppercased() : "Sign Up / Login")//"John Dept"
                cell.lblUserType.text = ((UserDefaults.standard.value(forKey: "userEmail") != nil) ? UserDefaults.standard.value(forKey: "userEmail") as! String : "Guest")//"Business Owner"
            }
            cell.selectionStyle = .none
            return cell
            
        }else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuOptionTableViewCell", for: indexPath) as! MenuOptionTableViewCell
            if UserDefaults.standard.value(forKey: "custid") != nil {
                cell.lblMenuOptions.text = menuTitlesArray[indexPath.row]
                switch indexPath.row {
                case 0:
                    cell.imgBtnMenuOption.setImage(UIImage(named: "eBalloonClub"), for: .normal)
                    cell.imgArrow.isHidden = false
                    break
                case 1:
                    cell.imgBtnMenuOption.setImage(UIImage(named: "custom"), for: .normal)
                    cell.imgArrow.isHidden = false
                    break
                case 2:
                    cell.imgBtnMenuOption.setImage(UIImage(named: "Membership"), for: .normal)
                    cell.imgArrow.isHidden = false
                    break
                case 3:
                    cell.imgBtnMenuOption.setImage(UIImage(named: "category-menu"), for: .normal)
                    cell.imgArrow.isHidden = false
                    break
                case 4:
                    cell.imgBtnMenuOption.setImage(UIImage(named: "my-Profile"), for: .normal)
                    cell.imgArrow.isHidden = false
                    break
                case 5:
                    cell.imgBtnMenuOption.setImage(UIImage(named: "my-Profile"), for: .normal)
                    cell.imgArrow.isHidden = false
                    break
                case 6 :
                    cell.imgBtnMenuOption.setImage(UIImage(named: "terms-Menu"), for: .normal)
                    cell.imgArrow.isHidden = false
                    break
                case 7:
                    cell.imgBtnMenuOption.setImage(UIImage(named: "About-menu"), for: .normal)
                    cell.imgArrow.isHidden = false
                    break
                case 8:
                    cell.imgBtnMenuOption.setImage(UIImage(named: "Logout-menu"), for: .normal)
                    cell.imgArrow.isHidden = true
                    break
                default:
                    cell.imgBtnMenuOption.setImage(UIImage(named: "Logout-menu"), for: .normal)
                    break
                }
            }else{
                cell.lblMenuOptions.text = guestMenuTitlesArray[indexPath.row]
                switch indexPath.row {
                case 0 :
                    cell.imgBtnMenuOption.setImage(UIImage(named: "eBalloonClub"), for: .normal)
                    cell.imgArrow.isHidden = false
                    break
                case 1:
                    cell.imgBtnMenuOption.setImage(UIImage(named: "custom"), for: .normal)
                    cell.imgArrow.isHidden = false
                    break
                case 2 :
                    cell.imgBtnMenuOption.setImage(UIImage(named: "Membership"), for: .normal)
                    cell.imgArrow.isHidden = false
                    break
                case 3:
                    cell.imgBtnMenuOption.setImage(UIImage(named: "category-menu"), for: .normal)
                    cell.imgArrow.isHidden = false
                    break
                case 4 :
                    cell.imgBtnMenuOption.setImage(UIImage(named: "terms-Menu"), for: .normal)
                    cell.imgArrow.isHidden = false
                    break
                case 5 :
                    cell.imgBtnMenuOption.setImage(UIImage(named: "About-menu"), for: .normal)
                    cell.imgArrow.isHidden = false
                    break
                default:
                    cell.imgBtnMenuOption.setImage(UIImage(named: "About-menu"), for: .normal)
                    cell.imgArrow.isHidden = false
                    break
                }
            }
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuProfileTableViewCell", for: indexPath) as! MenuProfileTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainViewController = sideMenuController!
        if indexPath.section == 0 {
            if UserDefaults.standard.value(forKey: "Email_Id") == nil {
                let viewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
                SharedGlobalVariables.selectedViewController = ""
                let navigationController = mainViewController.rootViewController as! NavigationController
                navigationController.pushViewController(viewControllerObj, animated: true)
                mainViewController.hideLeftView(animated: true, completionHandler: nil)
            }
        }else if indexPath.section == 1 {
            if UserDefaults.standard.value(forKey: "custid") != nil {
                switch indexPath.row {
                case 0:
                    let viewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "eBalloonClubViewController") as! eBalloonClubViewController
                    SharedGlobalVariables.dicSaveBallonData.removeAllObjects()
                    let navigationController = mainViewController.rootViewController as! NavigationController
                    navigationController.pushViewController(viewControllerObj, animated: true)
                    mainViewController.hideLeftView(animated: true, completionHandler: nil)
                    break
                case 1:
                    let viewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "eBalloonColorViewController") as! eBalloonColorViewController
                    viewControllerObj.strMenuSetup = "2"
                    SharedGlobalVariables.dicSaveBallonData.removeAllObjects()
                    SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "balloon_id")
                    SharedGlobalVariables.dicSaveBallonData.setValue("Sample Text", forKey: "description")
                    SharedGlobalVariables.dicSaveBallonData.setValue("#DCBF1E", forKey: "BalloonColor")
                    let navigationController = mainViewController.rootViewController as! NavigationController
                    navigationController.pushViewController(viewControllerObj, animated: true)
                    mainViewController.hideLeftView(animated: true, completionHandler: nil)
                    break
                case 2:
                    let viewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "MembershipViewController") as! MembershipViewController
                    SharedGlobalVariables.dicSaveBallonData.removeAllObjects()
                    let navigationController = mainViewController.rootViewController as! NavigationController
                    navigationController.pushViewController(viewControllerObj, animated: true)
                    mainViewController.hideLeftView(animated: true, completionHandler: nil)
                    break
                case 3:
                    let viewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
                    let navigationController = mainViewController.rootViewController as! NavigationController
                    SharedGlobalVariables.dicSaveBallonData.removeAllObjects()
                    navigationController.pushViewController(viewControllerObj, animated: true)
                    mainViewController.hideLeftView(animated: true, completionHandler: nil)
                    break
                case 4:
                    let viewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                    SharedGlobalVariables.dicSaveBallonData.removeAllObjects()
                    let navigationController = mainViewController.rootViewController as! NavigationController
                    navigationController.pushViewController(viewControllerObj, animated: true)
                    mainViewController.hideLeftView(animated: true, completionHandler: nil)
                    break
                case 5:
                    let viewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "CalenderDetailsViewController") as! CalenderDetailsViewController
                    SharedGlobalVariables.dicSaveBallonData.removeAllObjects()
                    let navigationController = mainViewController.rootViewController as! NavigationController
                    navigationController.pushViewController(viewControllerObj, animated: true)
                    mainViewController.hideLeftView(animated: true, completionHandler: nil)
                    break
                case 6:
                    let viewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
                    viewControllerObj.strTermsCondition = "1"
                    SharedGlobalVariables.dicSaveBallonData.removeAllObjects()
                    let navigationController = mainViewController.rootViewController as! NavigationController
                    navigationController.pushViewController(viewControllerObj, animated: true)
                    mainViewController.hideLeftView(animated: true, completionHandler: nil)
                    break
                case 7:
                    let viewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
                    SharedGlobalVariables.dicSaveBallonData.removeAllObjects()
                    let navigationController = mainViewController.rootViewController as! NavigationController
                    viewControllerObj.strTermsCondition = "2"
                    navigationController.pushViewController(viewControllerObj, animated: true)
                    mainViewController.hideLeftView(animated: true, completionHandler: nil)
                    break
                case 8:
                    self.userLogOut()
                    break
                default:
                    /*let viewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController

                    let navigationController = mainViewController.rootViewController as! NavigationController
                    navigationController.pushViewController(viewControllerObj, animated: true)

                    mainViewController.hideLeftView(animated: true, completionHandler: nil)*/
                    break
                }
            }else{
                switch indexPath.row {
                case 0 :
                    let viewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "eBalloonClubViewController") as! eBalloonClubViewController
                    let navigationController = mainViewController.rootViewController as! NavigationController
                    navigationController.pushViewController(viewControllerObj, animated: true)
                    mainViewController.hideLeftView(animated: true, completionHandler: nil)
                    break
                case 1:
                    let viewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "eBalloonColorViewController") as! eBalloonColorViewController
                    SharedGlobalVariables.dicSaveBallonData.setValue("", forKey: "balloon_id")
                    SharedGlobalVariables.dicSaveBallonData.setValue("Sample Text", forKey: "description")
                    SharedGlobalVariables.dicSaveBallonData.setValue("#DCBF1E", forKey: "BalloonColor")
                    let navigationController = mainViewController.rootViewController as! NavigationController
                    navigationController.pushViewController(viewControllerObj, animated: true)
                    mainViewController.hideLeftView(animated: true, completionHandler: nil)
                    break
                case 2:
                    //self.showAlertWithPop()
                    let viewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "MembershipViewController") as! MembershipViewController
                    let navigationController = mainViewController.rootViewController as! NavigationController
                    navigationController.pushViewController(viewControllerObj, animated: true)
                    mainViewController.hideLeftView(animated: true, completionHandler: nil)
                    break
                case 3:
                    let viewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
                    let navigationController = mainViewController.rootViewController as! NavigationController
                    navigationController.pushViewController(viewControllerObj, animated: true)
                    mainViewController.hideLeftView(animated: true, completionHandler: nil)
                    break
                case 4:
                    let viewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
                    viewControllerObj.strTermsCondition = "1"
                    let navigationController = mainViewController.rootViewController as! NavigationController
                    navigationController.pushViewController(viewControllerObj, animated: true)
                    mainViewController.hideLeftView(animated: true, completionHandler: nil)
                    break
                case 5:
                    let viewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
                    viewControllerObj.strTermsCondition = "2"
                    let navigationController = mainViewController.rootViewController as! NavigationController
                    navigationController.pushViewController(viewControllerObj, animated: true)
                    mainViewController.hideLeftView(animated: true, completionHandler: nil)
                    break
                default:
                    let viewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
                    let navigationController = mainViewController.rootViewController as! NavigationController
                    navigationController.pushViewController(viewControllerObj, animated: true)
                    mainViewController.hideLeftView(animated: true, completionHandler: nil)
                    break
                }
            }
        }
    }
    
    func userLogOut() {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Are you sure?", preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in
            UserDefaults.standard.removeObject(forKey: "custid")
            UserDefaults.standard.removeObject(forKey: "created_at")
            UserDefaults.standard.removeObject(forKey: "Email_Id")
            UserDefaults.standard.removeObject(forKey: "firstName")
            UserDefaults.standard.removeObject(forKey: "is_member")
            UserDefaults.standard.removeObject(forKey: "phone")
            UserDefaults.standard.removeObject(forKey: "is_trial")
            UserDefaults.standard.removeObject(forKey: "transaction_amount")
            
            let mainViewController = self.sideMenuController!
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MENU_RELOGIN"), object: nil, userInfo: nil )
            let viewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "eBalloonClubViewController") as! eBalloonClubViewController
            let navigationController = mainViewController.rootViewController as! NavigationController
            navigationController.pushViewController(viewControllerObj, animated: true)
            mainViewController.hideLeftView(animated: true, completionHandler: nil)
        }
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: .destructive) { action -> Void in
            
        }
        actionSheetController.addAction(okAction)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    func showAlertWithPop() {
        let actionSheetController: UIAlertController = UIAlertController(title: "", message: "Login to subscribe to eBalloonClub", preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in
            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            let mainViewController = self.sideMenuController!
            let navigationController = mainViewController.rootViewController as! NavigationController
            navigationController.pushViewController(controllerObj, animated: true)
            mainViewController.hideLeftView(animated: true, completionHandler: nil)
        }
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    

 }
