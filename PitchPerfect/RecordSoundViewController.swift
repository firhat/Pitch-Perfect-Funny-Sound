//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by lembah7 on 11/18/16.
//  Copyright © 2016 ximply studio. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordLabel: UIButton!
    @IBOutlet weak var stopLabel: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    let alertController = UIAlertController(title: "Warning", message: "recording was not successful", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopLabel.isEnabled = false
        
        // Add action to alert
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func record(_ sender: Any) {
        // Set UI
        setUIState(isRecording: false, recordingText: "Recording in progress", isStop: true)
        
        // Get directory path
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        //print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    
    }
    
    @IBAction func stop(_ sender: Any) {
        // Set UI
        setUIState(isRecording: true, recordingText: "Tap to Record", isStop: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func setUIState(isRecording: Bool, recordingText: String, isStop: Bool){
        recordLabel.isEnabled   = isRecording
        recordingLabel.text     = recordingText
        stopLabel.isEnabled     = isStop
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else{
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL as URL!
        }
    }

}

