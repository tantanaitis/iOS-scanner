//
//  ViewController.swift
//  eDoc
//
//  Created by Titas Antanaitis on 24/09/2017.
//  Copyright © 2017 T.Antanaitis. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var captureDeviceInput: AVCaptureDeviceInput!
    var photoOutput: AVCapturePhotoOutput!
    let imagePicker = UIImagePickerController()
    @IBOutlet var previewView: UIView!
    @IBOutlet var captureButton: UIButton!
    @IBOutlet var galleryButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var photo: UIImageView!
    
    @IBAction func captureImage() {
        dissableCaptureGalleryButtons()
        let settings = AVCapturePhotoSettings()
        
        photoOutput.capturePhoto(with: settings, delegate: self)
        enableSendBackButtons()
    }
    
    @IBAction func send() {
        
    }
    
    @IBAction func backToCamera() {
        dissableSendBackButtons()
        removePhotoOutput()
        enableCaptureGalleryButtons()
    }
    
    @IBAction func openGallery() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        imagePicker.delegate = self
        dissableSendBackButtons()
        styleCaptureButton()
        captureSession = AVCaptureSession()
        configureCameraPreviewView()
        configureCaptureDevice()
        configurePhotoOutput()
        captureSession.startRunning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            removePhotoOutput()
            photo.image = pickedImage
            view.insertSubview(photo, aboveSubview: previewView)
            dissableCaptureGalleryButtons()
            enableSendBackButtons()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?,
                 resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Swift.Error?) {
            
        if let buffer = photoSampleBuffer, let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: buffer, previewPhotoSampleBuffer: nil),
            let image = UIImage(data: data) {
            removePhotoOutput()
            photo.image = image
            view.insertSubview(photo, aboveSubview: previewView)
            
        }
    }
    
    func styleCaptureButton() {
        captureButton.layer.borderColor = UIColor.black.cgColor
        captureButton.layer.borderWidth = 2
        captureButton.layer.cornerRadius = min(captureButton.frame.width, captureButton.frame.height) / 2
    }
    
    func configureCameraPreviewView() {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer.frame = view.layer.bounds
        previewView.layer.addSublayer(videoPreviewLayer)
    }
    
    func configureCaptureDevice() {
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
        } catch {
            print(error)
        }
    }
    
    func configurePhotoOutput() {
        photoOutput = AVCapturePhotoOutput()
        photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG])], completionHandler: nil)
        captureSession.addOutput(photoOutput)
    }
    
    func removePhotoOutput() {
        view.willRemoveSubview(photo)
        photo.removeFromSuperview()
    }
    
    func dissableCaptureGalleryButtons() {
        captureButton.isHidden = true
        captureButton.isEnabled = false
        galleryButton.isHidden = true
        galleryButton.isEnabled = false
    }
    
    func enableCaptureGalleryButtons() {
        captureButton.isHidden = false
        captureButton.isEnabled = true
        galleryButton.isHidden = false
        galleryButton.isEnabled = true
    }
    
    func dissableSendBackButtons() {
        sendButton.isHidden = true
        sendButton.isEnabled = false
        backButton.isHidden = true
        backButton.isEnabled = false
    }
    
    func enableSendBackButtons() {
        sendButton.isHidden = false
        sendButton.isEnabled = true
        backButton.isHidden = false
        backButton.isEnabled = true
    }
}


