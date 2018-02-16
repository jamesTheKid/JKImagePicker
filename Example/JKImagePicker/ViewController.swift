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
  
  func didFinishPickingPhoto(image: UIImage, metaData: [String : Any]) {
    
  }
  
  func didCancelPickingPhoto() {
    
  }
  
  
  var picker: JKImagePickerViewController?
  
  override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
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
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

