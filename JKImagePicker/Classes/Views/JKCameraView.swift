//
//  JKCameraView.swift
//
//
//  Created by James KUMAKO on 2/5/18.
//  Copyright © 2018 James KUMAKO. All rights reserved.
//

import UIKit
import AVFoundation


public protocol JKCameraViewDelegate {
  func didShootPhoto(image: UIImage)
}

class JKCameraView: UIView {
  
  typealias CameraShotCompletion = (UIImage?) -> Void
  
  @IBOutlet weak var capturePhoto: UIButton!
  
  var session : AVCaptureSession!
  var preview : AVCaptureVideoPreviewLayer!
  var imageOutput : AVCaptureStillImageOutput!
  var device: AVCaptureDevice!
  var input: AVCaptureDeviceInput!
  
  let cameraQueue = DispatchQueue(label: "com.JKICameraView.Queue.")
  public var currentPosition = AVCaptureDevice.Position.back
  
  var metadata = [String:AnyObject]()
  var delegate: JKCameraViewDelegate? = nil
  
  
  static func instance() -> JKCameraView {
    let view = UINib(nibName: "JKCameraView", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: self, options: nil)[0] as! JKCameraView
    return view
  }
  
  
  public func startSession() {
    
    self.layoutIfNeeded()
    
    session = AVCaptureSession()
    session.sessionPreset = AVCaptureSessionPresetPhoto
    device = cameraWithPosition(position: currentPosition)
    
    if let device = device , device.hasFlash {
      do {
        try device.lockForConfiguration()
        device.flashMode = .auto
        device.unlockForConfiguration()
      } catch _ {}
    }
    
    let outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
    
    do {
      input = try AVCaptureDeviceInput(device: device)
    } catch let error as NSError {
      input = nil
      print("Error: \(error.localizedDescription)")
      return
    }
    
    if session.canAddInput(input) {
      session.addInput(input)
    }
    
    imageOutput = AVCaptureStillImageOutput()
    imageOutput.outputSettings = outputSettings
    
    session.addOutput(imageOutput)
    
    cameraQueue.sync {
      session.startRunning()
      DispatchQueue.main.async() { [weak self] in
        self?.createPreview()
        //self?.rotatePreview()
      }
    }
    
    
  }
  
  private func createPreview() {
    
    preview = AVCaptureVideoPreviewLayer(session: session)
    preview?.videoGravity = AVLayerVideoGravityResizeAspectFill
    
    
    let previewFrameOrigin = CGPoint(x:0,y: 0)
    let previewFrameSize =  CGSize(width: bounds.size.width, height: bounds.size.width)
    preview?.frame = CGRect(origin:previewFrameOrigin , size: previewFrameSize)
    
    layer.addSublayer(preview!)
    self.layoutIfNeeded()
    print("createPreview")
    print("preview frame : \(preview.frame.size.width) \(preview.frame.size.height)")
  }
  
  public func rotatePreview() {
    
    guard preview != nil else {
      return
    }
    switch UIApplication.shared.statusBarOrientation {
    case .portrait:
      preview?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
      break
    case .portraitUpsideDown:
      preview?.connection?.videoOrientation = AVCaptureVideoOrientation.portraitUpsideDown
      break
    case .landscapeRight:
      preview?.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeRight
      break
    case .landscapeLeft:
      preview?.connection?.videoOrientation = AVCaptureVideoOrientation.landscapeLeft
      break
    default: break
    }
  }
  
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    preview?.frame = bounds
  }
  
  
  private func cameraWithPosition(position: AVCaptureDevicePosition) -> AVCaptureDevice? {
    
    guard let devices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo) as? [AVCaptureDevice] else {
      return nil
    }
    return devices.filter { $0.position == position }.first
    
  }
  
  @IBAction func loop(_ sender: Any) {
  }
  
  @IBAction func shootPhoto(_ sender: Any) {
    
    guard let connection = imageOutput.connection(withMediaType: AVMediaTypeVideo) else {
        return
    }
    
    DispatchQueue.global(qos: .default).async(execute: { () -> Void in
      
      //let videoConnection = imageOutput.connection(withMediaType: AVMediaTypeVideo)
      
      self.imageOutput.captureStillImageAsynchronously(from: connection) { (buffer, error) -> Void in
        
        //self.stopCamera()
        
        guard let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer),
          let image = UIImage(data: data),
          let cgImage = image.cgImage,
          let delegate = self.delegate,
          let videoLayer = self.preview else {
            
            return
        }
        
        let rect   = videoLayer.metadataOutputRectOfInterest(for: videoLayer.bounds)
        let width  = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        
        let cropRect = CGRect(x: rect.origin.x * width,
                              y: rect.origin.y * height,
                              width: rect.size.width * width,
                              height: rect.size.height * height)
        
        guard let img = cgImage.cropping(to: cropRect) else {
          
          return
        }
        
        let croppedUIImage = UIImage(cgImage: img, scale: 1.0, orientation: image.imageOrientation)
        
        DispatchQueue.main.async(execute: { () -> Void in
          
          delegate.didShootPhoto(image: croppedUIImage)
          
          self.saveImageToCameraRoll(image: croppedUIImage)
          
          
        })
      }
    })
    
    
    /*
    if connection.isEnabled {
      //toggleButtons(enabled: false)
      self.capturePhoto { [weak self] image in
        guard let image = image else {
          //self?.toggleButtons(enabled: true)
          return
        }
        self?.delegate?.didShotPhoto(image: image, metaData: [String : Any]())
        //self?.saveImage(image: image)
      }
    }
     */
    
  }
  
  @IBAction func flashAction(_ sender: Any) {
    
  }
  
  
  

}
