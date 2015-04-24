//
//  ViewController.swift
//  MyLifelogByLumu
//
//  Created by ucuc on 4/24/15.
//  Copyright (c) 2015 ucuc. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LumuManagerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NSLog("viewDidLoad");
        var lm = LumuManager.sharedManager()
        lm.delegate = self
        lm.startLumuManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func lumuManagerDidStartLumu() {
        NSLog("Start");
    }
    
    func lumuManagerDidRecognizeLumu() {
        NSLog("Recognized");
    }
    
    func lumuManagerDidNotRecognizeLumu() {
        NSLog("Not recognized");
    }
    
    func lumuManagerDidNotGetRecordPermission() {
        NSLog("No record permission");
    }

    func lumuManagerDidReceiveData(value: CGFloat) {
        NSLog("lumu Manager Did ReceiveData %f", value);
    }

    func lumuManagerDidStopLumu() {
        NSLog("lumu Manager Did Stop Lumu");
    }
}

