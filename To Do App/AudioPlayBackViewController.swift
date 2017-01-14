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
    
    // MARK: - UI
    
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    // MARK: - Properties

    var stopTimer: NSTimer = NSTimer()
    var recordedAudioURL: NSURL!
    var player: AVAudioPlayer = AVAudioPlayer()

    // MARK: - View State
    
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
    
    // MARK: - Custom Functions
    
    @IBAction func adjustVolume(sender: AnyObject) {
        player.volume = volumeSlider.value
    }
    
    @IBAction func searchInAudioNote(sender: AnyObject) {
        player.currentTime = NSTimeInterval(timeSlider.value)
    }
    
    @IBAction func playAudioNote(sender: AnyObject) {
        player.play()
        configureUI(PlayingState.Playing)
    }
    
    @IBAction func stopAudioNote(sender: AnyObject) {
        player.stop()
        setupAudio()
        timeSlider.value = Float(player.currentTime)
        configureUI(PlayingState.NotPlaying)
    }
    
    @IBAction func pauseAudio(sender: AnyObject) {
        player.pause()
        configureUI(PlayingState.NotPlaying)
    }
    
    func returnToAudioNotes() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func setUI() {
        setView()
        setNavigationBar(forClassWithName: String(AudioPlayBackViewController.self))
    }
}
