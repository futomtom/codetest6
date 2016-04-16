//
//  FullScreenViewController.swift
//  CodeTest2
//
//  Created by alexfu on 4/14/16.
//  Copyright © 2016 alexfu. All rights reserved.
//

import UIKit
import BrightcovePlayerSDK
import SnapKit


class FullScreenViewController: UIViewController {

   
   
    var playbackController:BCOVPlaybackController?
    var controlsViewController:ControlsViewController?
    // @IBOutlet weak var videoContainer:UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.frame = UIScreen.mainScreen().bounds

        view!.addSubview(playbackController!.view)
        
        playbackController!.view.snp_remakeConstraints { (make) -> Void in
            make.center.equalTo(view)
        //    make.centerY.equalTo(view.snp_centerX).offset(145)
          //  make.right.equalTo(view.snp_top)
            make.width.equalTo(view.snp_height)
            make.height.equalTo(view.snp_width)
        }
        playbackController!.view.transform=(CGAffineTransformMakeRotation(CGFloat(-M_PI/2)))
      
        
       
     
        
        playbackController!.view.layer.borderColor=UIColor .redColor().CGColor
        playbackController!.view.layer.borderWidth=2
    }
    
    override func viewWillAppear(animated: Bool) {
        view.addSubview(controlsViewController!.view!)
        controlsViewController!.view.snp_remakeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp_centerY).offset(20)    //barheight/2
            make.centerY.equalTo(view)
            make.width.equalTo(view.snp_height)
            make.height.equalTo(40)
        }
         controlsViewController!.view.transform=(CGAffineTransformMakeRotation(CGFloat(-M_PI/2)))
        

    }
    func handleEnterFullScreenButtonPressed() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let fullScreenVC = sb.instantiateViewControllerWithIdentifier("fullscreen") as? FullScreenViewController
        {
            fullScreenVC.playbackController = playbackController
            fullScreenVC.controlsViewController = controlsViewController
            presentViewController(fullScreenVC, animated: false, completion: { _ in })
        }
    }
    
    
    func handleExitFullScreenButtonPressed() {
        return
        /*
         dismissViewControllerAnimated(false, completion: {() -> Void in
         self.videoView.frame = self.view.bounds
         self.addChildViewController(self.controlsViewController)
         self.view.addSubview(self.videoView)
         self.controlsViewController.didMoveToParentViewController(self)
         })
         */
    }

   
}
