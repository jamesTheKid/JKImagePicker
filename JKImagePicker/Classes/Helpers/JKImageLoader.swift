//  Created by Fahid Attique on 12/02/2017.
//  Copyright © 2017 Fahid Attique. All rights reserved.
//
//  Edited by Jimmy Kumako on 01/02/2018

import Foundation
import Photos

typealias Success = (_ photos:[PHAsset])->Void

class JKImageLoader: NSObject {
    
    private var assets = [PHAsset]()
    private var success:Success? = nil
    
    func loadPhotos(success:Success!){
        self.success = success
        loadAllPhotos()
    }
    
    private func loadAllPhotos() {
      
        let fetchOptions: PHFetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        fetchResult.enumerateObjects({ (object, index, stop) -> Void in
            self.assets.append(object)
            if self.assets.count == fetchResult.count{
              self.success!(self.assets)
              print("loadAllPhotos success")
            }
            else{
              
            }
        })
    }
    
    static func imageFrom(asset:PHAsset, size:CGSize, success:@escaping (_ photo:UIImage)->Void){

        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options, resultHandler: { (image, attributes) in
          if image != nil {
            success(image!)
          }
          
          
        })
    }
}
