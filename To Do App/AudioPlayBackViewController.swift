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

    var audioFile: AVAudioFile = AVAudioFile()
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
    }
    
    @IBOutlet var stopButton: UIButton!
    @IBAction func stopAudioNote(sender: AnyObject) {
        player?.stop()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(PlayingState.Playing)
        prepareAudioURL()
        setupAudio()
        playSound()
        updateTimeSlider()
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        timeSlider.maximumValue = Float((player?.duration)!)
    }
    
    func updateTimeSlider() {
        _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(AudioPlayBackViewController.updateScrubSlider), userInfo: nil, repeats: true)
    }
    
    func updateScrubSlider() {
        timeSlider.value = Float(player!.currentTime)
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
