//
//  JKImagePickerViewController.swift
//   
//
//
//  Created by Jimmy Kumako on 01/02/2018

import UIKit
import Photos

public protocol JKImagePickerViewControllerDelegate {
  func didFinishPickingPhoto(image: UIImage)
  func didCancelPickingPhoto()
}
public class JKImagePickerViewController: UIViewController {

  // MARK: IBOutlets

  @IBOutlet weak var globalScrollView: UIScrollView!
  @IBOutlet weak var selectedAlbumButton: UIButton!

  @IBOutlet weak var arrowImageView: UIImageView!

  @IBOutlet weak var bottomToolsView: UIStackView!

  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var nextButton: UIButton!

  @IBOutlet weak var cameraButton: UIButton!
  @IBOutlet weak var librayButton: UIButton!



  // MARK: Public Properties
  let spinner = UIActivityIndicatorView()

  var nextClicked = false

  var didSetupConstraint = false
  var didStartSession = false
  var albumName: String!

  var  cameraView: JKCameraView!
  var libraryView: JKLibraryView!
  var albumView : JKPhotoPickerAlbumView!
  
  // MARK: LifeCycle
  public var delegate : JKImagePickerViewControllerDelegate? = nil
    
  override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.\
      
        //*
        checkForPhotosPermission{ (auth) in
          if !auth {
            print("User can not acess library.")
            return
          }
          else{
            DispatchQueue.main.async {
              self.libraryView.loadPhotos()
              self.albumView.loadAlbums()
            }
          }
        }
        //*/
      
        viewConfigurations()
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    
  override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
        // Dispose of any resources that can be recreated.
    }
    
  override public func viewDidAppear(_ animated: Bool) {
      
        didSetupConstraint = false
        self.viewDidLayoutSubviews()
      }

    
    // MARK: Private Functions
    
    private func checkForPhotosPermission(authorized: @escaping (Bool) -> Void){
        
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            // Access has been granted.
            //loadPhotos()
            authorized(true)
        }
        else if (status == PHAuthorizationStatus.denied) {
            authorized(false)
        }
        else if (status == PHAuthorizationStatus.notDetermined) {
            
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    //*
                    DispatchQueue.main.async {
                        //self.loadPhotos()
                      
                      
                    }
                    //*/
                  authorized(true)
                }
                else {
                    authorized(false)
                }
            })
        }
            
        else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
        }
      
    }
    
    private func viewConfigurations() {
      
      //*
      self.libraryView = JKLibraryView.instance()
      self.cameraView = JKCameraView.instance()
      self.albumView = JKPhotoPickerAlbumView.instance()
      //*/
      
      self.albumView.delegate = self
      self.cameraView.delegate = self
      self.libraryView.delegate = self
      
      ///*
      globalScrollView.contentSize = CGSize(width: self.view.frame.size.width*2, height: self.globalScrollView.frame.height)
    
      self.libraryView.frame = CGRect(origin:CGPoint.zero, size: self.globalScrollView.frame.size)
      let cameraViewFrameOrigin = CGPoint(x: self.view.frame.size.width,y: 0)
      self.cameraView.frame = CGRect(origin:cameraViewFrameOrigin , size: self.globalScrollView.frame.size)
 
      
      self.libraryView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      self.cameraView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      self.globalScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      
      self.globalScrollView.addSubview(self.libraryView)
      self.globalScrollView.addSubview(self.cameraView)
      
      self.globalScrollView.autoresizesSubviews = true
      
      self.libraryView.layoutIfNeeded()
      self.cameraView.layoutIfNeeded()
      
      
      self.globalScrollView.isScrollEnabled = false
       //*/
      //navigationBarConfigurations()
      
      albumName = "All Photos"
      selectedAlbumButton.setTitle(albumName, for: .normal)
      let contraint = selectedAlbumButton.titleLabel?.intrinsicContentSize
      selectedAlbumButton.updateConstraint(attribute: .width, value: (contraint?.width)!)
      
      
      let downIcon = UIImage(named: "arrowDown.png", in: Bundle(for: self.classForCoder), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
      
      arrowImageView.image = downIcon
      albumView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height - 44.0)
      
      view.addSubview(self.albumView)
      
    }
  
    override public func viewDidLayoutSubviews() {
      
      globalScrollView.contentSize = CGSize(width: self.view.frame.size.width*2, height: self.globalScrollView.frame.height)
      //if self.libraryView != nil && self.cameraView != nil && self.cameraView != nil {
        
        if didSetupConstraint == false {
          globalScrollView.contentSize = CGSize(width: self.view.frame.size.width*2, height: self.globalScrollView.frame.height)
          self.libraryView.frame = CGRect(origin:CGPoint.zero, size: self.globalScrollView.frame.size)
          let cameraViewFrameOrigin = CGPoint(x: self.view.frame.size.width,y: 0)
          self.cameraView.frame = CGRect(origin:cameraViewFrameOrigin , size: self.globalScrollView.frame.size)
          albumView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: view.frame.height - 44.0)
          
          didSetupConstraint = true
        }
        
        
        if didStartSession == false {
          
          self.cameraView.startSession()
          didStartSession = true
        }
      //}
      
      
      
      spinner.center =  CGPoint(x: 46/2,y: 44/2)
      
      //print("viewDidLayoutSubviews")
      
    }
  
    private func navigationBarConfigurations() {
    
        navigationController?.navigationBar.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: .black), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage(color: .clear)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
    }

  
    override  public var prefersStatusBarHidden : Bool {
      
      return true
    }
  
    override public func loadView() {
      
      if let view = UINib(nibName: "JKImagePickerViewController", bundle: Bundle(for: self.classForCoder)).instantiate(withOwner: self, options: nil).first as? UIView {
        view.frame = UIScreen.main.bounds
        self.view = view
      }
    }
  
  
  
    // MARK: IBActions
    @IBAction func nextAction(_ sender: UIButton) {
      nextClicked = true
      if libraryView.isOnDownloadingImage == true {
        self.showSpinner()
      }
      else{
        self.delegate?.didFinishPickingPhoto(image: self.libraryView.getCroppedImage())
        self.dismiss(animated: true, completion: nil)
      }
      
    }
  
    @IBAction func cancelAction(_ sender: UIButton) {
      
      didSetupConstraint = false
      self.removeSpinner()
      self.libraryView.resetAlbum()
      
      nextClicked = false
      delegate?.didCancelPickingPhoto()
      self.dismiss(animated: true, completion: nil)
      
    }
  
    @IBAction func librayAction(_ sender: UIButton) {
      self.arrowImageView.isHidden = false
      self.nextButton.isHidden = false
      selectedAlbumButton.setTitle(albumName, for: .normal)
      globalScrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
      librayButton.setTitleColor(UIColor.white, for: .normal)
      cameraButton.setTitleColor(UIColor.lightGray, for: .normal)
    }
  
    @IBAction func cameraAction(_ sender: UIButton) {
      self.arrowImageView.isHidden = true
      self.nextButton.isHidden = true
      selectedAlbumButton.setTitle("Photo", for: .normal)
      globalScrollView.setContentOffset(CGPoint(x:self.globalScrollView.frame.width, y:0), animated: true)
      cameraButton.setTitleColor(UIColor.white, for: .normal)
      librayButton.setTitleColor(UIColor.lightGray, for: .normal)
    }
  
  
    @IBAction func showAlbums(_ sender: UIButton) {
      
       if !selectedAlbumButton.isSelected {
        selectedAlbumButton.isSelected = true
        
        
        UIView.animate(withDuration: 0.3, animations: {
          var rect = self.bottomToolsView.frame
          rect.origin.y = self.view.frame.height
          self.bottomToolsView.frame = rect
        })
        
        UIView.animate(withDuration: 1, delay: 0.3, usingSpringWithDamping: 12, initialSpringVelocity: 12, options: .layoutSubviews, animations: {
          self.albumView.frame = CGRect(x: 0, y: 44, width: self.view.frame.width, height: self.view.frame.height - 44.0)
          self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
          
          self.cancelButton.isHidden = true
          self.nextButton.isHidden = true
        }) { (isComplete) in
          
          
        }
      }else {
        // handle hidden album list.
        UIView.animate(withDuration: 0.3, animations: {
          self.albumView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height - 44.0)
          self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
          self.cancelButton.isHidden = false
          self.nextButton.isHidden = false
        })
        
        selectedAlbumButton.isSelected = false
        UIView.animate(withDuration: 1, delay: 0.3, usingSpringWithDamping: 12, initialSpringVelocity: 12, options: .layoutSubviews, animations: {
          
          var rect = self.bottomToolsView.frame
          rect.origin.y = self.view.frame.height - 44.0
          self.bottomToolsView.frame = rect
        }, completion: { (isComplete) in
          
        })
        
      }
    }

    func showSpinner()  {
      
      spinner.activityIndicatorViewStyle = .white
      spinner.center = CGPoint(x: 46/2,y: 44/2)
      
      spinner.startAnimating()
      nextButton.setTitle("", for: .normal)
      nextButton.addSubview(spinner)
      nextButton.bringSubview(toFront: spinner)
      
    }
  
    func removeSpinner(){
      spinner.removeFromSuperview()
      nextButton.setTitle("Next", for: .normal)
      
    }
  
}


