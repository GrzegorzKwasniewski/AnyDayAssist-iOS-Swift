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

class AudioPlayBackViewController: UIViewController {

    var stopTimer: NSTimer? = NSTimer()
    var recordedAudioURL: NSURL!
    var player: AVAudioPlayer? = AVAudioPlayer()
    
    @IBOutlet var volumeSlider: UISlider!
    @IBAction func adjustVolume(sender: AnyObject) {
        
        player?.volume = volumeSlider.value
        
    }
    
    @IBOutlet var timeSlider: UISlider!
    @IBAction func searchInAudioNote(sender: AnyObject) {
        
         player?.currentTime = NSTimeInterval(timeSlider.value)
        
    }
    
    @IBOutlet var playButton: UIButton!
    @IBAction func playAudioNote(sender: AnyObject) {
        
        player?.play()
        configureUI(PlayingState.Playing)
        
    }
    
    @IBOutlet var stopButton: UIButton!
    @IBAction func stopAudioNote(sender: AnyObject) {
        
        player?.stop()
        setupAudio()
        timeSlider.value = Float(player!.currentTime)
        configureUI(PlayingState.NotPlaying)
        
    }
    
    @IBOutlet var pauseButton: UIButton!
    @IBAction func pauseAudio(sender: AnyObject) {
        
        player?.pause()
        configureUI(PlayingState.NotPlaying)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configureUI(PlayingState.Playing)
        prepareAudioURL()
        setupAudio()
        playSound()
        updateTimeSlider()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        setUI()
        timeSlider.maximumValue = Float((player?.duration)!)
        
    }
    
    func returnToAudioNotes() {
        
        self.performSegueWithIdentifier("returnToAudioNotes", sender: self)
        
    }

    func setUI() {
        
        let backgroundImage = UIImage(named: "bg.jpg")
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .ScaleAspectFill
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        
        let navigationbar = UINavigationBar(frame: CGRectMake( 0, 20, self.view.frame.size.width, 40))
        navigationbar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationbar.shadowImage = UIImage()
        navigationbar.translucent = true
        navigationbar.backgroundColor = UIColor.clearColor()
        
        let navigationItem = UINavigationItem()
        let leftItem = UIBarButtonItem(title: "< Back", style: .Plain, target: nil, action: #selector(returnToAudioNotes))
        leftItem.tintColor = UIColor.whiteColor()
        
        navigationItem.leftBarButtonItem = leftItem
        navigationbar.items = [navigationItem]
        
        view.addSubview(navigationbar)
        
    }
}
