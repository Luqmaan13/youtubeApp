//
//  PlayViewController.swift
//  QuickstartApp
//
//  Created by Luqmaan Siddiqui on 7/7/18.
//  Copyright © 2018 Luqmaan Siddiqui. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
class PlayViewController: UIViewController, YTPlayerViewDelegate {

    var x = CGFloat()
    var y = CGFloat()
    var width = CGFloat()
    var height = CGFloat()
    let videoPlayerView = YTPlayerView()
    var vidId = String()
    let backButton = UIButton()
  //  let playerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.gray
        
       // view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 500)
        self.view.backgroundColor = UIColor.white
        videoPlayerView.frame = CGRect(x: x, y: UIApplication.shared.keyWindow!.safeAreaInsets.top, width: width, height: height)
        backButton.frame = CGRect(x: 0, y: videoPlayerView.frame.maxY+20, width: view.frame.width, height: 20)
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(cancelButton), for: .touchUpInside)
        backButton.backgroundColor = UIColor.red
        view.addSubview(backButton)
        view.addSubview(videoPlayerView)
        videoPlayerView.delegate = self
        backButton.isHidden = true
        let playerVars = ["playsinline": 1]
        self.videoPlayerView.load(withVideoId: vidId, playerVars: playerVars)
       
    }

    @objc func cancelButton(){
        presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView!) {
        backButton.isHidden = false
        playerView.playVideo()
    }

    

}
