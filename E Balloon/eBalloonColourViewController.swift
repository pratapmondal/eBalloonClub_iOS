//
//  eBalloonColourViewController.swift
//  E Balloon
//
//  Created by VAP on 11/06/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
class AnimationImageCell:UITableViewCell{
    @IBOutlet weak var imgAnimation: UIImageView!
}
class AnimationOptionCell:UITableViewCell{
    
    @IBOutlet weak var collectionViewAnimationOption: UICollectionView!
    @IBOutlet weak var PageControl: UIPageControl!
}
class CollectionViewCellCollectionViewCell:UICollectionViewCell{
    
    @IBOutlet weak var BtnBuzzing: UIButton!
    
}




class eBalloonColorViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var tablevieweBalloonColour: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "eBalloon Animation"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
        //UIColor(red: 2/255, green: 51/255, blue: 154/255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        tablevieweBalloonColour.delegate = self
        tablevieweBalloonColour.dataSource = self
        tablevieweBalloonColour.reloadData()
        
        let backImage    = UIImage(named: "back2")!
        
        let backButton   = UIBarButtonItem(image: backImage,  style: .plain, target: self, action: Selector(("didTapbackButton:")))
        
        navigationItem.rightBarButtonItems = [backButton]
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        } else{
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 245.0
        } else{
            return 350.0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnimationImageCell", for: indexPath) as!  AnimationImageCell
            
            cell.selectionStyle = .none
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnimationOptionCell", for: indexPath) as!  AnimationOptionCell
            cell.collectionViewAnimationOption.delegate = self
            cell.collectionViewAnimationOption.dataSource = self
            cell.collectionViewAnimationOption.reloadData()
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            return CGSize(width: (collectionView.frame.size.width), height: 160)
        }else{
            print(collectionView.frame.size.width)
            return CGSize(width: ((collectionView.frame.size.width / 2) - 5), height: 160)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellCollectionViewCell", for: indexPath as IndexPath) as! CollectionViewCellCollectionViewCell
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 //set return 0 for no spacing you can check to change the return value
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

