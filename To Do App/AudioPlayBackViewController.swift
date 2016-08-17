//
//  AudioPlayBackViewController.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 16/06/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class AudioPlayBackViewController: UIViewController, UIMaker {
    
    var horizontalClass: UIUserInterfaceSizeClass!
    var verticalCass: UIUserInterfaceSizeClass!

    var stopTimer: NSTimer = NSTimer()
    var recordedAudioURL: NSURL!
    var player: AVAudioPlayer = AVAudioPlayer()
    
    @IBOutlet var volumeSlider: UISlider!
    @IBAction func adjustVolume(sender: AnyObject) {
        
        player.volume = volumeSlider.value
        
    }
    
    @IBOutlet var timeSlider: UISlider!
    @IBAction func searchInAudioNote(sender: AnyObject) {
        
         player.currentTime = NSTimeInterval(timeSlider.value)
        
    }
    
    @IBOutlet var playButton: UIButton!
    @IBAction func playAudioNote(sender: AnyObject) {
        
        player.play()
        configureUI(PlayingState.Playing)
        
    }
    
    @IBOutlet var stopButton: UIButton!
    @IBAction func stopAudioNote(sender: AnyObject) {
        
        player.stop()
        setupAudio()
        timeSlider.value = Float(player.currentTime)
        configureUI(PlayingState.NotPlaying)
        
    }
    
    @IBOutlet var pauseButton: UIButton!
    @IBAction func pauseAudio(sender: AnyObject) {
        
        player.pause()
        configureUI(PlayingState.NotPlaying)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureUI(PlayingState.Playing)
        prepareAudioURL()
        setupAudio()
        updateTimeSlider()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        playSound()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        setUI()
        timeSlider.maximumValue = Float((player.duration))
        
    }
    
    func returnToAudioNotes() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    func setUI() {
        
        setView()
        setNavigationBar(forClassWithName: String(AudioPlayBackViewController.self))
        
    }
}
