//  Created by James KUMAKO on 2/6/18.
//  Copyright © 2018 James KUMAKO. All rights reserved.
//

import UIKit
import Photos


public protocol JKLibraryViewDelegate {
  func didFinishDownloadingPhoto()
  func didCancelDownloadingPhoto()
}

class JKLibraryView: UIView, UICollectionViewDataSource {

  @IBOutlet weak var scrollContainerView: UIView!
  @IBOutlet weak var scrollView: JKScrollView!
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var btnZoom: UIButton!
  @IBOutlet weak var btnCrop: UIButton!
  
  var delegate: JKLibraryViewDelegate? = nil
  
  var currentAsset: PHAsset?
  var currentImageRequestID: PHImageRequestID?
  var isOnDownloadingImage: Bool = true
  var downloadedImage: UIImage!
  //var fetchResult
  
  //var photos:[PHAsset]!
  var photos = [PHAsset]()
  var imageViewToDrag: UIImageView!
  var indexPathOfImageViewToDrag: IndexPath!
  
  let cellWidth = ((UIScreen.main.bounds.size.width)/3)-1
  
  //var croppedImage: UIImage? = nil
  
  // MARK: Private Properties
  
  private let imageLoader = JKImageLoader()
  private var croppedImage: UIImage? = nil

  static func instance() -> JKLibraryView {
    let view = UINib(nibName: "JKLibraryView", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: self, options: nil)[0] as! JKLibraryView
    view.initialize()
    return view
  }
  
  
  func initialize(){
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.register(UINib(nibName: "JKImageCell", bundle: Bundle(for: self.classForCoder)), forCellWithReuseIdentifier: "JKImageCell")
    
    //btnCrop.layer.cornerRadius = btnCrop.frame.size.width/2
    btnZoom.layer.cornerRadius = btnZoom.frame.size.width/2
    
    self.loadPhotos()
    PHPhotoLibrary.shared().register(self)
  }
  
  func albumSelected(fetchResult: PHFetchResult<PHAsset>){
    var assets = [PHAsset]()
    fetchResult.enumerateObjects({ (object, index, stop) -> Void in
        assets.append(object)
      
    })
    
    self.configureImageCropper(assets: assets)
  }
  
  func getCroppedImage() -> UIImage {
    return self.captureVisibleRect()
  }
  
  
  @IBAction func zoom(_ sender: Any) {
    scrollView.zoom()
  }
  
  @IBAction func crop(_ sender: Any) {
    croppedImage = captureVisibleRect()
  }
  
  
  // MARK: Public Functions
  
  func selectImageFromAssetAtIndex(index:NSInteger){
    let targetSize = CGSize(width: (currentAsset?.pixelWidth)!, height: (currentAsset?.pixelHeight)!)
    JKImageLoader.imageFrom(asset: photos[index], size: targetSize) { (image) in
      DispatchQueue.main.async {
        self.displayImageInScrollView(image: image)
      }
    }
    
  }
  
  func resetAlbum(){
    self.cancelDownloadInProgess()
    self.selectDefaultImage()
  }
  
  func cancelDownloadInProgess(){
    
    if currentImageRequestID != nil {
      PHImageManager.default().cancelImageRequest(self.currentImageRequestID!)
      delegate?.didCancelDownloadingPhoto()
      downloadedImage = nil
    }
    
  }
  
