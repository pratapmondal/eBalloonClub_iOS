//
//  eBalloonColorViewController.swift
//  E Balloon
//
//  Created by VAP on 11/06/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
class AnimationImageCell:UITableViewCell{
    @IBOutlet weak var imgImageBackground: UIImageView!
    @IBOutlet weak var imgBallon: UIImageView!
    @IBOutlet weak var vwBalloonTitle: UITextView!
}

class BalloonColoueCell:UICollectionViewCell{
    @IBOutlet weak var imgColour: UIImageView!
    @IBOutlet weak var imgSelect: UIImageView!
}

class eBalloonColorViewController: UIViewController,UITableViewDataSource,UITableViewDelegate ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
   
    var arrColorList:NSArray = NSArray()
    @IBOutlet weak var tablevieweBalloonColor: UITableView!
    @IBOutlet weak var pageCount: UIPageControl!
    var intCurrentPage:Int = 0
    var strSelectBalloonColorCode:String?
    var strSelectBalloonText:String?
    
    var intSelectIndex:Int = -1
    var strMenuSetup:String = "1"
    var strBalloonId:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageCount.transform = CGAffineTransform(scaleX: 2, y: 2)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationBarSetup()
        if strMenuSetup != "1" {
           self.addMenuToScreen()
        }
        tablevieweBalloonColor.delegate = self
        tablevieweBalloonColor.dataSource = self
        tablevieweBalloonColor.reloadData()
    }
    
    func addMenuToScreen(){
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        let menuButton = UIButton()
        menuButton.setImage(UIImage(named: "menu-profile"), for: .normal)
        menuButton.frame = CGRect(x: 0, y: 0, width: 23.0, height: 18.0)
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = menuButton
        let mainViewController = sideMenuController!
        menuButton.addTarget(mainViewController, action: #selector(mainViewController.showLeftViewAnimated(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func navigationBarSetup() {
        self.title = "eBalloon Color"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let backImage = UIImage(named: "back2")!
        let backButton = UIBarButtonItem(image: backImage,  style: .plain, target: self, action: Selector(("didTapbackButton:")))
        navigationItem.rightBarButtonItems = [backButton]
        let testUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back2"), style: .plain, target: self, action: #selector(eBalloonColorViewController.clickButton))
        self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
    }
    
    @objc func clickButton(){
        let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "TextColourViewController") as! TextColourViewController
        SharedGlobalVariables.dicSaveBallonData.setValue("#ffffff", forKey: "BalloonTextColor")
        if strBalloonId == "29" {
            controllerObj.strBalloonId = strBalloonId
        }
        self.navigationController?.pushViewController(controllerObj, animated: true)
    }
    
    //MARK:TableView Delegate and Datasource...
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = self.tablevieweBalloonColor.frame.size.height
        if indexPath.row == 0 {
            return screenHeight/2 - 10.0
        }else{
            if UIScreen.main.bounds.height == 812 {
                return 354.0
            }else{
                return screenHeight/2 + 10.0
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnimationImageCell", for: indexPath) as!  AnimationImageCell
            let strBalloonColorCode = SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonColor") as! String == "" ? "#EE53B8" : SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonColor") as! String
            let start = strBalloonColorCode.index(strBalloonColorCode.startIndex, offsetBy: 1)
            let hexColor = String(strBalloonColorCode[start...])
            if strBalloonId != "29" {
                cell.imgBallon.image = cell.imgBallon.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                cell.imgBallon.tintColor = UIColor(hex:hexColor)
            }else{
                cell.imgBallon.image = UIImage(named: "flag-balloon")
            }
            let strBalloonInnnerText = SharedGlobalVariables.dicSaveBallonData.value(forKey: "description") as! String
            cell.vwBalloonTitle.text = strBalloonInnnerText
            cell.vwBalloonTitle.textColor = UIColor.white
            cell.vwBalloonTitle.isEditable = false
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnimationOptionCell", for: indexPath) as!  AnimationOptionCell
            cell.collectionViewAnimationOption.delegate = self
            cell.collectionViewAnimationOption.dataSource = self
            cell.collectionViewAnimationOption.isPagingEnabled = true
            cell.collectionViewAnimationOption.reloadData()
            let totalPage:Int = (SharedGlobalVariables.sharedColorCode.count / 12)
            pageCount.numberOfPages = totalPage + 1
            pageCount.currentPage = intCurrentPage
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
    //MARK: CollectionView Datasource and Delegate...
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SharedGlobalVariables.sharedColorCode.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BalloonColoueCell", for: indexPath) as! BalloonColoueCell
        if indexPath.row == intSelectIndex {
            cell.imgColour.layer.borderWidth = 2.0
            cell.imgColour.layer.masksToBounds = true
            cell.imgColour.layer.borderColor = UIColor.red.cgColor
            cell.imgSelect.isHidden = false
        }else{
            cell.imgColour.layer.borderWidth = 1.0
            cell.imgColour.layer.masksToBounds = true
            cell.imgColour.layer.borderColor = UIColor.black.cgColor
            cell.imgSelect.isHidden = true
        }

        if UIScreen.main.bounds.height == 812.0 {
            cell.imgColour.layer.cornerRadius = (((375 - 6) / 4) - 4) / 2
        }else{
           cell.imgColour.layer.cornerRadius = (((collectionView.frame.size.height - 6) / 3) - 4) / 2
        }
        
        cell.imgColour.clipsToBounds = true
        let strBallonColorCode = SharedGlobalVariables.sharedColorCode[indexPath.row] as! String
        let start = strBallonColorCode.index(strBallonColorCode.startIndex, offsetBy: 1)
        let hexColor = String(strBallonColorCode[start...])
        cell.imgColour.backgroundColor = UIColor(hex: hexColor)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIScreen.main.bounds.height == 812.0 {
            let collectioViewHeight = (375 - 6) / 4
            return CGSize(width: collectioViewHeight, height: collectioViewHeight)
        }else{
            let collectioViewHeight = (collectionView.frame.size.height - 6) / 3
            return CGSize(width: collectioViewHeight, height: collectioViewHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let collectioViewHeight = collectionView.frame.size.width
        var cellWidth:CGFloat!
        if UIScreen.main.bounds.height == 812.0 {
            cellWidth = (375 - 6) / 4
        }else{
            cellWidth = (collectionView.frame.size.height - 6) / 3
        }
        let cellGap = (collectioViewHeight - (cellWidth*4)) / 3
        return cellGap
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if strBalloonId != "29" {
            if indexPath.row == intSelectIndex {
                intSelectIndex = -1
            }else{
                intSelectIndex = indexPath.row
            }
            let selectColorCode = SharedGlobalVariables.sharedColorCode[indexPath.row] as? String
            SharedGlobalVariables.dicSaveBallonData.setValue(selectColorCode, forKey: "BalloonColor")
            tablevieweBalloonColor.reloadData()
        }else{
            let actionSheetController: UIAlertController = UIAlertController(title: "", message: "You can not select the color for this particular balloon", preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .cancel) { action -> Void in
            }
            actionSheetController.addAction(okAction)
            self.present(actionSheetController, animated: true, completion: nil)
        }
        
    }
    
    //MARK: ScrollView Delegate...
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollViewWidth:CGFloat = scrollView.contentOffset.x + scrollView.frame.width
        let currentPageNumber = Int(scrollViewWidth/(scrollView.frame.width))
        pageCount.currentPage = currentPageNumber - 1
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}
