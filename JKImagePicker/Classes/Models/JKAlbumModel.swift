//
//  JKAlbumModel.swift
//
//
//  Created by James KUMAKO on 2/6/18.
//  Copyright © 2018 Fahid Attique. All rights reserved.
//


import Foundation
import UIKit
import Photos


public class JKAlbumModel {
  
  let name:String
  let count:Int
  let collection:PHAssetCollection
  let assets: PHFetchResult<PHAsset>
  
  init(name:String, count:Int, collection:PHAssetCollection, assets: PHFetchResult<PHAsset>) {
    self.name = name
    self.count = count
    self.collection = collection
    self.assets = assets
  }
  
  static func getCameraRoll() -> JKAlbumModel {
    var cameraRollAlbum : JKAlbumModel!
    
    let cameraRoll = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
    
    cameraRoll.enumerateObjects({ (object: AnyObject!, count: Int, stop: UnsafeMutablePointer) in
      if object is PHAssetCollection {
        let obj:PHAssetCollection = object as! PHAssetCollection
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        let assets = PHAsset.fetchAssets(in: obj, options: fetchOptions)
        
        if assets.count > 0 {
          let newAlbum = JKAlbumModel(name: obj.localizedTitle!, count: assets.count, collection:obj, assets: assets)
          
          cameraRollAlbum = newAlbum
        }
      }
    })
    return cameraRollAlbum
    
  }
  
  static func listAlbums() -> [JKAlbumModel] {
    
    var album:[JKAlbumModel] = [JKAlbumModel]()
    
    let options = PHFetchOptions()
    let systemAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.any, options: options)
    
    systemAlbums.enumerateObjects({ (object: AnyObject!, count: Int, stop: UnsafeMutablePointer) in
      if object is PHAssetCollection {
        let obj:PHAssetCollection = object as! PHAssetCollection
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        let assets = PHAsset.fetchAssets(in: obj, options: fetchOptions)
        
        if assets.count > 0 {
          let newAlbum = JKAlbumModel(name: obj.localizedTitle!, count: assets.count, collection:obj, assets: assets)
          album.append(newAlbum)
        }
      }
    })
    
    
    let userAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.any, options: options)
    
    userAlbums.enumerateObjects({ (object: AnyObject!, count: Int, stop: UnsafeMutablePointer) in
      if object is PHAssetCollection {
        let obj:PHAssetCollection = object as! PHAssetCollection
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
        
        let assets = PHAsset.fetchAssets(in: obj, options: fetchOptions)
        if assets.count > 0 {
          let newAlbum = JKAlbumModel(name: obj.localizedTitle!, count: assets.count, collection: obj, assets: assets)
          album.append(newAlbum)
        }
      }
    })
    
    return album
    
  }
  
  func fetchFirstImage(returnImage: @escaping (UIImage) -> Void) {
    
    DispatchQueue.global(qos: .default).async(execute: {
      let fetchOptions = PHFetchOptions()
      fetchOptions.fetchLimit = 1
      fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
      let assets = PHAsset.fetchAssets(in: self.collection, options: fetchOptions)
      
      let requestOptions = PHImageRequestOptions()
      requestOptions.isNetworkAccessAllowed = true
      //requestOptions.isSynchronous = true
      //requestOptions.deliveryMode = .opportunistic
      
      if assets.firstObject != nil {
        
        let targetSize = CGSize(width: assets.firstObject!.pixelWidth/2, height: assets.firstObject!.pixelHeight/2)
        
        PHImageManager.default().requestImage(for: assets.firstObject!, targetSize: targetSize, contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, info) in
          if image != nil {
            DispatchQueue.main.async {
              returnImage(image!)
            }
          }
        })
      }
    })
  }
  
}


