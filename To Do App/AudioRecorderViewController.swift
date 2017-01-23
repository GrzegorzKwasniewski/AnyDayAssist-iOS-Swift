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
    
    // MARK: - UI
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    // MARK: - Properties
    
    var navigationBar = UINavigationBar()
    var audioRecorder: AVAudioRecorder!
    
    // MARK: - View State

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        setUI()
    }
    
    // MARK: - Custom Functions
    
    @IBAction func recordAudio(sender: AnyObject) {
        recordButton.enabled = false
        stopRecordingButton.enabled = true
        createRecordingSession()
        getRecordingTime()
        setNavigationBarVisibility(false)
    }
    
    @IBAction func stopRecordingAudio(sender: AnyObject) {
        recordButton.enabled = true
        stopRecordingButton.enabled = false
        stopRecordnigSession()
        setNavigationBarVisibility(true)
    }
    
    func setUI() {
        stopRecordingButton.enabled = false
        setView()
        navigationBar = setNavigationBar(forClassWithName: String(AudioRecorderViewController.self))
    }
    
    func setNavigationBarVisibility(visible: Bool) {
        if visible {
            navigationBar.userInteractionEnabled = true
            UIView.animateWithDuration(0.4) {
                self.navigationBar.alpha = 1
            }
        } else {
            navigationBar.userInteractionEnabled = false
            UIView.animateWithDuration(0.4) {
                self.navigationBar.alpha = 0
            }
        }
    }
 }
