//
//  ViewController.swift
//  JKImagePicker
//
//  Created by jamesTheKid on 02/15/2018.
//  Copyright (c) 2018 jamesTheKid. All rights reserved.
//

import UIKit
import JKImagePicker

class ViewController: UIViewController,JKImagePickerViewControllerDelegate {
  
  
  @IBOutlet var  imageSelected: UIImageView?
  
  
  var picker: JKImagePickerViewController?
  
  override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func showPicker(_ sender: Any) {
    if picker != nil {
      self.present(picker!, animated: true, completion: nil)
    }
    else{
      self.picker = JKImagePickerViewController()
      self.picker?.delegate = self
      self.present(self.picker!, animated: true, completion: nil)
    }
    
  }
  
  
  // MARK: JKImagePickerViewControllerDelegate methods
  
  func didFinishPickingPhoto(image: UIImage) {
    self.imageSelected?.image = image
  }
  
  func didCancelPickingPhoto() {
    
  }
  


}

