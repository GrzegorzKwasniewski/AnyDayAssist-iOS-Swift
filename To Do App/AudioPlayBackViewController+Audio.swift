//
//  AudioPlayBackViewController+Audio.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 29/06/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import AVFoundation

extension AudioPlayBackViewController: AVAudioPlayerDelegate {
    
    struct Alerts {
        static let DismissAlert = "Dismiss"
        static let RecordingDisabledTitle = "Recording Disabled"
        static let RecordingDisabledMessage = "You've disabled this app from recording your microphone. Check Settings."
        static let RecordingFailedTitle = "Recording Failed"
        static let RecordingFailedMessage = "Something went wrong with your recording."
        static let AudioRecorderError = "Audio Recorder Error"
        static let AudioSessionError = "Audio Session Error"
        static let AudioRecordingError = "Audio Recording Error"
        static let AudioFileError = "Audio File Error"
        static let AudioEngineError = "Audio Engine Error"
    }
    
    // raw values correspond to sender tags
    enum PlayingState { case Playing, NotPlaying }
    
    
    // MARK: Audio Functions
    
    func setupAudio() {
        
        // initialize (recording) audio file
        do {
            audioFile = try AVAudioFile(forReading: recordedAudioURL)
        } catch {
            showAlert(Alerts.AudioFileError, message: String(error))
        }
    }
    
    func playSound() {
        
        do {
            player = try AVAudioPlayer(contentsOfURL: recordedAudioURL)
            player?.delegate = self
        } catch {
            showAlert(Alerts.AudioFileError, message: String(error))
        }
        
        player?.play()

    }

    func prepareAudioURL() {
        let url = audioURL[activeAudioNote!].valueForKey("audiourl") as! String
        recordedAudioURL = NSURL(string: url)
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            configureUI(PlayingState.NotPlaying)
        }
    }
    
    
    // MARK: UI Functions
    
    func configureUI(playState: PlayingState) {
        switch(playState) {
        case .Playing:
            playButton.enabled = false
            stopButton.enabled = true
        case .NotPlaying:
            playButton.enabled = true
            stopButton.enabled = false
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
}










