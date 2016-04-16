//
//  PlayViewController.swift
//  CodeTest2
//
//  Created by alexfu on 3/13/16.
//  Copyright © 2016 alexfu. All rights reserved.
//

import UIKit
import MobilePlayer
import SnapKit

class PlayViewController: UIViewController {

    var playItem:Item=Item(itemData: nil)
    var playerVC:MobilePlayerViewController?
    
   
   
    
    @IBOutlet weak var TableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let bundle = NSBundle.mainBundle()
        let config = MobilePlayerConfig(fileURL: bundle.URLForResource(
            "MovielalaPlayer",
            withExtension: "json")!)
        
         playerVC = MobilePlayerViewController(contentURL:NSURL(string: playItem.videoLink!)!,config: config )
        playerVC!.title = playItem.name
        addChildViewController(playerVC!)
        playerVC!.view.translatesAutoresizingMaskIntoConstraints = false
        playerVC!.didMoveToParentViewController(self)
        self.view.addSubview(playerVC!.view)
        weak var weakSelf = self
        playerVC!.view.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(weakSelf!.view).offset(64)
            make.width.equalTo(weakSelf!.view)
            make.height.equalTo(weakSelf!.view).multipliedBy(0.4)
        }
        
        
        NSNotificationCenter.defaultCenter().addObserverForName("max", object: nil, queue: nil) { [weak self] _ in
                self?.ForceLandScapeMode()
        }
    
    
    NSNotificationCenter.defaultCenter().addObserverForName("min", object: nil, queue: nil) { [weak self] _ in
				self?.ForceportraitMode()
    }
        
        


        UIApplication.sharedApplication().statusBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.AllButUpsideDown
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait
    }
    override func shouldAutorotate() -> Bool {
        return true
    }

    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.currentDevice().orientation.isLandscape.boolValue {
            LandScapeMode()
        } else {
            portraitMode()
              }
    }
        func LandScapeMode(){
            self.navigationController!.navigationBar.hidden = true
            playerVC!.view.removeConstraints(playerVC!.view.constraints)
            
            weak var weakSelf = self
            playerVC!.view.snp_remakeConstraints  { (make) -> Void in
                make.top.equalTo(weakSelf!.view)
                make.width.equalTo(weakSelf!.view)
                make.height.equalTo(weakSelf!.view)
            }
            TableView.hidden=true
            self.view.layoutIfNeeded()
        }
    
    func portraitMode(){
        
        self.navigationController!.navigationBar.hidden = false
        playerVC!.view.removeConstraints(playerVC!.view.constraints)
        weak var weakSelf = self
        playerVC!.view.snp_remakeConstraints  { (make) -> Void in
            make.top.equalTo(weakSelf!.view).offset(64)
            make.width.equalTo(weakSelf!.view)
            make.height.equalTo(weakSelf!.view).multipliedBy(0.4)
        }
        TableView.hidden=false
        self.view.layoutIfNeeded()
        }
    
    func ForceLandScapeMode(){
        
        self.navigationController!.navigationBar.hidden = true
        playerVC!.view.removeConstraints(playerVC!.view.constraints)
        
        weak var weakSelf = self
        playerVC!.view.snp_remakeConstraints  { (make) -> Void in
           make.centerX.equalTo(weakSelf!.view.snp_centerY).offset(-145)
           make.centerY.equalTo(weakSelf!.view.snp_centerX).offset(145)
            make.width.equalTo(weakSelf!.view.snp_height)
            make.height.equalTo(weakSelf!.view.snp_width)
        }
        self.playerVC!.view.transform=(CGAffineTransformMakeRotation(CGFloat(M_PI/2)))
        TableView.hidden=true
        self.view.layoutIfNeeded()
    }
    
    func ForceportraitMode(){
        self.navigationController!.navigationBar.hidden = false
        
        playerVC!.view.removeConstraints(playerVC!.view.constraints)
        weak var weakSelf = self
        playerVC!.view.snp_remakeConstraints  { (make) -> Void in
           
            make.left.equalTo(weakSelf!.view)
            make.top.equalTo(weakSelf!.view).offset(64)
            make.width.equalTo(weakSelf!.view)
            make.height.equalTo(weakSelf!.view).multipliedBy(0.4)
        }
       self.playerVC!.view.transform=(CGAffineTransformMakeRotation(CGFloat(2*M_PI)))
        TableView.hidden=false
        self.view.layoutIfNeeded()
    }

    
    
    
    
    }




