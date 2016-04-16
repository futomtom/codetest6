//
//  PlayerViewController.swift
//  
//
//  Created by alexfu on 4/13/16.
//
//

import UIKit
import BrightcovePlayerSDK
import SnapKit
import MediaPlayer



let kViewControllerCatalogToken: String = "ZUPNyrUqRdcAtjytsjcJplyUc9ed8b0cD_eWIe36jXqNWKzIcE6i8A.."
let kViewControllerPlaylistID: String = "3637400917001"



class PlayerViewController: UIViewController , BCOVPlaybackControllerDelegate ,ControlsViewControllerFullScreenDelegate {
    
    
    var catalogService:BCOVCatalogService = BCOVCatalogService(token: kViewControllerCatalogToken)
    var playbackController:BCOVPlaybackController = BCOVPlayerSDKManager.sharedManager().createPlaybackController()
    var controlsViewController = ControlsViewController()
  
    
    func setup() {
        controlsViewController.delegate = self
        playbackController.delegate = self
        playbackController.autoAdvance = true
        playbackController.autoPlay = true
        playbackController.allowsBackgroundAudioPlayback = true
        playbackController.addSessionConsumer(controlsViewController)
        view.addSubview(playbackController.view!)
        view.addSubview(controlsViewController.view!)
        
        addChildViewController(controlsViewController)
        controlsViewController.didMoveToParentViewController(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupLayout()
        
        requestContentFromCatalog()
 
    }

    func setupLayout () {
    let playView = playbackController.view
    playView.snp_remakeConstraints { (make) -> Void in
        make.top.equalTo(view)
        make.left.equalTo(view)
        make.right.equalTo(view)
        make.width.equalTo(playView.snp_height).multipliedBy(1.77)
    }
    controlsViewController.view.snp_remakeConstraints { (make) -> Void in
        make.bottom.equalTo(playView)
        make.left.equalTo(playView)
        make.width.equalTo(playView)
        make.height.equalTo(40)
    }
    }
    

 
    func handleEnterFullScreenButtonPressed() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let fullScreenVC = sb.instantiateViewControllerWithIdentifier("fullscreen") as? FullScreenViewController
        {
      
         setInterfaceOrientation(.LandscapeRight)
        fullScreenVC.playbackController = playbackController
        fullScreenVC.controlsViewController = controlsViewController
        presentViewController(fullScreenVC, animated: false, completion: { _ in })
        }
    }
    
    func handleExitFullScreenButtonPressed() {
         setInterfaceOrientation(.Portrait)
        dismissViewControllerAnimated(false, completion: {() -> Void in
            print("hello")
            self.setup()
            self.setupLayout()
            self.view.setNeedsLayout()
        }) 
    }
    
    func setInterfaceOrientation(orientation: UIInterfaceOrientation) {
        UIDevice.currentDevice().setValue(orientation.rawValue, forKey: "orientation")
    }

    
    func requestContentFromCatalog() {
        catalogService.findPlaylistWithPlaylistID(kViewControllerPlaylistID, parameters: nil) { (playlist: BCOVPlaylist!, jsonResponse: [NSObject : AnyObject]!, error: NSError!) -> Void in
            
            if let p = playlist
            {
                self.playbackController.setVideos(p)
            }
            else
            {
                NSLog("ViewController Debug - Error retrieving playlist: %@", error)
            }
            
        }
    }


    func playbackController(controller: BCOVPlaybackController, didAdvanceToPlaybackSession session: BCOVPlaybackSession) {
            controlsViewController.currentPlayer = session.player
            }
            
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
                return .LightContent
            }
 
   



}


