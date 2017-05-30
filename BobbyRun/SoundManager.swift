//
//  SoundManager.swift
//  BobbyRun
//
//  Created by ChenQianPing on 16/6/7.
//  Copyright © 2016年 ChenQianPing. All rights reserved.
//

import SpriteKit
import AVFoundation   // 引入多媒体框架

class SoundManager :SKNode {
    
    var bgMusicPlayer = AVAudioPlayer()   // 申明一个播放器
    
    // 播放点击的动作音效
    let jumpAct = SKAction.playSoundFileNamed("jump_from_platform.mp3", waitForCompletion: false)
    let loseAct = SKAction.playSoundFileNamed("lose.mp3", waitForCompletion: false)
    let rollAct = SKAction.playSoundFileNamed("hit_platform.mp3", waitForCompletion: false)
    let eatAct = SKAction.playSoundFileNamed("hit.mp3", waitForCompletion: false)
    
    // 播放背景音乐的音效
    func playBackgroundMusic() {
        // 获取apple.mp3文件地址
        let bgMusicURL:URL =  Bundle.main.url(forResource: "do-re-mi", withExtension: "mp3")!
        // 根据背景音乐地址生成播放器
        bgMusicPlayer = try! AVAudioPlayer(contentsOf: bgMusicURL)
        bgMusicPlayer.numberOfLoops = -1   // 设置为循环播放
        bgMusicPlayer.prepareToPlay()      // 准备播放音乐
        bgMusicPlayer.play()               // 播放音乐
    }
    
    func stopBackgroundMusic() {
        if bgMusicPlayer.isPlaying {
            bgMusicPlayer.stop()
        }
    }
    
    func playDead() {
        self.run(loseAct)
    }
    
    func playJump() {
        self.run(jumpAct)
    }
    
    func playRoll() {
        self.run(rollAct)
    }
    
    func playEat() {
        self.run(eatAct)
    }
    
}
