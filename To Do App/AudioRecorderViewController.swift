//
//  AudioRecorderViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 16/06/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class AudioRecorderViewController: UIViewController, AVAudioRecorderDelegate, UIMaker, UIAlertMaker {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var stopRecordingButton: UIButton!
    
    @IBAction func recordAudio(sender: AnyObject) {
        recordButton.enabled = false
        stopRecordingButton.enabled = true
        createRecordingSession()
        getRecordingTime()        
    }
    
    @IBAction func stopRecordingAudio(sender: AnyObject) {
        recordButton.enabled = true
        stopRecordingButton.enabled = false
        stopRecordnigSession()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        setUI()
    }
    
    func setUI() {
        stopRecordingButton.enabled = false
        setView()
        setNavigationBar(forClassWithName: String(AudioRecorderViewController.self))
    }
 }