  func downloadSelectImageFromAssetAtIndex(index:NSInteger){
    
    self.cancelDownloadInProgess()
    
    currentAsset = photos[index]
    
    let targetSize = CGSize(width: (currentAsset?.pixelWidth)!, height: (currentAsset?.pixelHeight)!)
    
    PHImageManager.default().requestImage(for: currentAsset!, targetSize: targetSize, contentMode: .aspectFill, options: nil) { (image, info) in
      //self.displayImageInScrollView(image: image!)
      
      DispatchQueue.main.async {
        if image != nil {
          self.displayImageInScrollView(image: image!)
        }
      }
    }
    
    
    //self.selectImageFromAssetAtIndex(index: index)
    
    isOnDownloadingImage = true
    
    let requestOptions = PHImageRequestOptions()
    requestOptions.isNetworkAccessAllowed = true
    requestOptions.isSynchronous = false
    requestOptions.deliveryMode = .highQualityFormat
    
    requestOptions.progressHandler = {(progress, err, pointer, info) in
      
      DispatchQueue.main.async {
        
        //if self.progressView.isHidden {
        //  self.progressView.isHidden = false
        //}
        
        //self.progressView.progress = CGFloat(progress)
        
        if progress == 1.0 {
          DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3, execute: {
            //self.progressView.progress = 0.0
            //self.progressView.isHidden = true
          })
        }
      }
      print("progress \(progress)")
    }
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
      
      self.currentImageRequestID = PHImageManager.default().requestImage(for: self.currentAsset!, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: requestOptions) { (image, info) in
        
        
        if let isInCloud = info?[PHImageResultIsInCloudKey] as? Bool {
          self.isOnDownloadingImage = isInCloud
        }
        
        if image != nil {
          DispatchQueue.main.async {
            self.displayImageInScrollView(image: image!)
            self.downloadedImage = self.captureVisibleRect()
            self.isOnDownloadingImage = false
            self.delegate?.didFinishDownloadingPhoto()
          }
        }
      }
      
    }
    
    
  }
  
  
  func handleLongPressGesture(recognizer: UILongPressGestureRecognizer) {
   
  }
  
  func displayImageInScrollView(image:UIImage){
    self.scrollView.imageToDisplay = image
    ///*
    if isSquareImage() { btnZoom.isHidden = true }
    else { btnZoom.isHidden = false }
    //*/
  }
  
  func replicate(_ image:UIImage) -> UIImage? {
    
    guard let cgImage = image.cgImage?.copy() else {
      return nil
    }
    
    return UIImage(cgImage: cgImage,scale: image.scale,orientation: image.imageOrientation)
  }
  
  private func isSquareImage() -> Bool{
    let image = scrollView.imageToDisplay
    if image?.size.width == image?.size.height { return true }
    else { return false }
  }

  
  
  //private func loadPhotos(){
  func loadPhotos(){
    imageLoader.loadPhotos { (assets) in
      self.configureImageCropper(assets: assets)
    }
  }
  
  
  private func configureImageCropper(assets:[PHAsset]){
    
    if assets.count != 0{
      photos = assets
      
      //collectionView.delegate = self
      //collectionView.dataSource = self
      collectionView.reloadData()
      selectDefaultImage()
    }
    else{
      
    }
  }
  
  private func selectDefaultImage(){
    if photos.count > 0 {
      collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .top)
      //selectImageFromAssetAtIndex(index: 0)
      downloadSelectImageFromAssetAtIndex(index: 0)
    }
    
  }
  
  
  private func captureVisibleRect() -> UIImage{
     
    var croprect = CGRect.zero
    let xOffset = (scrollView.imageToDisplay?.size.width)! / scrollView.contentSize.width;
    let yOffset = (scrollView.imageToDisplay?.size.height)! / scrollView.contentSize.height;
    
    croprect.origin.x = scrollView.contentOffset.x * xOffset;
    croprect.origin.y = scrollView.contentOffset.y * yOffset;
    
    let normalizedWidth = (scrollView?.frame.width)! / (scrollView?.contentSize.width)!
    let normalizedHeight = (scrollView?.frame.height)! / (scrollView?.contentSize.height)!
    
    croprect.size.width = scrollView.imageToDisplay!.size.width * normalizedWidth
    croprect.size.height = scrollView.imageToDisplay!.size.height * normalizedHeight
    
    let toCropImage = scrollView.imageView.image?.fixImageOrientation()
    let cr: CGImage? = toCropImage?.cgImage?.cropping(to: croprect)
    let cropped = UIImage(cgImage: cr!)
    
    return cropped
    
  }
  
  
  
  
}



