//
//  ViewController.swift
//  Unify
//
//  Created by Zach Strenfel on 5/8/17.
//  Copyright © 2017 Zach Strenfel. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    let captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    var capturePhotoOutput: AVCapturePhotoOutput?
    var photoSampleBuffers: [CMSampleBuffer] = []
    var timer: Timer? = nil
    var pictureCount = 0
    var PICTURE_LIMIT = 10
    
    
    @IBOutlet weak var captureButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkPermissions()

        let discoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .front)
        let devices: [AVCaptureDevice] = (discoverySession?.devices)!
        guard let captureDevice = devices.first else { return }
            
        guard let connection = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        let photoOutput = AVCapturePhotoOutput()
        photoOutput.isHighResolutionCaptureEnabled = true
        photoOutput.isLivePhotoCaptureEnabled = photoOutput.isLivePhotoCaptureSupported
        
        guard self.captureSession.canAddInput(connection) else { return }
        guard self.captureSession.canAddOutput(photoOutput) else { return }
        
        self.captureSession.beginConfiguration()
        self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        self.captureSession.addInput(connection)
        self.captureSession.addOutput(photoOutput)
        self.captureSession.commitConfiguration()
        
        self.capturePhotoOutput = photoOutput
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession.isRunning) {
            captureSession.stopRunning()
        }
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
    
    func takePhoto() {
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        if (pictureCount < PICTURE_LIMIT - 1) {
            pictureCount += 1
            self.startTimer()
        }
        DispatchQueue.main.async {
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG])
            capturePhotoOutput.capturePhoto(with: settings, delegate: self);
        }
    }
    
    //MARK: - Photo Capture Delegate
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        guard error == nil else {
            print("something went wrong")
            return
        }
        self.photoSampleBuffers.append(photoSampleBuffer!)
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishCaptureForResolvedSettings resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        if (pictureCount == PICTURE_LIMIT - 1) {
            self.captureSession.stopRunning()
            print("done")
        }
        //save to keychain
        
    }
    
    
    func stopSession() {
        self.captureSession.stopRunning()
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.takePhoto), userInfo: nil, repeats: false)
    }
    
    @IBAction func captureClicked(_ sender: UIButton) {
        self.captureSession.startRunning()
        startTimer()
    }

}

