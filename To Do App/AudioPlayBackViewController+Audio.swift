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
        static let AudioFileError = "Audio File Error"
    }

    enum PlayingState { case Playing, NotPlaying }
    
    // MARK: Audio Functions
    
    func setupAudio() {
        do {
            player = try AVAudioPlayer(contentsOfURL: recordedAudioURL)
            player?.delegate = self
        } catch {
            showAlert(Alerts.AudioFileError, message: String(error))
        }
    }
    
    func playSound() {
        setupAudio()
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
    
    func updateTimeSlider() {
        _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(AudioPlayBackViewController.updateSlider), userInfo: nil, repeats: true)
    }
    
    func updateSlider() {
        timeSlider.value = Float(player!.currentTime)
    }
    
    // MARK: UI Functions
    
    func configureUI(playState: PlayingState) {
        switch(playState) {
        case .Playing:
            playButton.enabled = false
            stopButton.enabled = true
            pauseButton.enabled = true
        case .NotPlaying:
            playButton.enabled = true
            stopButton.enabled = false
            pauseButton.enabled = false
        }
    }
    
    // MARK: Alert Functions
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}










