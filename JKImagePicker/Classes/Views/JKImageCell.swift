//  Created by Fahid Attique on 12/02/2017.
//  Copyright © 2017 Fahid Attique. All rights reserved.
//
//  Edited by Jimmy Kumako on 01/02/2018

import UIKit
import Photos

public let JKImagePlaceHolderSize: CGSize = CGSize(width: 100.0, height: 100.0)


class JKImageCell: UICollectionViewCell {

    //  MARK: IBOutlets
    
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var imageView: UIImageView!

    // MARK: Class Properties

    var longPressGestrue: UILongPressGestureRecognizer!
    
    override var isSelected:Bool{
        
        didSet{
            if isSelected {
                selectionView.backgroundColor = .white
            }
            else{
                selectionView.backgroundColor = .clear
            }
        }
    }

    //  MARK: Functions

    override func prepareForReuse() {
        super.prepareForReuse()
        if self.imageView != nil{
            imageView.image = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewConfigurations()
    }
    
    private func viewConfigurations(){
        selectionView.layer.borderWidth = 2
        selectionView.layer.borderColor = UIColor.clear.cgColor
    }

    func populateDataWith(asset:PHAsset) {
        
        JKImageLoader.imageFrom(asset: asset, size: JKImagePlaceHolderSize) { (image) in
            DispatchQueue.main.async {
                if self.imageView != nil{
                    self.imageView.image = image
                }
            }
        }
    }

    func configureGestureWithTarget(target: Any?, action: Selector?) {
        
        longPressGestrue = UILongPressGestureRecognizer(target: target, action: action)
        longPressGestrue.minimumPressDuration = 0.25
        self.addGestureRecognizer(longPressGestrue)
    }

}
