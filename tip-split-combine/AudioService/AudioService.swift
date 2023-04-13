//
//  AudioService.swift
//  tip-split-combine
//
//  Created by Milan Parađina on 13.04.2023..
//

import Foundation
import AVFoundation

protocol AudioPlayerService {
    func playSound()
}


final class DefaultAudioPlayer: AudioPlayerService {
    
    private var player: AVAudioPlayer?
    
    func playSound() {
        let path = Bundle.main.path(forResource: "click", ofType: "m4a")
        if let path = path {
            let url = URL(filePath: path)
            do {
                player = try AVAudioPlayer(contentsOf: url)
                print("playing sound")
                player?.play()
            } catch(let error) {
                print(error.localizedDescription)
            }
        } else {
            print("Could not get path")
        }
    }
}
