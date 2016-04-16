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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view!.addSubview(playbackController!.view)
       
        playbackController!.view.snp_remakeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
      
        view.addSubview(controlsViewController!.view!)
        let playView = playbackController!.view
        controlsViewController!.view.snp_remakeConstraints { (make) -> Void in
                make.bottom.equalTo(playView)
                make.left.equalTo(playView)
                make.width.equalTo(playView)
                make.height.equalTo(40)
            }
 
        }

    }
    

