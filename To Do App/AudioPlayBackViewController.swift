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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = audioURL[activeAudioNote!].valueForKey("audiourl") as! String
        print(url)
        recordedAudioURL = NSURL(string: url)
        setupAudio()
        //playSound()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
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
