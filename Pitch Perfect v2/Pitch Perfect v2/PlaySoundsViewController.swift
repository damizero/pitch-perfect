//
//  PlaySoundsViewController.swift
//  Pitch Perfect v2
//
//  Created by Forlì Damiano on 3/26/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var audioPlayer2:AVAudioPlayer!
    var audioPlayer3:AVAudioPlayer!
    var audioPlayer4:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var reverbPlayers:[AVAudioPlayer] = []
    let N:Int = 10
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    @IBOutlet weak var playSlowButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioPlayer2 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer2.enableRate = true
        
        audioPlayer3 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer3.enableRate = true
        
        audioPlayer4 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer4.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        for i in 0...N {
            var temp = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
            reverbPlayers.append(temp)}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func playSlowAudio(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.rate = 0.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.rate = 1.5
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }

    @IBAction func playReverbAudio(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        let delay:NSTimeInterval = 0.02
        for i in 0...N {
            var curDelay:NSTimeInterval = delay*NSTimeInterval(i)
            var player:AVAudioPlayer = reverbPlayers[i]
            var exponent:Double = -Double(i)/Double(N/2)
            var volume = Float(pow(Double(M_E), exponent))
            player.volume = volume
            player.playAtTime(player.deviceCurrentTime + curDelay)
        }}
    
    @IBAction func playEchoAudio(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.currentTime = 0;
        audioPlayer.play()
        
        let delay:NSTimeInterval = 0.1
        var playtime:NSTimeInterval
        playtime = audioPlayer2.deviceCurrentTime + delay
        audioPlayer2.stop()
        audioPlayer2.currentTime = 0
        audioPlayer2.volume = 0.8;
        audioPlayer2.playAtTime(playtime)
        
        let delay2:NSTimeInterval = 0.2
        var playtime2:NSTimeInterval
        playtime2 = audioPlayer3.deviceCurrentTime + delay2
        audioPlayer3.stop()
        audioPlayer3.currentTime = 0
        audioPlayer3.volume = 0.6;
        audioPlayer3.playAtTime(playtime2)
        
        let delay3:NSTimeInterval = 0.3
        var playtime3:NSTimeInterval
        playtime3 = audioPlayer2.deviceCurrentTime + delay3
        audioPlayer4.stop()
        audioPlayer4.currentTime = 0
        audioPlayer4.volume = 0.4;
        audioPlayer4.playAtTime(playtime3)
    }
    
    @IBAction func playChipMunk(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVader(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func stopAudioPlayer(sender: AnyObject) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

    @IBAction func pauseAudioPlayer(sender: UIButton) {
        audioPlayer.pause()
    }
    
    @IBAction func restartAudioPlayer(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
}
