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

class AudioRecorderViewController: UIViewController, AVAudioRecorderDelegate {
    
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
    
    func createRecordingSession() {
        
        let audioFielTitle = "AudioNote_nr_\(audioURL.count + 1)"
        let audioFileURL = createRecordFileURL(audioFielTitle)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(URL: audioFileURL, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        saveAudioTitleAndURL(audioFielTitle, audioFileUrl: audioFileURL)
        
    }
    
    func stopRecordnigSession() {
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    func createRecordFileURL(fileName: String) -> NSURL {
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let pathArray = [dirPath, fileName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        return filePath!
        
    }
    
    func getRecordingTime() -> String {
        
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = " MMM dd, yyyy, HH:mm:ss"
        let recordingTime = dateFormatter.stringFromDate(currentDate)
        return recordingTime
        
    }
    
    func saveAudioTitleAndURL(audioFileTitle: String , audioFileUrl: NSURL) {
        
        let audioNoteURL: String = audioFileUrl.path!
        let newAudioNote = NSEntityDescription.insertNewObjectForEntityForName("AudioNotes", inManagedObjectContext: contextOfOurApp)
        newAudioNote.setValue(audioFileTitle, forKey: "audiotitle")
        newAudioNote.setValue(audioNoteURL, forKey: "audiourl")
        
        do {
            
            try contextOfOurApp.save()
            
        } catch let error as NSError{
            
            print ("There was an error \(error), \(error.userInfo)")
            
        }
    }
    
    func returnToAudioNotes() {
        
        self.performSegueWithIdentifier("returnToAudioNotes", sender: self)
        
    }
    
    func setUI() {
        
        stopRecordingButton.enabled = false
        setView()
        setNavigationBar()
        
    }
    
    func setView() {
        
        let backgroundImage = UIImage(named: "bg.jpg")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .ScaleAspectFill
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)

    }
    
    func setNavigationBar() {
        
        let navigationbar = UINavigationBar(frame: CGRectMake( 0, 20, self.view.frame.size.width, 40))
        navigationbar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationbar.shadowImage = UIImage()
        navigationbar.translucent = true
        navigationbar.backgroundColor = UIColor.clearColor()
        let navigationItem = UINavigationItem()
        let leftItem = UIBarButtonItem(title: "< Back", style: .Plain, target: nil, action: #selector(returnToAudioNotes))
        navigationItem.leftBarButtonItem = leftItem
        navigationbar.items = [navigationItem]
        
        view.addSubview(navigationbar)
        

    }
}
