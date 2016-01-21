////
////  CameraVC.swift
////  LoveOrLeave
////
////  Created by Rajan Khattri on 8/13/15.
////  Copyright (c) 2015 Rajan Khattri. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//
//class CameraVC: UIViewController {
//    var topBarView: UIView!
//    var btnCancel: UIButton!
//    
//    var previewView: UIView!
//    var gridView: GridView?
//    var capturedImage: UIImage!
//    
//    var cameraControlView: UIView!
//    var btnGridSwitch: UIButton!
//    var btnFlash: UIButton!
//    var btnTimer: UIButton!
//    
//    var bottomBarView: UIView!
//    var btnGallery: UIButton!
//    var btnTakePhoto: UIButton!
//    var lblCameraButtonRing: UILabel!
//    var btnSwitchCamera: UIButton!
//    
//    var isFrontCamera: Bool = true
//    var captureSession: AVCaptureSession?
//    var stillImageOutput: AVCaptureStillImageOutput?
//    var previewLayer: AVCaptureVideoPreviewLayer?
//    
//    var flashMode: AVCaptureFlashMode?
//    var rearCamera: AVCaptureDevice?
//    
//    var isDoubleMode: Bool = false
//    
//    //MARK: Private Utility Methods
//    
//    private func showPermissionAlert() {
//        let appName = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String
//        let message = "In order to take image from camera, go to Setting/Privacy/Camera set 'On' for \(appName)"
////        if #available(iOS 8.0, *) {
//            let alertController = UIAlertController(title: "Camera access disabled", message: message, preferredStyle: .Alert)
//            
//            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
//            alertController.addAction(cancelAction)
//            
//            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
//                UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!)
//            }
//            alertController.addAction(openAction)
//            
//            self.presentViewController(alertController, animated: true, completion: nil)
////        } else {
////            let locationAlertView = UIAlertView(title: "Camera access disabled", message: message, delegate: self, cancelButtonTitle: "Open Settings")
////            locationAlertView.addButtonWithTitle("Cancel")
////            locationAlertView.show()
////        }
//    }
//    
//    private func initializeSession() {
//        captureSession?.stopRunning()
//        previewLayer?.removeFromSuperlayer()
//        gridView?.removeFromSuperview()
//        cameraControlView.removeFromSuperview()
//
//        captureSession = AVCaptureSession()
//        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
//        
//        let devices = AVCaptureDevice.devices()
//        var frontCamera: AVCaptureDevice!
//        
//        for device in devices {
//            if device.hasMediaType(AVMediaTypeVideo) {
//                if device.position == .Back {
//                    rearCamera = device as? AVCaptureDevice
//                } else {
//                    frontCamera = device as! AVCaptureDevice
//                }
//            }
//        }
//        var input: AnyObject?
//        var error: NSError?
//        if !isFrontCamera {
//            do {
//                input = try AVCaptureDeviceInput(device: rearCamera)
//            } catch let error1 as NSError {
//                error = error1
//                input = nil
//            }
//        } else {
//            do {
//                input = try AVCaptureDeviceInput(device: frontCamera)
//            } catch let error1 as NSError {
//                error = error1
//                input = nil
//            }
//        }
//        if error == nil && captureSession!.canAddInput(input as! AVCaptureInput) {
//            captureSession!.addInput(input as! AVCaptureInput)
//            
//            stillImageOutput = AVCaptureStillImageOutput()
//            stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
//            if captureSession!.canAddOutput(stillImageOutput) {
//                captureSession!.addOutput(stillImageOutput)
//                
//                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//                previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
//                previewLayer!.connection?.videoOrientation = .Portrait
//                previewLayer!.frame = self.previewView.bounds
//                previewView.layer.addSublayer(previewLayer!)
//                
//                previewView.addSubview(self.gridView!)
//                previewView.addSubview(self.cameraControlView)
//                captureSession!.startRunning()
//            }
//        } else {
//            self.showPermissionAlert()
//        }
//    }
//    
//    //MARK: UIViewController life cycle
//    
//    override func loadView() {
//        super.loadView()
//        
//        self.topBarView = UIView()
//        self.topBarView.backgroundColor = UIColor.buttonBackgroundColor()
//        self.view.addSubview(self.topBarView)
//        
//        self.btnCancel = UIButton(type: .Custom)
//        self.btnCancel.backgroundColor = UIColor.buttonBackgroundColor()
////        self.btnCancel.titleLabel?.font = UIFont.fontAwesomeOfSize(30)
//        self.btnCancel.setTitleColor(UIColor.primaryTextColor(), forState: .Normal)
////        self.btnCancel.setTitle(String.fontAwesomeIconWithName(.TimesCircleO), forState: .Normal)
//        self.btnCancel.addTarget(self, action: "btnCancelAction:", forControlEvents: .TouchUpInside)
//        self.topBarView.addSubview(self.btnCancel)
//        
//        self.previewView = UIView(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.width))
//        self.previewView.backgroundColor = UIColor.blackColor()
//        self.view.addSubview(self.previewView)
//        
//        gridView = GridView(frame: self.previewView.bounds)
//        gridView?.hidden = true
//        
//        self.cameraControlView = UIView()
//        self.cameraControlView.backgroundColor = UIColor.viewBackgroundColor()
//        self.cameraControlView.alpha = 0.4
//        
//        self.btnGridSwitch = UIButton(type: .Custom)
//        self.btnGridSwitch.backgroundColor = UIColor.redColor()
////        self.btnGridSwitch.titleLabel?.font = UIFont.fontAwesomeOfSize(28)
//        self.btnGridSwitch.setTitleColor(UIColor.primaryTextColor(), forState: .Normal)
////        self.btnGridSwitch.setTitle(String.fontAwesomeIconWithName(.Th), forState: .Normal)
//        self.btnGridSwitch.addTarget(self, action: "btnGridAction:", forControlEvents: .TouchUpInside)
//        self.cameraControlView.addSubview(self.btnGridSwitch)
//        
//        self.btnFlash = UIButton(type: .Custom)
//        self.btnFlash.backgroundColor = UIColor.redColor()
////        self.btnFlash.titleLabel?.font = UIFont.fontAwesomeOfSize(28)
//        self.btnFlash.setTitleColor(UIColor.primaryTextColor(), forState: .Normal)
////        self.btnFlash.setTitle(String.fontAwesomeIconWithName(.Flash), forState: .Normal)
//        self.btnFlash.addTarget(self, action: "btnFlashAction:", forControlEvents: .TouchUpInside)
//        self.cameraControlView.addSubview(self.btnFlash)
//        
//        self.btnTimer = UIButton(type: .Custom)
//        self.btnTimer.backgroundColor = UIColor.redColor()
////        self.btnTimer.titleLabel?.font = UIFont.fontAwesomeOfSize(28)
//        self.btnTimer.setTitleColor(UIColor.primaryTextColor(), forState: .Normal)
////        self.btnTimer.setTitle(String.fontAwesomeIconWithName(.Close), forState: .Normal)
//        self.btnTimer.addTarget(self, action: "btnTimerAction:", forControlEvents: .TouchUpInside)
//        self.cameraControlView.addSubview(self.btnTimer)
//        
//        self.bottomBarView = UIView()
//        self.bottomBarView.backgroundColor = UIColor.buttonBackgroundColor()
//        self.view.addSubview(self.bottomBarView)
//        
//        self.btnGallery = UIButton(type: .Custom)
//        self.btnGallery.backgroundColor = UIColor.redColor()
////        self.btnGallery.titleLabel?.font = UIFont.fontAwesomeOfSize(35)
//        self.btnGallery.setTitleColor(UIColor.primaryTextColor(), forState: .Normal)
////        self.btnGallery.setTitle(String.fontAwesomeIconWithName(.Image), forState: .Normal)
//        self.btnGallery.addTarget(self, action: "btnGalleryAction:", forControlEvents: .TouchUpInside)
//        self.bottomBarView.addSubview(self.btnGallery)
//        
//        self.btnTakePhoto = UIButton(type: .Custom)
//        self.btnTakePhoto.backgroundColor = UIColor.cameraButtonColor()
//        self.btnTakePhoto.addTarget(self, action: "didPressTakePhoto:", forControlEvents: .TouchUpInside)
//        self.bottomBarView.addSubview(self.btnTakePhoto)
//        
//        self.lblCameraButtonRing = UILabel()
//        self.lblCameraButtonRing.backgroundColor = UIColor.cameraButtonColor()
//        self.btnTakePhoto.addSubview(self.lblCameraButtonRing)
//        
//        self.btnSwitchCamera = UIButton(type: .Custom)
////        self.btnRotate.backgroundColor = UIColor.redColor()
////        self.btnSwitchCamera.titleLabel?.font = UIFont.fontAwesomeOfSize(28)
//        self.btnSwitchCamera.setTitleColor(UIColor.primaryTextColor(), forState: .Normal)
////        self.btnSwitchCamera.setTitle(String.fontAwesomeIconWithName(.RotateLeft), forState: .Normal)
//        self.btnSwitchCamera.addTarget(self, action: "btnRotateAction:", forControlEvents: .TouchUpInside)
//        self.bottomBarView.addSubview(self.btnSwitchCamera)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//    }
//    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.navigationBarHidden = true
//        self.initializeSession()
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        if let preLayer = previewLayer {
//            preLayer.frame = self.previewView.bounds
//        }
//        previewView.addSubview(gridView!)
//        self.previewView.addSubview(self.cameraControlView)
//        gridView?.hidden = true
//    }
//    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        let mainFrameSize = self.view.frame.size
//        var xOffset: CGFloat = 0
//        var yOffset: CGFloat = 20
//        
//        self.topBarView.frame = CGRect(x: xOffset, y: yOffset, width: mainFrameSize.width, height: 44)
//        self.btnCancel.frame = CGRect(x: 0, y: 2, width: 40, height: 40)
//        
//        yOffset += self.topBarView.frame.size.height
//        self.previewView.frame = CGRect(x: xOffset, y: yOffset, width: mainFrameSize.width, height: mainFrameSize.width)
////        self.previewLayer!.frame = CGRect(x: xOffset, y: 0, width: mainFrameSize.width, height: mainFrameSize.width)
//
//        yOffset = self.previewView.frame.size.height-44
//        self.cameraControlView.frame = CGRect(x: xOffset, y: yOffset, width: mainFrameSize.width, height: 44)
//        
//        xOffset = (mainFrameSize.width-140)/2
//        yOffset = 2
//        self.btnGridSwitch.frame = CGRect(x: xOffset, y: yOffset, width: 40, height: 40)
//        
//        xOffset += (self.btnGridSwitch.frame.size.width+10)
//        self.btnFlash.frame = CGRect(x: xOffset, y: yOffset, width: 40, height: 40)
//        
//        xOffset += (self.btnFlash.frame.size.width+10)
//        self.btnTimer.frame = CGRect(x: xOffset, y: yOffset, width: 40, height: 40)
//        
//        xOffset = 0
//        yOffset = self.previewView.frame.origin.y+self.previewView.frame.size.height
//        self.bottomBarView.frame = CGRect(x: xOffset, y: yOffset, width: mainFrameSize.width, height: mainFrameSize.height-yOffset)
//        
//        xOffset = 20
//        yOffset = (self.bottomBarView.frame.size.height-40)/2
//        self.btnGallery.frame = CGRect(x: xOffset, y: yOffset, width: 40, height: 40)
//        
//        self.btnTakePhoto.frame = CGRect(x: (self.bottomBarView.frame.size.width-80)/2, y: (self.bottomBarView.frame.size.height-80)/2, width: 80, height: 80)
////        self.btnTakePhoto.center = self.bottomBarView.center
//        self.btnTakePhoto.layer.cornerRadius = 6
//        
//        self.lblCameraButtonRing.frame = CGRect(x: 10, y: 10, width: 60, height: 60)
//        self.lblCameraButtonRing.clipsToBounds = true
//        self.lblCameraButtonRing.layer.cornerRadius = self.lblCameraButtonRing.frame.size.height/2
//        self.lblCameraButtonRing.layer.borderWidth = 5
//        self.lblCameraButtonRing.layer.borderColor = UIColor.buttonBackgroundColor().CGColor
//        
//        xOffset = mainFrameSize.width-60
//        self.btnSwitchCamera.frame = CGRect(x: xOffset, y: yOffset, width: 40, height: 40)
//    }
//    
//    //MARK: UIButtonAction
//    
//    func btnCancelAction(sender: UIButton) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    func btnGridAction(sender: UIButton) {
//        gridView!.hidden = !gridView!.hidden
//    }
//    
//    func btnFlashAction(sender: UIButton) {
//        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
//        do {
//            try device.lockForConfiguration()
//        } catch _ {
//        }
//        switch (self.flashMode!) {
//        case .Off:
//            self.flashMode = .On
////            self.btnFlash.setTitle(String.fontAwesomeIconWithName(.Flash), forState: .Normal)
//        case .On:
//            self.flashMode = .Auto
////            self.btnFlash.setTitle(String.fontAwesomeIconWithName(.Flash), forState: .Normal)
//        default:
//            self.flashMode = .Off
////            self.btnFlash.setTitle(String.fontAwesomeIconWithName(.Flash), forState: .Normal)
//        }
//        self.rearCamera?.flashMode = self.flashMode!
//    }
//    
//    func btnTimerAction(sender: UIButton) {
//        
//    }
//    
//    func didPressTakePhoto(sender: UIButton) {
//        
//        if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
//            videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
//            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
//                if (sampleBuffer != nil) {
//                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
//                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
//                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
//                    
//                    let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
//                    do {
//                        try captureDevice.lockForConfiguration()
//                    } catch _ {
//                    }
//                    self.flashMode = .Off
//                    self.rearCamera?.flashMode = self.flashMode!
//                    
//                    self.captureSession?.stopRunning()
//                    
//                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: .Right)
//                    self.capturedImage = image
//                    NSNotificationCenter.defaultCenter().postNotificationName("ImageSelected", object: nil, userInfo: ["image": self.capturedImage])
//                    self.dismissViewControllerAnimated(true, completion: nil)
//                }
//            })
//        }
//    }
//    
//    func btnGalleryAction(sender: UIButton) {
//        let imageSelctionVC = ImageSelectionVC()
//        imageSelctionVC.isDoubleMode = self.isDoubleMode
//        self.navigationController?.pushViewController(imageSelctionVC, animated: true)
//    }
//
//    func btnRotateAction(sender: UIButton) {
//        self.isFrontCamera = !self.isFrontCamera
//        self.initializeSession()
//    }
//
//    func didPressTakeAnother(sender: AnyObject) {
//        captureSession!.startRunning()
//    }
//}
