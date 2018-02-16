//
//  JKPhotoPickerAlbumView.swift
//   
//
//  Created by James KUMAKO on 2/6/18.
//  Copyright © 2018 James KUMAKO. All rights reserved.
//

import UIKit


protocol JKPhotoPickerAlbumViewDelegate {
  
  func didSeletctAlbum(album: JKAlbumModel)
  
}

class JKPhotoPickerAlbumView: UIView, UITableViewDelegate, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  
  var albums: [JKAlbumModel] = JKAlbumModel.listAlbums()
  
  var delegate: JKPhotoPickerAlbumViewDelegate? = nil
  
  static func instance() -> JKPhotoPickerAlbumView {
    
    let view = UINib(nibName: "JKPhotoPickerAlbumView", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: self, options: nil)[0] as! JKPhotoPickerAlbumView
    view.initialize()
    return view
  }
  
  
  func initialize() {
    
    tableView.register(UINib(nibName: "JKPhotoPickerAlbumViewCell", bundle: Bundle(for: self.classForCoder)), forCellReuseIdentifier: "JKPhotoPickerAlbumViewCell")
    
  }
  
  func loadAlbums(){
    albums = JKAlbumModel.listAlbums()
    tableView.reloadData()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "JKPhotoPickerAlbumViewCell", for: indexPath) as! JKPhotoPickerAlbumViewCell
    cell.model = albums[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return albums.count > 0 ? albums.count : 0
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 96.0
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    delegate?.didSeletctAlbum(album: albums[indexPath.row])
    
  }


}
