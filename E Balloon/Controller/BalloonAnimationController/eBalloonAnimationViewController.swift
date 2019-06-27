//
//  eBalloonAnimationViewController.swift
//  E Balloon
//
//  Created by VAP on 11/06/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
import Spring
import AVFoundation
import AVKit

class AnimationOptionCell:UITableViewCell{
    @IBOutlet weak var collectionViewAnimationOption: UICollectionView!
    @IBOutlet weak var PageControl: UIPageControl!
}

class SelectAnimationOptionCell:UICollectionViewCell {
    @IBOutlet weak var lblAnimationName: UILabel!
}


class eBalloonAnimationViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, AVSpeechSynthesizerDelegate,AVAudioPlayerDelegate {
    
    var myAudioPlayer1:AVAudioPlayer?
    var myAudioPlayer: AVPlayer!
    var dicAnimationEffectSound:NSDictionary = NSDictionary()
    
   
    @IBOutlet weak var collectionViewAnimationOption: UICollectionView!
    @IBOutlet weak var imgBallonBackground: UIImageView!
    @IBOutlet weak var constraintShowImageBallon: NSLayoutConstraint!
    @IBOutlet weak var constraintCollectionView: NSLayoutConstraint!
    @IBOutlet weak var imgBallon: UIImageView!
    @IBOutlet weak var txtBalloonInnerText: UITextView!
    @IBOutlet weak var imgSadImage: UIImageView!
    
    @IBOutlet weak var vwBallonBackView: SpringView!
    @IBOutlet weak var pageControlAnimation: UIPageControl!
    
    @IBOutlet weak var imgAnimationImage: UIImageView!
    @IBOutlet weak var vwballoonBackground: UIView!
    var arrAnimationSetup = ["Bounce Up","Bounce Down","Bounce Right","Flip In","Zoom In","Explode","Music","Talk","Buzzing Noise","Bounce","Happy","Sad","","","","","",""]
    var intSelectIndex:Int = 100
    
    var selectedForce: CGFloat = 1
    var selectedDuration: CGFloat = 1
    var selectedDelay: CGFloat = 0
    
    var selectedDamping: CGFloat = 0.7
    var selectedVelocity: CGFloat = 0.2
    var selectedScale: CGFloat = 1
    var selectedX: CGFloat = 0
    var selectedY: CGFloat = 0
    var selectedRotate: CGFloat = 0
    
    var imageXCoordinate:CGFloat?
    var imageYCoordinate:CGFloat?
    var imageWidth:CGFloat?
    var imageHeight:CGFloat?
    
    var arrAnimationEffectSound:NSDictionary = NSDictionary()
    var intCurrentPage:Int = 0
    var intAnimationsetUp:Int = -1
    
    let speechSynthesizer = AVSpeechSynthesizer()
    var strBalloonId:String = ""

 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.balloonSetUp()
        self.view.isUserInteractionEnabled = true
        self.title = "eBalloon Animation"
        
        pageControlAnimation.isHidden = true
        myAudioPlayer1?.delegate = self
        speechSynthesizer.delegate = self
        let heightNavigationBar = self.navigationController?.navigationBar.frame.size.height
        let screenWidth = (UIScreen.main.bounds.height - heightNavigationBar!) - 35.0
        self.constraintShowImageBallon.constant = (screenWidth / 2 - 20)
        
