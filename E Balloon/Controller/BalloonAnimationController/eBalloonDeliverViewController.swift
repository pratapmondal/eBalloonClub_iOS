//
//  eBalloonDeliverViewController.swift
//  E Balloon
//
//  Created by VAP on 11/06/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Spring


class EballoonCell:UITableViewCell {
    @IBOutlet weak var imgEballoon: UIImageView!
}
class EballoonDeliveryCell:UITableViewCell {
    @IBOutlet weak var lblDeliver: UILabel!
    @IBOutlet weak var btnToday: UIButton!
    @IBOutlet weak var imgCalender: UIImageView!
    @IBOutlet weak var lblLine: UILabel!
    @IBOutlet weak var btnChk: UIButton!
    @IBOutlet weak var lblRemain: UILabel!
    @IBOutlet weak var btnPriview: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
}

class BalloonDelivaryCell :UITableViewCell {
    @IBOutlet weak var imgBackGround: UIImageView!
    @IBOutlet weak var imgBalloon: UIImageView!
    @IBOutlet weak var txtInnnerText: UITextView!
    @IBOutlet weak var imgSadImage: UIImageView!
    @IBOutlet weak var imgAnimationImage: UIImageView!
}


class eBalloonDeliverViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var tablevieweBalloonDeliver: UITableView!
    var strDateSeletion:String = "MM/dd/yyyy"//yyyy-MM-dd
    var boolRemainderBalloonsetup:Bool = true
    
    @IBOutlet weak var vwAnimationShowUp: UIView!
    @IBOutlet weak var imgBackGround: UIImageView!
    @IBOutlet weak var vwSpringView: SpringView!
    @IBOutlet weak var imgBalloon: UIImageView!
    @IBOutlet weak var textview: UITextView!
    
    var myAudioPlayer: AVPlayer!
    var strBalloonId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablevieweBalloonDeliver.delegate = self
        tablevieweBalloonDeliver.dataSource = self
        tablevieweBalloonDeliver.reloadData()
    }
    
    func navigationBarSetUp() {
        self.title = "eBalloon Reminder"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        let backButton = UIBarButtonItem(image: UIImage(named: "back_arrow"), style: .plain, target: self, action: #selector(eBalloonDeliverViewController.backButton))
        self.navigationItem.leftBarButtonItem = backButton
    }
    @objc func backButton() {
        SharedGlobalVariables.dicSaveBallonData.setValue(100, forKey: "BalloonAnimationSetUp")
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.vwAnimationShowUp.isHidden = true
        self.navigationBarSetUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250.0
        }else if indexPath.row == 1 {
            return 245.0
        }else{
            return 0.0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BalloonDelivaryCell", for: indexPath) as!  BalloonDelivaryCell
            cell.imgBackGround.image = SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonBackgroundImage") as? UIImage
            
            let balloonText = SharedGlobalVariables.dicSaveBallonData.value(forKey: "description") as! String
            let balloonfontName = SharedFunctions.createFontName(fontName: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "BallonInnerTextFontName") as? String)!)
            let ballonFontSize = SharedFunctions.createFontSize(fontSize: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonInnerTextFontSize") as? String)!)
            let textFontColor = SharedFunctions.textToColorCode(colorCode: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonTextColor") as? String)!)
            let myTitle = NSAttributedString(string: balloonText , attributes: [NSAttributedStringKey.font:UIFont(name: balloonfontName, size: ballonFontSize)!,NSAttributedStringKey.foregroundColor:UIColor(hex:textFontColor)])
            cell.txtInnnerText.attributedText = myTitle
            cell.txtInnnerText.textAlignment = .center
            cell.txtInnnerText.isEditable = false
            if strBalloonId != "29" {
                let balloonColor = SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonColor") as! String
                cell.imgBalloon.image = cell.imgBalloon.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                cell.imgBalloon.tintColor = UIColor(hex: SharedFunctions.textToColorCode(colorCode: balloonColor))
            }else{
                cell.imgBalloon.image = UIImage(named: "flag-balloon")
            }            
            if SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonAnimationSetUp") as! Int == 10 {
                cell.imgAnimationImage?.isHidden = true
                cell.txtInnnerText.isHidden = true
                cell.imgSadImage.isHidden = false
                cell.imgSadImage.image = #imageLiteral(resourceName: "happy")
            }else if SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonAnimationSetUp") as! Int == 11 {
                cell.imgAnimationImage?.isHidden = true
                cell.txtInnnerText.isHidden = true
                cell.imgSadImage.isHidden = false
                cell.imgSadImage.image = #imageLiteral(resourceName: "sad")
            }else if SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonAnimationSetUp") as! Int == 7 {
                cell.imgAnimationImage?.isHidden = false
                cell.txtInnnerText.isHidden = true
                cell.imgSadImage?.isHidden = true
                cell.imgAnimationImage?.image = #imageLiteral(resourceName: "lip1.gif")
            }else{
                cell.txtInnnerText.isHidden = false
                cell.imgSadImage.isHidden = true
            }
            cell.selectionStyle = .none
            return cell
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EballoonDeliveryCell", for: indexPath) as!  EballoonDeliveryCell
            cell.btnToday.addTarget(self, action: #selector(datePickerCall(_:)), for: .touchUpInside)
            if SharedGlobalVariables.dicSaveBallonData.value(forKey: "selectSendDate") != nil {
                strDateSeletion = SharedGlobalVariables.dicSaveBallonData.value(forKey: "selectSendDate") as! String
            }
            cell.btnToday.setTitle(strDateSeletion, for: .normal)
            cell.btnConfirm.addTarget(self, action: #selector(ballonConfirm), for: .touchUpInside)
            cell.btnPriview.addTarget(self, action: #selector(ballonPreview), for: .touchUpInside)
            if boolRemainderBalloonsetup == true {
                cell.btnChk.setBackgroundImage(#imageLiteral(resourceName: "chk1"), for: .normal)
            }else{
                cell.btnChk.setBackgroundImage(#imageLiteral(resourceName: "chk2"), for: .normal)
            }
            cell.btnChk.addTarget(self, action: #selector(remainderBalloon(_:)), for: .touchUpInside)
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EballoonDeliveryCell", for: indexPath) as!  EballoonDeliveryCell
            cell.selectionStyle = .none
            return cell
        }
    }

    @objc func datePickerCall(_ btn:UIButton){
        let message = "\n\n\n\n\n"
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.isModalInPopover = true
        
        let attributedString = NSAttributedString(string: "Please select date" , attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14.0),NSAttributedStringKey.foregroundColor:UIColor(red:0.0, green:0.0, blue:0.0, alpha:1.0)])
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        //Create a frame (placeholder/wrapper) for the picker and then create the picker
        var pickerFrame: CGRect = CGRect()
        
        if UIScreen.main.bounds.size.width >= 750.0 && UIScreen.main.bounds.size.width < 1334.0 {  // for ipad air, pro
            pickerFrame = CGRect(x: 0, y: 0, width: 310, height: 100) // CGRectMake(left, top, width, height) - left and top are like margins
        }else{
            pickerFrame = CGRect(x: 0, y: 30, width: alert.view.bounds.size.width - 20, height: 120) // CGRectMake(left, top, width, height) - left and top are like margins
        }
        
        //Add the picker to the alert controller
        let datePicker = UIDatePicker(frame: pickerFrame)//UIDatePicker()
        // textField.inputView = datePicker
        
        let currentDate = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yyyy"
        self.strDateSeletion = dateformatter.string(from: currentDate)
        
        datePicker.datePickerMode = .date
        datePicker.minimumDate = datePicker.date
        datePicker.addTarget(self, action: #selector(self.datePickerChanged(sender:)), for: .valueChanged)
        alert.view.addSubview(datePicker)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            let currentDate = Date()
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "MM/dd/yyyy"
            self.strDateSeletion = dateformatter.string(from: currentDate)
        })
        
        alert.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let indexPath = IndexPath(item: 1, section: 0)
            self.tablevieweBalloonDeliver.reloadRows(at: [indexPath], with: .none)
        })
        
        // for iPAD support:
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.width / 2.0, y: self.view.bounds.height / 30.0, width: 40.0, height: 300.0)
        
        // this is the center of the screen currently but it can be any point in the view
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: TextField Delegate
    @objc func datePickerChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        strDateSeletion = formatter.string(from: sender.date)
        SharedGlobalVariables.dicSaveBallonData.setValue(strDateSeletion, forKey: "selectSendDate")
    }
    
    @objc func ballonConfirm(_ btn:UIButton){
        if strDateSeletion == "MM/dd/yyyy" {
            SharedFunctions.ShowAlert(controller: self, message: "Please select balloon delivery date.")
        }else{
            let balloonCell = tablevieweBalloonDeliver.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! BalloonDelivaryCell
//            let data = UIImagePNGRepresentation(balloonCell.imgBalloon.image!)
//            let imageData = UIImage(data: data!)
            SharedGlobalVariables.logoChangeProfilePicUpload["fileToUpload"] = balloonCell.imgBalloon.image!
            SharedGlobalVariables.dicSaveBallonData.setValue(balloonCell.imgBalloon.image!, forKey: "balloon_icon")
            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "SendviaViewController") as! SendviaViewController
            SharedGlobalVariables.dicSaveBallonData.setValue(strDateSeletion, forKey: "selectSendDate")
            SharedGlobalVariables.dicSaveBallonData.setValue((boolRemainderBalloonsetup == true ? "1" : "0"), forKey: "balloonRemainder")
            controllerObj.previousPageTacking = 1
            self.navigationController?.pushViewController(controllerObj, animated: true)
        }
    }
    
    @objc func remainderBalloon(_ btn : UIButton) {
        if boolRemainderBalloonsetup == true {
            boolRemainderBalloonsetup = false
        }else{
            boolRemainderBalloonsetup = true
        }
        let indexPath = IndexPath(item: 1, section: 0)
        self.tablevieweBalloonDeliver.reloadRows(at: [indexPath], with: .none)
    }
    
    @objc func ballonPreview(_ btn:UIButton){
        SharedGlobalVariables.dicSaveBallonData.setValue(strDateSeletion, forKey: "selectSendDate")
        if SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonAnimationSetUp") as! Int == 5 {
            imgBackGround.image = SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonBackgroundImage") as? UIImage
            let balloonText = SharedGlobalVariables.dicSaveBallonData.value(forKey: "description") as! String
            let balloonfontName = SharedFunctions.createFontName(fontName: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "BallonInnerTextFontName") as? String)!)
            let ballonFontSize = SharedFunctions.createFontSize(fontSize: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonInnerTextFontSize") as? String)!)
            let textFontColor = SharedFunctions.textToColorCode(colorCode: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonTextColor") as? String)!)
            
            let myTitle = NSAttributedString(string: balloonText , attributes: [NSAttributedStringKey.font:UIFont(name: balloonfontName, size: ballonFontSize)!,NSAttributedStringKey.foregroundColor:UIColor(hex:textFontColor)])
            textview.attributedText = myTitle
            textview.textAlignment = .center
            textview.isEditable = false
            
            let balloonColor = SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonColor") as! String
            imgBalloon.image = imgBalloon.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            imgBalloon.tintColor = UIColor(hex : SharedFunctions.textToColorCode(colorCode: balloonColor))
            
            self.vwAnimationShowUp.isHidden = false
            self.textview?.isHidden = false
            self.playAudioFile()
            let directions = [ExplodeDirection.top, ExplodeDirection.bottom, ExplodeDirection.left, ExplodeDirection.right, ExplodeDirection.chaos]
            let randomDirection = Int(arc4random_uniform(UInt32(4 - 0)) + 0)
            let direction = directions[randomDirection]
            //self.vwAnimationView.isHidden = true
            vwSpringView.explode(direction, duration: 100) {
            }
        }else{
            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
            if strBalloonId == "29" {
                controllerObj.strBalloonId = strBalloonId
            }
            controllerObj.ShowPopUpOnController(controller: self)
        }
        
    }
    
    func playAudioFile() {
        let url = URL(string: SharedGlobalVariables.dicAnimationSound.value(forKey: "explode_sound") as! String)!
        let playerItem = CachingPlayerItem(url: url)
        myAudioPlayer = AVPlayer(playerItem: playerItem)
        if #available(iOS 10.0, *) {
            myAudioPlayer.automaticallyWaitsToMinimizeStalling = false
        } else {
            // Fallback on earlier versions
        }
        myAudioPlayer.play()
    }

    @IBAction func btnBalloonRemove(_ sender: Any) {
        vwAnimationShowUp.isHidden = true
        vwSpringView?.force = 1.0
        vwSpringView?.duration = 2.8
        vwSpringView?.delay = 1
        vwSpringView?.animation = Spring.AnimationPreset.SqueezeUp.rawValue
        vwSpringView?.curve = Spring.AnimationCurve.EaseOutCirc.rawValue
        vwSpringView?.damping = 0.7
        vwSpringView?.velocity = 0.2
        vwSpringView?.scaleX = 1
        vwSpringView?.scaleY = 1
        vwSpringView?.x = 0
        vwSpringView?.y = 0
        vwSpringView?.rotate = 0
        vwSpringView?.animate()
    }
    
}
