//
//  ViewController.swift
//  Unify
//
//  Created by Zach Strenfel on 5/8/17.
//  Copyright © 2017 Zach Strenfel. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    
    
    @IBOutlet weak var captureButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkPermissions()

        let discorySession = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .front)
        let devices: [AVCaptureDevice] = (discorySession?.devices)!
        captureDevice = devices.first
//        captureSession.addInput(<#T##input: AVCaptureInput!##AVCaptureInput!#>)
    }
    
    func checkPermissions() {
        let mediaType = AVMediaTypeVideo
        let authorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: mediaType)
        if authorizationStatus == .notDetermined {
            AVCaptureDevice.requestAccess(forMediaType: mediaType) { granted in
                print(granted)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func captureClicked(_ sender: UIButton) {

        
    }

}