        let testUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back2"), style: .plain, target: self, action: #selector(self.backButton))
        self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
    }
    
    @objc func backButton() {
        SharedGlobalVariables.dicSaveBallonData.setValue(100, forKey: "BalloonAnimationSetUp")
    }
  
    
    
    func balloonSetUp() {
        //description
        imgBallonBackground?.image = SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonBackgroundImage") as? UIImage
        let balloonText = SharedGlobalVariables.dicSaveBallonData.value(forKey: "description") as! String
        let balloonfontName = SharedFunctions.createFontName(fontName: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "BallonInnerTextFontName") as? String)!)
        let ballonFontSize = SharedFunctions.createFontSize(fontSize: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonInnerTextFontSize") as? String)!)
        let textFontColor = SharedFunctions.textToColorCode(colorCode: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonTextColor") as? String)!)
        
        let myTitle = NSAttributedString(string: balloonText , attributes: [NSAttributedStringKey.font:UIFont(name: balloonfontName, size: ballonFontSize)!,NSAttributedStringKey.foregroundColor:UIColor(hex:textFontColor)])
        txtBalloonInnerText?.attributedText = myTitle
        txtBalloonInnerText?.isEditable = false
        txtBalloonInnerText?.textAlignment = .center
        if strBalloonId == "29" {
            imgBallon?.image = UIImage(named: "flag-balloon")
        }else{
            let balloonColor = SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonColor") as! String
            imgBallon?.image = imgBallon.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            imgBallon?.tintColor = UIColor(hex : SharedFunctions.textToColorCode(colorCode: balloonColor))
        }
        if SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonAnimationSetUp") == nil {
            self.txtBalloonInnerText?.isHidden = false
            self.imgSadImage?.isHidden = true
        }else if SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonAnimationSetUp") as! Int == 10 {
            self.txtBalloonInnerText?.isHidden = true
            self.imgSadImage?.isHidden = false
            self.imgSadImage?.image = #imageLiteral(resourceName: "happy")
        }else if SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonAnimationSetUp") as! Int == 11 {
            self.txtBalloonInnerText?.isHidden = true
            self.imgSadImage?.isHidden = false
            self.imgSadImage?.image = #imageLiteral(resourceName: "sad")
        }else if SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonAnimationSetUp") as! Int == 7 {
            myAudioPlayer?.pause()
            self.txtBalloonInnerText?.isHidden = true
            self.imgAnimationImage?.isHidden = true
            let jeremyGif = UIImage.gifImageWithName("lip1")
            self.imgAnimationImage?.image = jeremyGif
            self.imgAnimationImage?.isHidden = false
            self.imgSadImage?.isHidden = false
            self.animationViewCreate(selectIndex: intSelectIndex)
        }else{
            self.txtBalloonInnerText?.isHidden = false
            self.imgSadImage?.isHidden = true
            self.imgAnimationImage.image = nil
        }
        
    }
    
    
    func addBalloon() {
        self.view.isUserInteractionEnabled = true
        self.vwBallonBackView?.frame = CGRect(x:(20), y: (20),width: imageWidth!, height:  imageHeight!)
        self.vwballoonBackground?.layoutIfNeeded()
        self.vwballoonBackground?.addSubview(vwBallonBackView)
        self.view.layoutIfNeeded()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.view.setNeedsLayout()
        vwBallonBackView?.force = 1.0
        vwBallonBackView?.duration = 0.0
        vwBallonBackView?.delay = selectedDelay
        vwBallonBackView?.animation = Spring.AnimationPreset.SqueezeUp.rawValue
        vwBallonBackView?.curve = Spring.AnimationCurve.EaseOutCirc.rawValue
        imageXCoordinate = vwBallonBackView?.frame.origin.x
        imageYCoordinate = vwBallonBackView?.frame.origin.y
        imageWidth = vwBallonBackView?.frame.size.width
        imageHeight = vwBallonBackView?.frame.size.height
        
        if SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonAnimationSetUp") != nil {
            SharedGlobalVariables.dicSaveBallonData.setValue(100, forKey: "BalloonAnimationSetUp")
        }
        
        
        
        pageControlAnimation.transform = CGAffineTransform(scaleX: 2, y: 2)
        self.navigationBarSetUp()
        self.balloonSetUp()
        
        
        DispatchQueue.main.async {
            self.WSGetAnimationSoundEffect()
        }
        
        //WSGetAnimationSoundEffect()
    }
    func navigationBarSetUp() {
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
        let testUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back2"), style: .plain, target: self, action: #selector(eBalloonAnimationViewController.clickButton))
        self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
    }
    
    
    
    @objc func clickButton(){
        if SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonAnimationSetUp") == nil {
           SharedFunctions.ShowAlert(controller: self, message: "Please select Balloon animation to continue.")
        }else{
            let controllerObj = self.storyboard?.instantiateViewController(withIdentifier: "eBalloonDeliverViewController") as! eBalloonDeliverViewController
            myAudioPlayer?.pause()
            myAudioPlayer1?.pause()
            if strBalloonId == "29" {
                controllerObj.strBalloonId = strBalloonId
            }
            self.navigationController?.pushViewController(controllerObj, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: CollectionView delegate and datasource...
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrAnimationSetup.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectAnimationOptionCell", for: indexPath) as! SelectAnimationOptionCell
        cell.lblAnimationName.text = arrAnimationSetup[indexPath.row]
        if intSelectIndex != 100 {
            if indexPath.row != intSelectIndex {
                if indexPath.row < 12 {
                    cell.contentView.layer.borderWidth = 2
                    cell.contentView.layer.borderColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
                    cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    cell.lblAnimationName?.textColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
                }else{
                    cell.contentView.layer.borderWidth = 0
                    cell.contentView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    cell.lblAnimationName?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                }
            }else{
                if indexPath.row < 12 {
                    cell.contentView.backgroundColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
                    cell.lblAnimationName?.textColor = #colorLiteral(red: 0.9753128886, green: 0.9021635652, blue: 0.2032856345, alpha: 1)
                }else{
                    cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    cell.lblAnimationName?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                }
            }
        }else{
            if indexPath.row < 12 {
                cell.contentView.layer.borderWidth = 2
                cell.contentView.layer.borderColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
                cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.lblAnimationName?.textColor = #colorLiteral(red: 0.8762018681, green: 0.1620529294, blue: 0.1954246759, alpha: 1)
            }else{
                cell.contentView.layer.borderWidth = 0
                cell.contentView.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                cell.lblAnimationName?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
        
        pageControlAnimation?.isHidden = false
        pageControlAnimation?.numberOfPages = 2
        pageControlAnimation?.currentPage = intCurrentPage
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectioViewHeight = collectionView.frame.size.height
        return CGSize(width: (collectionView.frame.size.width / 3 - 20 / 3), height: (collectioViewHeight/3 - 20 / 3))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.setNeedsLayout()
        myAudioPlayer?.pause()
        myAudioPlayer1?.pause()
        imgAnimationImage?.isHidden = true
        imgSadImage?.isHidden = true
        intSelectIndex = indexPath.row
        if intSelectIndex == 5 {
            myAudioPlayer?.pause()
            self.txtBalloonInnerText?.isHidden = false
            self.imgSadImage?.isHidden = true
            self.playAudioFile(selectIndex:intSelectIndex)
            let directions = [ExplodeDirection.top, ExplodeDirection.bottom, ExplodeDirection.left, ExplodeDirection.right, ExplodeDirection.chaos]
            let randomDirection = Int(arc4random_uniform(UInt32(4 - 0)) + 0)
            let direction = directions[randomDirection]
//            self.view.isUserInteractionEnabled = false
            SharedGlobalVariables.superViewSet = vwBallonBackView
            vwBallonBackView?.explode(direction, duration: 5000) {
//                self.addBalloon()
                
            }
            SharedGlobalVariables.dicSaveBallonData.setValue(intSelectIndex, forKey: "BalloonAnimationSetUp")
            collectionView.reloadData()
        }else if intSelectIndex == 6 {
            myAudioPlayer?.pause()
            //self.imgSadImage.image = nil
            self.txtBalloonInnerText?.isHidden = false
            self.playAudioFile(selectIndex:intSelectIndex)
            SharedGlobalVariables.dicSaveBallonData.setValue(intSelectIndex, forKey: "BalloonAnimationSetUp")
            collectionView.reloadData()
        }else if intSelectIndex == 10 {
            myAudioPlayer?.pause()
            self.txtBalloonInnerText?.isHidden = true
            self.imgSadImage?.isHidden = false
            self.imgSadImage?.image = #imageLiteral(resourceName: "happy")
            SharedGlobalVariables.dicSaveBallonData.setValue(intSelectIndex, forKey: "BalloonAnimationSetUp")
            collectionView.reloadData()
        }else if intSelectIndex == 11 {
            myAudioPlayer?.pause()
            self.txtBalloonInnerText?.isHidden = true
            self.imgSadImage?.isHidden = false
            self.imgSadImage?.image = #imageLiteral(resourceName: "sad")
            SharedGlobalVariables.dicSaveBallonData.setValue(intSelectIndex, forKey: "BalloonAnimationSetUp")
            collectionView.reloadData()
        }else if intSelectIndex == 7 {
            myAudioPlayer?.pause()
            self.txtBalloonInnerText?.isHidden = true
            self.imgAnimationImage?.isHidden = true
            let jeremyGif = UIImage.gifImageWithName("lip1")
            self.imgAnimationImage?.image = jeremyGif
            self.imgAnimationImage?.isHidden = false
            self.imgSadImage?.image = nil
            self.animationViewCreate(selectIndex: intSelectIndex)
            SharedGlobalVariables.dicSaveBallonData.setValue(intSelectIndex, forKey: "BalloonAnimationSetUp")
            collectionView.reloadData()
        }else if intSelectIndex == 8 {
            myAudioPlayer?.pause()
            self.txtBalloonInnerText?.isHidden = false
            self.playAudioFile(selectIndex:intSelectIndex)
            SharedGlobalVariables.dicSaveBallonData.setValue(intSelectIndex, forKey: "BalloonAnimationSetUp")
            collectionView.reloadData()
        }else if intSelectIndex == 12 || intSelectIndex == 13 || intSelectIndex == 14 || intSelectIndex == 15 || intSelectIndex == 16 || intSelectIndex == 17 {
            print("print")
        }else{
            myAudioPlayer?.pause()
            self.txtBalloonInnerText?.isHidden = false
            self.imgSadImage?.isHidden = true
            self.animationViewCreate(selectIndex: intSelectIndex)
            SharedGlobalVariables.dicSaveBallonData.setValue(intSelectIndex, forKey: "BalloonAnimationSetUp")
            collectionView.reloadData()
        }
    }

    func animationViewCreate(selectIndex:Int) {
        animateView(selectAnimation:selectIndex)
    }
    
    func animateView(selectAnimation:Int) {
        setOptions(selectionAnimation:selectAnimation)
        vwBallonBackView?.animate()
    }
    
    func setOptions(selectionAnimation:Int) {
        intAnimationsetUp = selectionAnimation
        
        switch selectionAnimation {
        case 0 :
            vwBallonBackView?.force = 1.0
            vwBallonBackView?.duration = 2.8
            vwBallonBackView?.delay = selectedDelay
            vwBallonBackView?.animation = Spring.AnimationPreset.SqueezeUp.rawValue
            vwBallonBackView?.curve = Spring.AnimationCurve.EaseOutCirc.rawValue
            break
        case 1:
            vwBallonBackView?.force = 1.0
            vwBallonBackView?.duration = 2.8
            vwBallonBackView?.delay = selectedDelay
            vwBallonBackView?.animation = Spring.AnimationPreset.SqueezeDown.rawValue
            vwBallonBackView?.curve = Spring.AnimationCurve.EaseOutCirc.rawValue
            break
        case 2:
            vwBallonBackView.force = 1.0
            vwBallonBackView.duration = 3.0
            vwBallonBackView.delay = selectedDelay
            vwBallonBackView.animation = Spring.AnimationPreset.SqueezeLeft.rawValue
            vwBallonBackView.curve = Spring.AnimationCurve.EaseInOutCirc.rawValue
            break
        case 3:
            vwBallonBackView.force = 1.0
            vwBallonBackView.duration = 1.0
            vwBallonBackView.delay = selectedDelay
            vwBallonBackView.animation = Spring.AnimationPreset.FlipX.rawValue
            vwBallonBackView.curve = Spring.AnimationCurve.EaseIn.rawValue
            break
        case 4:
            vwBallonBackView.force = 1.0
            vwBallonBackView.duration = 1.7
            vwBallonBackView.delay = selectedDelay
            vwBallonBackView.animation = Spring.AnimationPreset.ZoomIn.rawValue
            vwBallonBackView.curve = Spring.AnimationCurve.EaseOutSine.rawValue
            break
        case 6:
            break
        case 7:
            let speechText = SharedGlobalVariables.dicSaveBallonData.value(forKey: "description") as! String
            let speechUtterance = AVSpeechUtterance(string: speechText)
            speechUtterance.voice = AVSpeechSynthesisVoice(language: "english")
            speechUtterance.rate = 0
            speechSynthesizer.speak(speechUtterance)
            self.imgSadImage?.image = nil
            break
        case 8:
            vwBallonBackView.force = 4.8
            vwBallonBackView.duration = 4.9
            vwBallonBackView.delay = selectedDelay
            vwBallonBackView.animation = Spring.AnimationPreset.Wobble.rawValue
            vwBallonBackView.curve = Spring.AnimationCurve.Spring.rawValue
            break
        case 9:
            vwBallonBackView.force = 1.0
            vwBallonBackView.duration = 2.5
            vwBallonBackView.delay = selectedDelay
            vwBallonBackView.animation = Spring.AnimationPreset.Swing.rawValue
            vwBallonBackView.curve = Spring.AnimationCurve.EaseOutSine.rawValue
            break

        default:
            break
            
        }
        vwBallonBackView?.damping = selectedDamping
        vwBallonBackView?.velocity = selectedVelocity
        vwBallonBackView?.scaleX = selectedScale
        vwBallonBackView?.scaleY = selectedScale
        vwBallonBackView?.x = selectedX
        vwBallonBackView?.y = selectedY
        vwBallonBackView?.rotate = selectedRotate
    }
    //MARK: ScrollView Delegate...
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollViewWidth:CGFloat = (scrollView.contentOffset.x) + (scrollView.frame.width + 30)
        let currentPageNumber = Float(scrollViewWidth/(scrollView.frame.width + 30))
        if currentPageNumber > 1.00 {
            intCurrentPage = 1
        }else{
            intCurrentPage = 0
        }
        pageControlAnimation.currentPage = intCurrentPage
    }
    
    func playAudioFile(selectIndex:Int) {
        if selectIndex == 5 {
            let url = URL(string: dicAnimationEffectSound.value(forKey: "explode_sound") as! String)!
            let playerItem = CachingPlayerItem(url: url)
            myAudioPlayer = AVPlayer(playerItem: playerItem)
            if #available(iOS 10.0, *) {
                myAudioPlayer.automaticallyWaitsToMinimizeStalling = false
            } else {
                // Fallback on earlier versions
            }
            myAudioPlayer.play()
        }else if selectIndex == 6 {
            if SharedGlobalVariables.dicSaveBallonData.value(forKey: "audio") as! String != "" {
                let audioUrl:String = "https://www.eballoonclub.com/uploads/audio_files/" + (SharedGlobalVariables.dicSaveBallonData.value(forKey: "audio") as! String)
                let url = URL(string: audioUrl)!
                let playerItem = CachingPlayerItem(url: url)
                myAudioPlayer = AVPlayer(playerItem: playerItem)
                if #available(iOS 10.0, *) {
                    myAudioPlayer.automaticallyWaitsToMinimizeStalling = false
                } else {
                    // Fallback on earlier versions
                }
                myAudioPlayer.play()
            }else{
                var url:URL?
                let path = Bundle.main.path(forResource: "default.mp3", ofType:nil)!
                url = URL(fileURLWithPath: path)
                do {
                    myAudioPlayer1 = try AVAudioPlayer(contentsOf: url!)
                    myAudioPlayer1?.play()
                } catch {
                    // couldn't load file :(
                }
            }            
        }else{
            let url = URL(string: dicAnimationEffectSound.value(forKey: "buzzing_sound") as! String)!
            let playerItem = CachingPlayerItem(url: url)
            myAudioPlayer = AVPlayer(playerItem: playerItem)
            if #available(iOS 10.0, *) {
                myAudioPlayer.automaticallyWaitsToMinimizeStalling = false
            } else {
                // Fallback on earlier versions
            }
            myAudioPlayer.play()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.animationViewCreate(selectIndex: 8)
            }
        }
    }
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if intSelectIndex == 7 {
            self.txtBalloonInnerText.isHidden = true
            self.imgAnimationImage.isHidden = true
            //let jeremyGif = UIImage.gifImageWithName("lip1")
            self.imgAnimationImage.image = #imageLiteral(resourceName: "lip1.gif")
            self.imgAnimationImage?.isHidden = false
            self.imgSadImage?.isHidden = false
        }
    }
    func WSGetAnimationSoundEffect() {
        ActivityIndicator().showActivityIndicatory(uiView: self.view!)
        let Params:[String:String]! = [:]
        SharedFunctions.callApi(controller: self, valuDict: Params, serviceName:SharedVariables.WS_GET_SOUND_EFFECT, parseApiMethod: "POST")
    }
    internal func parseDictGetAnimationSoundEffectListApi(controller:UIViewController, dictJson:NSDictionary){
        ActivityIndicator().hideActivityIndicatory(uiView: self.view!)
        if (dictJson.value(forKey: "status") as AnyObject).boolValue == true {
            dicAnimationEffectSound = dictJson.value(forKey: "data") as! NSDictionary
            SharedGlobalVariables.dicAnimationSound = dicAnimationEffectSound
            self.collectionViewAnimationOption.delegate = self
            self.collectionViewAnimationOption.dataSource = self
            self.collectionViewAnimationOption.reloadData()
        }else{
            SharedFunctions.ShowAlert(controller: self, message: Messages.ERROR_OCCURS)
        }
    }
}
