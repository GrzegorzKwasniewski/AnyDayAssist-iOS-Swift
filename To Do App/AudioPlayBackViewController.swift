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
    var audioEngine: AVAudioEngine? = AVAudioEngine()
    var audioPlayerNode: AVAudioPlayerNode? = AVAudioPlayerNode()
    var stopTimer: NSTimer? = NSTimer()
    var recordedAudioURL: NSURL!
    
    enum ButtonType: Int { case Slow=0, Fast, Chipmunk, Vader, Echo, Reverb}
    

    
    @IBAction func playSoundForButton(sender: UIButton){
        print("Play Sound Button Pressed")
        switch (ButtonType(rawValue: sender.tag)!) {
        case .Slow:
            playSound(rate: 0.5)
        case .Fast:
            playSound(rate: 1.5)
        case .Chipmunk:
            playSound(pitch: 1000)
        case .Vader:
            playSound(pitch: -1000)
        case .Echo:
            playSound(echo: true)
        case .Reverb:
            playSound(reverb: true)
        }
        
        configureUI(.Playing)
    }
    
    @IBAction func stopButtonPressed(sender: AnyObject){
        print("Stop Audio Button Pressed")
        stopAudio()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = audioURL[activeAudioNote!].valueForKey("audiourl") as! String
        recordedAudioURL = NSURL(string: url)
        setupAudio()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        configureUI(.NotPlaying)
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
