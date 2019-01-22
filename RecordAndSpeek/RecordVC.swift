//
//  ViewController.swift
//  RecordAndSpeek
//
//  Created by Lucas Moraes on 22/01/19.
//  Copyright © 2019 LSolutions. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

final class RecordVC: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    var speechSynthesizer = AVSpeechSynthesizer()
    
    var recordSession = AVAudioSession.sharedInstance()
    var audioRecord: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var recordBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let rigthBarBtnItem = UIBarButtonItem(title: "Speek", style: UIBarButtonItem.Style.plain, target: self, action: #selector(startSpeech))
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = rigthBarBtnItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestUserPermissionForRecordAudio()
    }
    
    @IBAction func recordAction() {
        if audioRecord == nil {
            startRecord()
        } else {
            endRecord(isSuccess: true)
        }
    }
    
    @objc private func startSpeech() {
        
        let utterance = AVSpeechUtterance(string: self.textView.text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        speechSynthesizer.speak(utterance)
    }
    
    private func requestUserPermissionForRecordAudio() {
      
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
    }
    
    private func startRecord() {
        
        do {
            try recordSession.setCategory(AVAudioSession.Category.playAndRecord,
                                          mode: AVAudioSession.Mode.default,
                                          options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            
            try recordSession.setActive(true,
                                        options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
            
            let url = getUrl()
            
            print("AbsoluteString")
            print(url.absoluteString)
            print("AbsoluteURL")
            print(url.absoluteURL)
            
            let setting = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                           AVSampleRateKey: 44100,
                           AVNumberOfChannelsKey: 2,
                           AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            audioRecord =  try AVAudioRecorder(url: url, settings: setting)
            audioRecord.delegate = self
            audioRecord.record()
            self.recordBtn.setTitle("Stop Record", for: UIControl.State.normal)
            
        } catch {
            debugPrint("Something went wrong with requesting the authorization" + error.localizedDescription)
        }
    }
    
    private func endRecord(isSuccess: Bool) {
        
        audioRecord.stop()
        audioRecord = nil
        
        if isSuccess {
            self.recordBtn.setTitle("Record Again", for: UIControl.State.normal)
            updateTextViewText()
        } else {
            AlertService.displayDefaultMessage(in: self, title: "Alerta", message: "An Error occurred while recording your audio")
        }
    }
    
    
    
    /// Domuments
    private func getDocumentDirectory() -> URL {
        let path = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        let documentsDirectory = path[0]
        return documentsDirectory
    }
    
    private func getUrl() -> URL {
        return getDocumentDirectory().appendingPathComponent("audioRecorded.m4a")
    }

    /// TextView
    private func updateTextViewText() {
        let url = getDocumentDirectory().appendingPathComponent("audioRecorded.m4a")
        SFSpeechRecognizer.requestAuthorization { [weak self] (status) in
            guard let vc = self else { return }
            let recognizer = SFSpeechRecognizer()
            let requestRecognizer = SFSpeechURLRecognitionRequest(url: url)
            
            recognizer?.recognitionTask(with: requestRecognizer, resultHandler: { (result, error) in
                if error != nil {
                    AlertService.displayDefaultMessage(in: vc, title: "Alert", message: "Error occorred during writing the text")
                } else {
                    vc.textView.text = result?.bestTranscription.formattedString
                }
            })
        }
    }
}


