//
//  RehearsalViewController.swift
//  iPresentEasy
//
//  Created by Mohammad Sulthan on 02/08/21.
//

import UIKit
import AVFoundation
import CoreData

class RehearsalViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var playRecordingButton: UIButton!
    @IBOutlet weak var saveRecordingButton: UIButton!
    @IBOutlet weak var soundsRecordPlayStatusLabel: UILabel!
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var infoStatus = false
    var counter = 60.0
    var timer = Timer()
    
    var soundURL: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        startToPlay()
        microphoneAccess()
        
        stopRecordingButton.isEnabled = false
        playRecordingButton.isEnabled = false
        
        // Set the audio file
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFileName = UUID().uuidString + ".m4a"
        let audioFileURL = directoryURL.appendingPathComponent(audioFileName)
        soundURL = audioFileName     // Sound URL to be stored in CoreData
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
            print(directoryContents)

        } catch is NSError {
            print(NSError.self)
        }

        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playAndRecord)), mode: .default)
        } catch _ { }
        
        // Define the recorder setting
        let recorderSetting = [AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC as UInt32), AVSampleRateKey: 44100.0, AVNumberOfChannelsKey: 2 ]
        audioRecorder = try? AVAudioRecorder(url: audioFileURL, settings: recorderSetting)
        audioRecorder?.delegate = self
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.prepareToRecord()
        soundsRecordPlayStatusLabel.text = "Ready to Record"
    }
    
    
    @IBAction func recordingAction(_ sender: Any) {
        if let player = audioPlayer {
            if player.isPlaying {
                player.stop()
                recordingButton.isSelected = false
            }
        }
        
        if let recorder = audioRecorder {
            if !recorder.isRecording {
                print("record")
                let audioSession = AVAudioSession.sharedInstance()
                
                do {
                    try audioSession.setActive(true)
                } catch _ {}
                
                recorder.record()
                
                recordingButton.isSelected = true
                
                stopRecordingButton.isEnabled = true
                playRecordingButton.isEnabled = false
            } else {
                // pause recording
                print("Paused")
                recorder.pause()
                
                stopRecordingButton.isEnabled = false
                playRecordingButton.isEnabled = false
                recordingButton.isSelected = false
                
            }
        }
    }
    
    @IBAction func stopButtonAction(_ sender: Any) {
        recordingButton.isSelected = false
        playRecordingButton.isSelected = false
        
        stopRecordingButton.isEnabled = false
        playRecordingButton.isEnabled = true
        recordingButton.isEnabled = true
        
        if let recorder = audioRecorder {
            if recorder.isRecording {
                audioRecorder!.stop()
                
                let audioSession = AVAudioSession.sharedInstance()
                
                do {
                    try audioSession.setActive(false)
                } catch _ {}
            }
        }
        
        if let player = audioPlayer {
            if player.isPlaying {
                player.stop()
            }
        }
        
        saveRecordingButton.isEnabled = true
    }
    
    @IBAction func playButtonAction(_ sender: Any) {
        if let recorder = audioRecorder {
            if !recorder.isRecording {
                audioPlayer = try? AVAudioPlayer(contentsOf: recorder.url)
                audioPlayer?.delegate = self
                audioPlayer?.play()
                
                playRecordingButton.isSelected = true
                stopRecordingButton.isEnabled = true
                
                soundsRecordPlayStatusLabel.text = "Playing"
                
                recordingButton.isEnabled = false
            }
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Finish recording")
        if flag {
            soundsRecordPlayStatusLabel.text = "Recording completed"
            
            recordingButton.isEnabled = true
            playRecordingButton.isEnabled = true
            stopRecordingButton.isEnabled = false
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        soundsRecordPlayStatusLabel.text = "Playing completed"
        
        playRecordingButton.isSelected = false
        stopRecordingButton.isEnabled = false
        recordingButton.isEnabled = true
    }
    
    @IBAction func soundSaveButtonAction(_ sender: Any) {
        let soundsContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
        var _:String = "Sound_rekaman"
 
            // Set the audio recorder ready to record the next audio with a unique audioFileName
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] // as! NSURL
        print(directoryURL)
            
            let audioFileName = UUID().uuidString + ".m4a"
        let audioFileURL = directoryURL.appendingPathComponent(audioFileName)
            soundURL = audioFileName       // Sound URL to be stored in CoreData
            
            // Setup audio session
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playAndRecord)), mode: .default)
            } catch _ {
            }
            
            // Define the recorder setting
            let recorderSetting = [AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC as UInt32),
                                   AVSampleRateKey: 44100.0,
                                   AVNumberOfChannelsKey: 2 ]
            
            audioRecorder = try? AVAudioRecorder(url: audioFileURL, settings: recorderSetting)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.prepareToRecord()

    }
    
    
    func startToPlay() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
    }
    
    @objc func runTimer() {
            counter -= 1
            
            let flooredCounter = Int(floor(counter))
            let minute = flooredCounter / 60
            let minuteString = "0\(minute)"
            
            let second = flooredCounter % 60
            var secondString = "\(second)"
            
            if second < 10 {
                secondString = "0\(second)"
            }
            self.timerLabel.text = "\(minuteString):\(secondString)"
    }
    
    func microphoneAccess() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            print("Microphone permission granted")
            break
        case .undetermined:
            UIApplication.shared.sendAction(#selector(UIView.endEditing(_:)), to: nil, from: nil, for: nil)
            
            AVAudioSession.sharedInstance().requestRecordPermission({ (granted) in
                if granted {
                    print("Now granted")
                } else {
                    print("Permission not granted")
                }
            })
        case .denied:
            UIApplication.shared.sendAction(#selector(UIView.endEditing(_:)), to: nil, from: nil, for: nil)
            
            let alert = UIAlertController(title: "Microphone error!", message: "Rehearso is not authorized to access the microphone!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Permission denied", style: .default))
        @unknown default:
            print("Default")
        }
    }
}

// Helper function inserted by Swift migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}

// Helper function inserted by Swift migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
