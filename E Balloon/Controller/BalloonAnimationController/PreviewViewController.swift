//
//  PreviewViewController.swift
//  E Balloon
//
//  Created by VAP on 13/06/18.
//  Copyright © 2018 VAP. All rights reserved.
//

import UIKit
import Spring
import AVFoundation
import AVKit


class PreviewViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    var myAudioPlayer1:AVAudioPlayer?
    var myAudioPlayer: AVPlayer!
    
    @IBOutlet weak var imageBallonBackground: UIImageView!
    @IBOutlet weak var vwAnimationView: SpringView!
    @IBOutlet weak var imgBalloon: UIImageView!
    @IBOutlet weak var txtViewBalloonInnerText: UITextView!
    @IBOutlet weak var btnPreviewRemove: UIButton!
    @IBOutlet weak var imgSadImage: UIImageView!
    @IBOutlet weak var imgAnimationImage: UIImageView!
    
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
    let speechSynthesizer = AVSpeechSynthesizer()
    var strBalloonId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = false
        view.backgroundColor = #colorLiteral(red: 0.3498366475, green: 0.3501265943, blue: 0.3498815894, alpha: 0.8011023116)
        
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PreviewViewPopUpTap)))
        self.btnPreviewRemove.addTarget(self, action: #selector(self.PreviewViewPopUpTap), for: .touchUpInside)
        speechSynthesizer.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.setOptions(selectionAnimation:SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonAnimationSetUp") as! Int)
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.balloonSetup()
    }
    func balloonSetup(){
        imageBallonBackground.image = SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonBackgroundImage") as? UIImage
        let balloonText = SharedGlobalVariables.dicSaveBallonData.value(forKey: "description") as! String
        let balloonfontName = SharedFunctions.createFontName(fontName: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "BallonInnerTextFontName") as? String)!)
        let ballonFontSize = SharedFunctions.createFontSize(fontSize: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonInnerTextFontSize") as? String)!)
        let textFontColor = SharedFunctions.textToColorCode(colorCode: (SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonTextColor") as? String)!)
        
        let myTitle = NSAttributedString(string: balloonText , attributes: [NSAttributedStringKey.font:UIFont(name: balloonfontName, size: ballonFontSize)!,NSAttributedStringKey.foregroundColor:UIColor(hex:textFontColor)])
        txtViewBalloonInnerText.attributedText = myTitle
        txtViewBalloonInnerText.textAlignment = .center
        
        txtViewBalloonInnerText.isEditable = false
        if strBalloonId == "29" {
            imgBalloon.image = UIImage(named: "flag-balloon")
        }else{
            let balloonColor = SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonColor") as! String
            imgBalloon.image = imgBalloon.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            imgBalloon.tintColor = UIColor(hex : SharedFunctions.textToColorCode(colorCode: balloonColor))
        }
        
        if SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonAnimationSetUp") as! Int == 10 {
            imgAnimationImage?.isHidden = true
            txtViewBalloonInnerText.isHidden = true
            imgSadImage.isHidden = false
            imgSadImage.image = #imageLiteral(resourceName: "happy")
        }else if SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonAnimationSetUp") as! Int == 11 {
            imgAnimationImage?.isHidden = true
            txtViewBalloonInnerText.isHidden = true
            imgSadImage.isHidden = false
            imgSadImage.image = #imageLiteral(resourceName: "sad")
        }else if SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonAnimationSetUp") as! Int == 7 {
            imgAnimationImage?.isHidden = false
            imgSadImage?.isHidden = true
            txtViewBalloonInnerText?.isHidden = true
            imgAnimationImage?.image = #imageLiteral(resourceName: "lip1.gif")
        }else if SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonAnimationSetUp") as! Int == 8 {
            imgAnimationImage?.isHidden = true
            imgSadImage?.isHidden = true
            txtViewBalloonInnerText?.isHidden = false
        }else{
            txtViewBalloonInnerText.isHidden = false
            imgSadImage.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func PreviewViewPopUpTap(gesture : UITapGestureRecognizer) {
        self.view.alpha = 1.0
        UIView.animate (withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut ,animations:
            {
            self.view.alpha = 0.0
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            
        }, completion: { _ in
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
            self.view.alpha = 1.0
            
        })
    }
    
    internal func ShowPopUpOnController(controller : UIViewController) {
        self.view.alpha = 0.0
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        controller.addChildViewController(self)
        controller.view.addSubview(self.view)
        
        UIView.animate (withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut ,animations:
            {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: { _ in
            
        })
    }

    func setOptions(selectionAnimation:Int) {
        print(SharedGlobalVariables.dicSaveBallonData)
        switch selectionAnimation {
        case 0 :
            vwAnimationView.force = 1.0
            vwAnimationView.duration = 2.8
            vwAnimationView.delay = selectedDelay
            vwAnimationView.animation = Spring.AnimationPreset.SqueezeUp.rawValue
            vwAnimationView.curve = Spring.AnimationCurve.EaseOutCirc.rawValue
            break
        case 1:
            vwAnimationView.force = 1.0
            vwAnimationView.duration = 2.8
            vwAnimationView.delay = selectedDelay
            vwAnimationView.animation = Spring.AnimationPreset.SqueezeDown.rawValue
            vwAnimationView.curve = Spring.AnimationCurve.EaseOutCirc.rawValue
            break
        case 2:
            vwAnimationView.force = 1.0
            vwAnimationView.duration = 3.0
            vwAnimationView.delay = selectedDelay
            vwAnimationView.animation = Spring.AnimationPreset.SqueezeLeft.rawValue
            vwAnimationView.curve = Spring.AnimationCurve.EaseInOutCirc.rawValue
            break
        case 3:
            vwAnimationView.force = 1.0
            vwAnimationView.duration = 1.0
            vwAnimationView.delay = selectedDelay
            vwAnimationView.animation = Spring.AnimationPreset.FlipX.rawValue
            vwAnimationView.curve = Spring.AnimationCurve.EaseIn.rawValue
            break
        case 4:
            vwAnimationView.force = 1.0
            vwAnimationView.duration = 1.7
            vwAnimationView.delay = selectedDelay
            vwAnimationView.animation = Spring.AnimationPreset.ZoomIn.rawValue
            vwAnimationView.curve = Spring.AnimationCurve.EaseOutSine.rawValue
            break
        case 5:
            self.txtViewBalloonInnerText?.isHidden = false
            self.imgSadImage?.isHidden = true
            self.playAudioFile(selectIndex:selectionAnimation)
            let directions = [ExplodeDirection.top, ExplodeDirection.bottom, ExplodeDirection.left, ExplodeDirection.right, ExplodeDirection.chaos]
            let randomDirection = Int(arc4random_uniform(UInt32(4 - 0)) + 0)
            let direction = directions[randomDirection]
            //self.vwAnimationView.isHidden = true
            vwAnimationView.explode(direction, duration: 5) {
                self.vwAnimationView.removeFromSuperview()
            }
            break
        case 6:
            myAudioPlayer?.pause()
            self.playAudioFile(selectIndex:selectionAnimation)
            break
        case 7:
            self.imgSadImage?.isHidden = true
            let speechText = SharedGlobalVariables.dicSaveBallonData.value(forKey: "description") as! String
            let speechUtterance = AVSpeechUtterance(string: speechText)
            speechUtterance.voice = AVSpeechSynthesisVoice(language: "english")
            speechUtterance.rate = 0
            let jeremyGif = UIImage.gifImageWithName("lip1")
            self.imgAnimationImage.image = jeremyGif
            speechSynthesizer.speak(speechUtterance)
            break
        case 8:
            vwAnimationView.force = 4.8
            vwAnimationView.duration = 4.9
            vwAnimationView.delay = selectedDelay
            vwAnimationView.animation = Spring.AnimationPreset.Wobble.rawValue
            vwAnimationView.curve = Spring.AnimationCurve.Spring.rawValue
            self.playAudioFile(selectIndex:selectionAnimation)
            break
        case 9:
            vwAnimationView.force = 1.0
            vwAnimationView.duration = 2.5
            vwAnimationView.delay = selectedDelay
            vwAnimationView.animation = Spring.AnimationPreset.Swing.rawValue
            vwAnimationView.curve = Spring.AnimationCurve.EaseOutSine.rawValue
            break
            
        default:
            break
            
        }
        vwAnimationView.damping = selectedDamping
        vwAnimationView.velocity = selectedVelocity
        vwAnimationView.scaleX = selectedScale
        vwAnimationView.scaleY = selectedScale
        vwAnimationView.x = selectedX
        vwAnimationView.y = selectedY
        vwAnimationView.rotate = selectedRotate
        vwAnimationView.animate()
    }
    
    func playAudioFile(selectIndex:Int) {
        if selectIndex == 5 {
            let url = URL(string: SharedGlobalVariables.dicAnimationSound.value(forKey: "explode_sound") as! String)!
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
            let url = URL(string: SharedGlobalVariables.dicAnimationSound.value(forKey: "buzzing_sound") as! String)!
            let playerItem = CachingPlayerItem(url: url)
            myAudioPlayer = AVPlayer(playerItem: playerItem)
            if #available(iOS 10.0, *) {
                myAudioPlayer.automaticallyWaitsToMinimizeStalling = false
            } else {
                // Fallback on earlier versions
            }
            myAudioPlayer.play()
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                self.animationViewCreate(selectIndex: 8)
//            }
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if SharedGlobalVariables.dicSaveBallonData.value(forKey: "BalloonAnimationSetUp") as! Int == 7 {
            self.txtViewBalloonInnerText.isHidden = true
            self.imgAnimationImage.isHidden = true
            //let jeremyGif = UIImage.gifImageWithName("lip1")
            self.imgAnimationImage.image = #imageLiteral(resourceName: "lip1.gif")
            self.imgAnimationImage?.isHidden = false
            self.imgSadImage?.isHidden = false
        }
    }


}
