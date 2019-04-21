//
//  youtubeController.swift
//  GloboRewards
//
//  Created by Carlos Doki on 21/04/19.
//  Copyright © 2019 Carlos Doki. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class youtubeController: UIViewController, YTPlayerViewDelegate {
    
    @IBOutlet var video: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        video.delegate = self
        video.load(withVideoId: "LBolKaA4DQ8", playerVars: ["playsinline": 1])
        
        // Do any additional setup after loading the view.
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoExitFullScreen:) name:UIWindowDidBecomeVisibleNotification object:self.view.window];
        NotificationCenter.default.addObserver(self, selector: "videoExitFullScreen:", name: UIWindow.didBecomeVisibleNotification,object:self.view.window)
        
        video.playVideo()
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        video.playVideo()
    }

    override func viewDidAppear(_ animated: Bool) {
        print("Inicio")
    }
    
    func videoExitFullScreen() {
        print("saiu")
    }
}
