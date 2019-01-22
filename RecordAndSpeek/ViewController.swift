//
//  ViewController.swift
//  RecordAndSpeek
//
//  Created by Lucas Moraes on 22/01/19.
//  Copyright © 2019 LSolutions. All rights reserved.
//

import UIKit
import AVFoundation

class RecordVC: UIViewController {

    var speechSynthesizer = AVSpeechSynthesizer()
    
    var recordSession = AVAudioSession.sharedInstance()
    var audioRecord: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var recordBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestUserPermissionForRecordAudio()
    }
    
    @IBAction func recordAction() {
        
    }
    
    private func requestUserPermissionForRecordAudio() {
        do {
            
            try recordSession.setCategory(AVAudioSession.Category.playAndRecord,
                                          mode: AVAudioSession.Mode.default,
                                          options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            
            try recordSession.setActive(true,
                                        options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
            
            recordSession.requestRecordPermission { [weak self] (isAllowed) in
                guard let vc = self else { return }
                if isAllowed {
                    DispatchQueue.main.async {
                        vc.recordBtn.setTitle("Stat Record", for: UIControl.State.normal)
                    }
                } else {
                    AlertService.displayDefaultMessage(in: vc, title: "Error", message: "Something went worng with you Audio. Just try againg")
                }
            }
        } catch {
            debugPrint("Something went wrong with requesting the authorization" + error.localizedDescription)
        }
    }
    
    private func startRecord() {
        
    }
    
    private func endRecord() {
        
    }
    
    private func startSpeech(with text: String) {
        
    }
    
    


}

extension RecordVC

