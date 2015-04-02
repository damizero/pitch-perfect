//
//  RecordSoundsViewController.swift
//  Pitch Perfect v2
//
//  Created by Forlì Damiano on 3/26/15.
//  Copyright (c) 2015 GE. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var MicButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var RecordingInProgress: UILabel!
    @IBOutlet weak var Tap: UILabel!
    @IBOutlet weak var Welcome: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var paused: UILabel!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RecordingInProgress.hidden = true
        Tap.hidden = false
        Welcome.hidden = false
        pauseButton.hidden = true
        continueButton.hidden = true
        paused.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
    }
    
    @IBAction func Record(sender: UIButton) {
        RecordingInProgress.hidden = false
        stopButton.hidden = false
        MicButton.enabled = false
        pauseButton.hidden = false
        paused.hidden = true
        Tap.hidden = true
        Welcome.hidden = true
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func pauseRecord(sender: UIButton) {
        audioRecorder.pause()
        continueButton.hidden = false
        pauseButton.hidden = true
        paused.hidden = false
        RecordingInProgress.hidden = true
    }
    
    @IBAction func continueRecord(sender: UIButton) {
        audioRecorder.record()
        continueButton.hidden = true
        pauseButton.hidden = false
        paused.hidden = true
        RecordingInProgress.hidden = false
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag){
            recordedAudio = RecordedAudio(filePathUrl:recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else{
            println("Recording was not successful")
            MicButton.enabled = true
            stopButton.hidden = true
            Tap.hidden = false
            Welcome.hidden = false
            paused.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio!
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        RecordingInProgress.hidden = true
        MicButton.enabled = true
        stopButton.hidden = true
        pauseButton.hidden = true
        continueButton.hidden = true
        Tap.hidden = false
        Welcome.hidden = false
        paused.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
}