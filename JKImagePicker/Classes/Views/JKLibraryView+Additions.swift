//
//  JKLibraryView+Additions.swift
//
//
//  Created by James KUMAKO on 2/6/18.
//  Copyright © 2018 James KUMAKO. All rights reserved.
//


import UIKit
import Photos

extension JKLibraryView{
  
  //*
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photos.count
  }
  //*/
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell:JKImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "JKImageCell", for: indexPath) as! JKImageCell
    cell.populateDataWith(asset: photos[indexPath.item])
    cell.configureGestureWithTarget(target: self, action: #selector(JKLibraryView.handleLongPressGesture))
    
    return cell
  }
}


extension JKLibraryView: UICollectionViewDelegate{
  
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell:JKImageCell = collectionView.cellForItem(at: indexPath) as! JKImageCell
    cell.isSelected = true
    //selectImageFromAssetAtIndex(index: indexPath.item)
    downloadSelectImageFromAssetAtIndex(index: indexPath.item)
  }
  
}


extension JKLibraryView:UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: cellWidth, height: cellWidth)
  }
}

// MARK: - PHPhotoLibraryChangeObserver

extension JKLibraryView: PHPhotoLibraryChangeObserver {
  func photoLibraryDidChange(_ changeInstance: PHChange) {
    print("album changed")
    DispatchQueue.main.async {
      //self.loadPhotos()
      /*
      if let changes = changeInstance.changeDetails(for: fetchResult) {
        // Keep the new fetch result for future use.
        //fetchResult = changes.fetchResultAfterChanges
      }
      */
      
    }
  }
  
  
}