extension JKImagePickerViewController:  JKCameraViewDelegate, JKPhotoPickerAlbumViewDelegate, JKLibraryViewDelegate{
  
  public func didFinishDownloadingPhoto() {
    self.removeSpinner()
    if nextClicked == true {
      didSetupConstraint = false
      self.delegate?.didFinishPickingPhoto(image: self.libraryView.getCroppedImage())
      self.dismiss(animated: true, completion: nil)
    }
    
  }
  
  public func didCancelDownloadingPhoto() {
    nextClicked = false
  }
  
  
  public func didShootPhoto(image: UIImage) {
    
    self.removeSpinner()
    self.libraryView.cancelDownloadInProgess()
    nextClicked = false
    didSetupConstraint = false
    self.delegate?.didFinishPickingPhoto(image: image)
  }
  
  
  func didSeletctAlbum(album: JKAlbumModel) {
    
    albumName = album.name
    selectedAlbumButton.setTitle(albumName, for: .normal)
    
    let contentSize = selectedAlbumButton.titleLabel?.intrinsicContentSize
    
    selectedAlbumButton.updateConstraint(attribute: .width, value: (contentSize?.width)!)
    libraryView.albumSelected(fetchResult: album.assets)
    
    UIView.animate(withDuration: 0.3, animations: {
      self.albumView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height - 44.0)
      self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
      self.cancelButton.isHidden = false
      self.nextButton.isHidden = false
    })
    
    selectedAlbumButton.isSelected = false
    UIView.animate(withDuration: 1, delay: 0.3, usingSpringWithDamping: 12, initialSpringVelocity: 12, options: .layoutSubviews, animations: {
      
      var rect = self.bottomToolsView.frame
      rect.origin.y = self.view.frame.height - 44.0
      self.bottomToolsView.frame = rect
    }, completion: { (isComplete) in
      
    })
    
  }
}





