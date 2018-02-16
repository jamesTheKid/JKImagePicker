//
//  JKCameraView+Additions.swift
//   
//
//  Created by James KUMAKO on 2/5/18.
//  Copyright © 2018 Fahid Attique. All rights reserved.
//


import Foundation
import Photos

extension JKCameraView {
  
  func capturePhoto(completion: @escaping CameraShotCompletion) {
    isUserInteractionEnabled = false
    
    guard let output = imageOutput, let orientation = AVCaptureVideoOrientation(rawValue: UIDevice.current.orientation.rawValue) else {
      completion(nil)
      return
    }
    
    let size = preview?.frame.size
     cameraQueue.sync {
      takePhoto(output, videoOrientation: orientation, cameraPosition: device.position, cropSize: size!) { image in
        DispatchQueue.main.async() { [weak self] in
          self?.isUserInteractionEnabled = true
          completion(image)
        }
      }
    }
  }
  
  
  
  func takePhoto(_ stillImageOutput: AVCaptureStillImageOutput, videoOrientation: AVCaptureVideoOrientation, cameraPosition: AVCaptureDevicePosition, cropSize: CGSize, completion: @escaping CameraShotCompletion) {
    
    guard let videoConnection: AVCaptureConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) else {
      completion(nil)
      return
    }
    
    videoConnection.videoOrientation = videoOrientation
    
    stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { buffer, error in
      
      guard let buffer = buffer,
        let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer),
        var image = UIImage(data: imageData) else {
          completion(nil)
          return
      }
      
      // flip the image to match the orientation of the preview
      if cameraPosition == .front, let cgImage = image.cgImage {
        switch image.imageOrientation {
        case .leftMirrored:
          image = UIImage(cgImage: cgImage, scale: image.scale, orientation: .right)
        case .left:
          image = UIImage(cgImage: cgImage, scale: image.scale, orientation: .rightMirrored)
        case .rightMirrored:
          image = UIImage(cgImage: cgImage, scale: image.scale, orientation: .left)
        case .right:
          image = UIImage(cgImage: cgImage, scale: image.scale, orientation: .leftMirrored)
        case .up:
          image = UIImage(cgImage: cgImage, scale: image.scale, orientation: .upMirrored)
        case .upMirrored:
          image = UIImage(cgImage: cgImage, scale: image.scale, orientation: .up)
        case .down:
          image = UIImage(cgImage: cgImage, scale: image.scale, orientation: .downMirrored)
        case .downMirrored:
          image = UIImage(cgImage: cgImage, scale: image.scale, orientation: .down)
        }
      }
      
      completion(image)
    })
  }
  /*
  func showSpinner() -> UIActivityIndicatorView {
    
    let spinner = UIActivityIndicatorView()
   
    spinner.activityIndicatorViewStyle = .white
    spinner.center = view.center
    spinner.startAnimating()
    
    view.addSubview(spinner)
    view.bringSubview(toFront: spinner)
    return spinner
  }
 */
  
  func hideSpinner(_ spinner: UIActivityIndicatorView) {
    spinner.stopAnimating()
    spinner.removeFromSuperview()
  }
  
  func saveImageToCameraRoll(image: UIImage) {
    
    PHPhotoLibrary.shared().performChanges({
      PHAssetChangeRequest.creationRequestForAsset(from: image)
    }, completionHandler: nil)
  }
  
  
  
  
  func saveImage(image: UIImage) {
    let spinner = showSpinner()
    preview.isHidden = true
    
    
    
    /*
    if allowsLibraryAccess {
      _ = SingleImageSaver()
        .setImage(image)
        .onSuccess { [weak self] asset in
          self?.layoutCameraResult(asset: asset)
          self?.hideSpinner(spinner)
        }
        .onFailure { [weak self] error in
          self?.toggleButtons(enabled: true)
          self?.showNoPermissionsView(library: true)
          self?.cameraView.preview.isHidden = false
          self?.hideSpinner(spinner)
        }
        .save()
    } else {
      //layoutCameraResult(uiImage: image)
      delegate?.didShotPhoto(image: image, metaData: [String:AnyObject]())
      hideSpinner(spinner)
    }
     */
  }
  
}
