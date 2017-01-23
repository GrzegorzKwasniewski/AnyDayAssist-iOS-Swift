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
    
    var audioFileURL = NSURL()
    var navigationBar = UINavigationBar()
    var audioRecorder: AVAudioRecorder!
    
    // MARK: - View State

    override func viewDidLoad() {
        super.viewDidLoad()
        setObserverForChange()
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
        showAlertToSaveAudioNote(withTitle: "Save audio note?", withMessage: "You will lose this record permanently if You don't save it")
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
    
    // MARK: - Notifications
    
    func setObserverForChange() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(saveAudioNote(_:)),
            name: "saveAudioNote",
            object: nil)
        
    }
    
    func saveAudioNote(notification: NSNotification) {
        let audioNoteTitle = notification.object as! String
        CoreDataFunctions.sharedInstance.saveAudioTitleAndURL(audioNoteTitle, audioFileUrl: audioFileURL)
        showAlert(withTitle: "Full Success!", withMessage: "Audio note was saved!")
    }
}
