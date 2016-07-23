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
    
    var horizontalClass: UIUserInterfaceSizeClass!
    var verticalCass: UIUserInterfaceSizeClass!

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
        updateTimeSlider()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        playSound()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        setUI()
        timeSlider.maximumValue = Float((player?.duration)!)
        
    }
    
    func returnToAudioNotes() {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    func setUI() {
        
        horizontalClass = self.traitCollection.horizontalSizeClass;
        verticalCass = self.traitCollection.verticalSizeClass;
        
        setView()
        setNavigationBar()
        
    }
    
    func setView() {
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        imageView.image = UIImage(named: "bg.jpg")
        
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        
    }
    
    func setNavigationBar() {
        
        var fontSize: CGFloat!
        var yPosition: CGFloat!
        
        var navigationBar = UINavigationBar()
        let navigationItem = UINavigationItem()
        
        let leftItem = UIBarButtonItem(title: "< Back", style: .Plain, target: nil, action: #selector(returnToAudioNotes))
        
        if horizontalClass == .Regular && verticalCass == .Regular {
            
            fontSize = 30
            yPosition = 40
            
        } else {
            
            fontSize = 17
            yPosition = 20
            
        }
        
        navigationBar = UINavigationBar(frame: CGRectMake( 0, yPosition, self.view.frame.size.width, 40))
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationBar.shadowImage = UIImage()
        navigationBar.translucent = true
        navigationBar.backgroundColor = UIColor.clearColor()
        
        leftItem.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica Neue", size: fontSize)!], forState: UIControlState.Normal)
        leftItem.tintColor = UIColor.whiteColor()
        
        navigationItem.leftBarButtonItem = leftItem
        navigationBar.items = [navigationItem]
        
        view.addSubview(navigationBar)

    }
}
