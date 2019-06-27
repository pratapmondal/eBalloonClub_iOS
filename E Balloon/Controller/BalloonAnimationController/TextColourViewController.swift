//
//  BackGroundViewController.swift
//  E Balloon
//
//  Created by VAP on 27/06/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit

class TextColourViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {

    @IBOutlet weak var tableviewBackGround: UITableView!
    @IBOutlet weak var pageControlColorView: UIPageControl!
    var intSelectIndex:Int = -1
    var strBalloonId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControlColorView.transform = CGAffineTransform(scaleX: 2, y: 2)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationBarSetUp()
        tableviewBackGround.delegate = self
        tableviewBackGround.dataSource = self
        tableviewBackGround.reloadData()
    }
    func navigationBarSetUp() {
        self.title = "eBalloon TextColor"
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
        let testUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back2"), style: .plain, target: self, action: #selector(TextColourViewController.nextButton))
        self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
    }
    
    
    @objc func nextButton(){
        let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "eballoonTextViewController") as! eballoonTextViewController
        if strBalloonId == "29" {
            controllerObj.strBalloonId = strBalloonId
        }
        self.navigationController?.pushViewController(controllerObj, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Tableview Datasource and Delegate...
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = self.tableviewBackGround.frame.size.height
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
            let ballonColor = SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonColor") as! String
            let start = ballonColor.index(ballonColor.startIndex, offsetBy: 1)
            let hexColor = String(ballonColor[start...])
            if strBalloonId == "29" {
                cell.imgBallon.image = UIImage(named: "flag-balloon")
            }else{
                cell.imgBallon.image = cell.imgBallon.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                cell.imgBallon.tintColor = UIColor(hex:hexColor)
            }
            let totalPage:Int = (SharedGlobalVariables.sharedColorCode.count / 12)
            pageControlColorView.numberOfPages = totalPage + 1
            pageControlColorView.currentPage = 0
            let strBalloonTextColor = SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonTextColor") as? String
            //let hexTextColor = String(strBalloonTextColor![(strBalloonTextColor!.index(strBalloonTextColor!.startIndex, offsetBy: 1)...)])
            cell.vwBalloonTitle.textColor = UIColor(hex:SharedFunctions.textToColorCode(colorCode: strBalloonTextColor!))
            cell.vwBalloonTitle.isEditable = false
            cell.vwBalloonTitle.text = SharedGlobalVariables.dicSaveBallonData.value(forKey: "description") as? String
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnimationOptionCell", for: indexPath) as!  AnimationOptionCell
            cell.collectionViewAnimationOption.delegate = self
            cell.collectionViewAnimationOption.dataSource = self
            cell.collectionViewAnimationOption.reloadData()
            cell.collectionViewAnimationOption.isPagingEnabled = true
            cell.selectionStyle = .none
            return cell
        }
    }
    

    
    //Mark: CollectionView Delegate and datasource...
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
//        cell.imgColour.layer.borderWidth = 1
//        cell.imgColour.layer.masksToBounds = false
//        cell.imgColour.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
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
        if indexPath.row == intSelectIndex {
            intSelectIndex = -1
        }else{
            intSelectIndex = indexPath.row
        }
        let strBalloonTextColor = SharedGlobalVariables.sharedColorCode[indexPath.row] as? String
        SharedGlobalVariables.dicSaveBallonData.setValue(strBalloonTextColor, forKey: "BalloonTextColor")
        tableviewBackGround.reloadData()
    }
    
    //ScrollView Delegate and Datasource...
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollViewWidth:CGFloat = scrollView.contentOffset.x + scrollView.frame.width
        let currentPageNumber = Int(scrollViewWidth/(scrollView.frame.width))
        pageControlColorView.currentPage = currentPageNumber - 1
    }

  

}
