//
//  music.swift
//  Login
//
//  Created by 林湘羚 on 2021/5/22.
//

import AVFoundation
import UIKit

extension AVPlayer {
    static var bgQueuePlayer = AVQueuePlayer()
    static var bgPlayerLooper: AVPlayerLooper!
    
//    static let sharedCorrectPlayer: AVPlayer = {
//        guard let url = Bundle.main.url(forResource: "bensound-funnysong", withExtension: "mp3") else{
//            fatalError("failed to find sound file.")
//        }
//        return AVPlayer(url: url)
//    }()
    
    func playFromStart(){
        seek(to: .zero)
        play()
    }
    static func setupBgMusic() {
        guard let url = Bundle.main.url(forResource: "bensound-funnysong", withExtension: "mp3") else { fatalError("Failed to find sound file.")}
        let item = AVPlayerItem(url: url)
        bgPlayerLooper = AVPlayerLooper(player: bgQueuePlayer, templateItem: item)
    }
}

