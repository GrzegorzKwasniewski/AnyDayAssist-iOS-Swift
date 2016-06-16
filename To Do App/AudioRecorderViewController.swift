//
//  AudioRecorderViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 16/06/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import AVFoundation

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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        stopRecordingButton.enabled = false
    }
    
    func createRecordingSession() {
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(URL: createRecordFileURL("Some name"), settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func createRecordFileURL(fileName: String) -> NSURL {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = fileName
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        return filePath!
    }
    
    func getRecordingTime() -> String {
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = " MMM dd, yyyy, HH:mm:ss"
        let convertedDate = dateFormatter.stringFromDate(currentDate)
        return convertedDate
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
