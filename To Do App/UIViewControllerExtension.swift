//
//  UIViewControllerExtension.swift
//  To Do App
//
//  Created by Grzegorz Kwaśniewski on 01/08/16.
//  Copyright © 2016 Grzegorz Kwaśniewski. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func returnToMainScreen() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func promptForNote() {
        performSegueWithIdentifier("textNoteDetail", sender: nil)
//        let popUpView = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("popUpView") as! PopUpViewController
//        self.addChildViewController(popUpView)
//        popUpView.view.frame = self.view.frame
//        self.view.addSubview(popUpView.view)
//        popUpView.didMoveToParentViewController(self)
    }
    
    func addNewPlaceToSee() {
        self.performSegueWithIdentifier("addNewPlaceToSee", sender: self)
    }
    
    func goToAudioRecordView() {
        self.performSegueWithIdentifier("goToAudioRecordView", sender: self)
    }
}