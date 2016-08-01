//
//  AudioRecorderViewControllerExtension.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 01/08/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import AVFoundation

extension AudioRecorderViewController {

    func createRecordingSession() {
        
        let recordingTime = getRecordingTime()
        let audioFileTitle = "AudioNote_time_\(recordingTime)"
        let audioFileURL = createRecordFileURL(audioFileTitle)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(URL: audioFileURL, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        globalCoreDataFunctions.saveAudioTitleAndURL(audioFileTitle, audioFileUrl: audioFileURL)
        
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
        dateFormatter.dateFormat = "MMM-dd_HH:mm:ss"
        let recordingTime = dateFormatter.stringFromDate(currentDate)
        return recordingTime
        
    }


}
