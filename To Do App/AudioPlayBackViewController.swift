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
    var recordedAudioURL = NSURL()
    var audioUrl: NSManagedObject?
    var player: AVAudioPlayer = AVAudioPlayer()
    var navigationBar = UINavigationBar()

    // MARK: - View State
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(PlayingState.NotPlaying)
        prepareAudioURL(withUrl: audioUrl!)
        setupAudio()
    }
    

    
    override func viewWillAppear(animated: Bool) {
        setUI()
    }
    
    // MARK: - Custom Functions
    
    @IBAction func adjustVolume(sender: AnyObject) {
        player.volume = volumeSlider.value
    }
    
    @IBAction func searchInAudioNote(sender: AnyObject) {
        player.currentTime = NSTimeInterval(timeSlider.value)
    }
    
    @IBAction func playAudioNote(sender: AnyObject) {
        updateTimeSlider()
        timeSlider.maximumValue = Float((player.duration))
        player.play()
        setNavigationBarVisibility(false)
        configureUI(PlayingState.Playing)
    }
    
    @IBAction func stopAudioNote(sender: AnyObject) {
        setNavigationBarVisibility(true)
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
