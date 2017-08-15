//
//  ViewController.swift
//  Texcoder
//
//  Created by Nishanth P on 1/7/17.
//  Copyright © 2017 Nishapp. All rights reserved.
//

import UIKit
import Speech

var nsdefaults = UserDefaults.standard

@available(iOS 10.0, *)
class siriViewController: UIViewController,SFSpeechRecognizerDelegate {

    @IBOutlet weak var messTextView: UITextView!
    
    @IBOutlet weak var mpImage: UIImageView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    
    
    var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier:"zh-tw"))
    var recognitionRequest : SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    
    
    
    @IBAction func back(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        print("Back")
    }
   
    @IBAction func save(_ sender: Any) {
        
        let text = messTextView.text
        
    if let messages = nsdefaults.object(forKey: "textMess") as? [String]
    {
        
        var array: [String] = [String]()
        array = messages 
        array.append(text!)
        nsdefaults.set(array,forKey:"textMess")
        print("Saved")
        dismiss(animated: true, completion: nil)
    }else{
        var array: [String] = [String]()
        array.append(text!)
        nsdefaults.set(array,forKey:"textMess")
        
        }
    }
    @IBAction func recordButton(_ sender: Any) {
        
        if audioEngine.isRunning{
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recordButton.setTitle("Start", for: .normal)
            mpImage.image = UIImage(named: "siri.png")
            endRecording()
            
        }else{
            startRecording()
            recordButton.setTitle("Stop", for: .normal)
            mpImage.image = UIImage(named: "siriRed.png")
            
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        recordButton.isEnabled = false
        askPermission()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func askPermission() {
        
        recordButton.isEnabled = false
        
        speechRecognizer?.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.recordButton.isEnabled = isButtonEnabled
            }
        }
        
    }
    
    
    func startRecording() {
        
        messTextView.text = "I am listening! Start Talking!"
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.messTextView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.recordButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
    }
    
    
    func endRecording() {
        
        if messTextView.text.isEmpty || messTextView.text == "I am listening! Start Talking!" {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    
    @available(iOS 10.0, *)
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        
        if available {
            recordButton.isEnabled = true
        } else {
            recordButton.isEnabled = false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

