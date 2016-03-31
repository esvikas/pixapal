////
////  ImageSelectionVC.swift
////  LoveOrLeave
////
////  Created by Rajan Khattri on 8/21/15.
////  Copyright (c) 2015 Rajan Khattri. All rights reserved.
////
//
//import UIKit
//import AssetsLibrary
//import Photos
//
//class ImageSelectionVC: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, AlbumSelectedDelegate {
//    
//    var topBarView: UIView!
//    var btnBack: UIButton!
//    var btnNext: UIButton!
//    
//    var imageScrollView: UIScrollView!
//    var postImageView: UIImageView!
//    let cropView = ALCropOverlay()
//    var dragEditView: UIView!
//    
//    var photoCollectionView: UICollectionView!
//    var btnGallery: UIButton!
//    
//    var verticalPadding: CGFloat = 0
//    var horizontalPadding: CGFloat = 0
//    
//    var albumList = [ALAssetsGroup]()
//    var photoList = [ALAsset]()
//    
//    var imageManager: PHCachingImageManager!
//    var smartAlbums: PHFetchResult!
//    var assetsFetchResult: PHFetchResult!
//    var selectedImage: UIImage?
//    
//    var lastLocation:CGPoint = CGPointMake(0, 0)
//    
//    var isDoubleMode: Bool = false
//    
//    //MARK: Private Utility Methods
//    
//    private func loadAlbums() {
////        let fetchOptions = PHFetchOptions()
////        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
//        
////        let phFetchOptions = PHFetchOptions()
////        phFetchOptions.predicate = NSPredicate(format: "estimatedAssetCount > 0")
//        self.smartAlbums = PHAssetCollection.fetchAssetCollectionsWithType(.SmartAlbum, subtype: .AlbumRegular, options: nil)
//        self.loadPhotos(0)
//        /*
//        let library = RKAssetsLibrary.defaultInstance
//        library.enumerateGroupsWithTypes(ALAssetsGroupAlbum, usingBlock: { (group, stop) -> Void in
//            if (group != nil && group.numberOfAssets()>0) {
//                self.albumList.append(group)
//            } else {
//                dispatch_async(dispatch_get_main_queue(), {
//                    self.loadPhotos(0)
//                })
//            }
//            }) { (error) -> Void in
//                //print("problem loading albums: \(error)")
//        }
//        */
//    }
//
//    private func loadPhotos(albumIndex: Int) {
//        self.assetsFetchResult = PHAsset.fetchAssetsInAssetCollection(self.smartAlbums[albumIndex] as! PHAssetCollection, options: nil)
//        if self.assetsFetchResult.count>0 {
//            self.photoCollectionView.reloadData()
//            self.updateCropView(0)
//        }
////        self.albumList[albumIndex].enumerateAssetsUsingBlock({ asset, index, stop in
////            if (asset != nil) {
////                if asset.valueForProperty(ALAssetPropertyType).isEqualToString(ALAssetTypePhoto) {
////                    self.photoList.append(asset)
////                }
////            } else {
////                self.updateCropView(0)
////            }
////        })
//    }
//    
//    private func cropImage() ->UIImage? {
//        let scale: CGFloat = self.selectedImage!.size.width / self.imageScrollView.contentSize.width
//        
//        var croppedImage: UIImage?
//        let targetFrame = CGRectMake((self.imageScrollView.contentInset.left + self.imageScrollView.contentOffset.x) * scale,
//            (self.imageScrollView.contentInset.top + self.imageScrollView.contentOffset.y) * scale,
//            self.cropView.frame.width * scale,
//            self.cropView.frame.height * scale)
//        
//        let contextImageRef =  CGImageCreateWithImageInRect(self.selectedImage?.CGImage, targetFrame)
//        
//        if (contextImageRef != nil) {
//            croppedImage = UIImage(CGImage: contextImageRef!, scale: self.selectedImage!.scale, orientation: .Up)
//        }
//        return croppedImage
//    }
//    
//    private func targetSize() ->CGSize {
//        let scale = UIScreen.mainScreen().scale
//        return CGSize(width: self.postImageView.frame.size.width*scale, height: self.postImageView.frame.size.height*scale)
//    }
//    
//    private func updateCropView(index: Int) {
////        let cgImage = self.photoList[index].defaultRepresentation().fullResolutionImage().takeUnretainedValue()
////        var orientation:UIImageOrientation?
////        let orientationValue: NSNumber = self.photoList[index].valueForProperty(ALAssetPropertyOrientation) as! NSNumber
////        orientation = UIImageOrientation(rawValue: Int(orientationValue))!
////        let image = UIImage(CGImage: cgImage, scale: 1.0, orientation: orientation!)
//        let options = PHImageRequestOptions()
//        options.deliveryMode = .HighQualityFormat
//        options.networkAccessAllowed = true
//        let asset = self.assetsFetchResult[index] as! PHAsset
//        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: self.targetSize(), contentMode: .AspectFill, options: options, resultHandler: {(result, info) in
//            self.selectedImage = result
//        
//    //        self.selectedImage = image
//            self.postImageView.image = self.selectedImage
//    //        self.postImageView.sizeToFit()
//    //        self.postImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width)
//            
//            if !self.isDoubleMode {
//                if self.selectedImage!.size.height > self.selectedImage!.size.width {
//                    let imageScale = self.selectedImage!.size.height/self.selectedImage!.size.width
//                    self.postImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width*imageScale)
//                } else {
//                    let imageScale = self.selectedImage!.size.width/self.selectedImage!.size.height
//                    self.postImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width*imageScale, height: self.view.frame.size.width)
//                }
//            } else {
//                if self.selectedImage!.size.height > self.selectedImage!.size.width {
//                    let imageScale = self.selectedImage!.size.height/self.selectedImage!.size.width
//                    self.postImageView.frame = CGRect(x: self.view.frame.size.width/4, y: 0, width: self.view.frame.size.width/2, height: self.view.frame.size.width*imageScale)
//                } else {
//                    let imageScale = self.selectedImage!.size.width/self.selectedImage!.size.height
//                    self.postImageView.frame = CGRect(x: self.view.frame.size.width/4, y: 0, width: (self.view.frame.size.width*imageScale)/2, height: self.view.frame.size.width)
//                }
//            }
//            self.photoCollectionView.reloadData()
//            
//            self.imageScrollView.contentSize = self.postImageView.frame.size
//            
//    //        let width = view.frame.size.width - horizontalPadding
//    //        let height = width
//    //        let x = horizontalPadding/2
//    //        let cameraButtonY = view.frame.size.height - (verticalPadding + 80)
//    //        let y = cameraButtonY/2 - height/2
//    //        let yy = view.frame.size.height - (y + height)
//            
//    //        let scaleWidth = self.view.frame.size.width / imageScrollView.contentSize.width
//    //        let scaleHeight = self.view.frame.size.width / imageScrollView.contentSize.height
//    //        var minScale: CGFloat = fmax(scaleWidth, scaleHeight)
//
//            self.cropView.removeFromSuperview()
//            
//            if self.isDoubleMode {
//                self.cropView.frame = CGRectMake(self.view.frame.size.width/4, 64, self.view.frame.size.width/2, self.view.frame.size.width)
//            } else {
//                self.view.addSubview(self.cropView)
//                self.cropView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width)
//            }
//    //        imageScrollView.contentInset = UIEdgeInsetsMake(cropView.frame.origin.y, cropView.frame.origin.x, yy, cropView.frame.origin.x)
//            
//            self.imageScrollView.minimumZoomScale = 1
//            self.imageScrollView.maximumZoomScale = 3
//    //        imageScrollView.zoomScale = 1
//            
//            self.centerScrollViewContents()
//        })
//    }
//    
//    private func centerScrollViewContents() {
//        var size: CGSize
//        
//        size = cropView.frame.size
//        
//        var contentFrame = postImageView.frame
//        
//        if contentFrame.size.width < size.width {
//            contentFrame.origin.x = (size.width - contentFrame.size.width) / 2
//        } else {
//            contentFrame.origin.x = 0
//        }
//        
//        if contentFrame.size.height < size.height {
//            contentFrame.origin.y = (size.height - contentFrame.size.height) / 2
//        } else {
//            contentFrame.origin.y = 0
//        }
//        
//        postImageView.frame = contentFrame
//    }
//
//    //MARK: UIViewController life cycle
//    
//    override func loadView() {
//        super.loadView()
//        
//        self.topBarView = UIView()
//        self.topBarView.backgroundColor = UIColor.buttonBackgroundColor()
//        self.view.addSubview(self.topBarView)
//        
//        self.btnBack = UIButton(type: .Custom)
//        self.btnBack.backgroundColor = UIColor.buttonBackgroundColor()
//        self.btnBack.setTitleColor(UIColor.primaryTextColor(), forState: .Normal)
//        self.btnBack.setTitle("back", forState: .Normal)
//        self.btnBack.addTarget(self, action: "btnBackAction:", forControlEvents: .TouchUpInside)
//        self.topBarView.addSubview(self.btnBack)
//
//        self.btnNext = UIButton(type: .Custom)
//        self.btnNext.backgroundColor = UIColor.buttonBackgroundColor()
//        self.btnNext.setTitleColor(UIColor.primaryTextColor(), forState: .Normal)
//        self.btnNext.setTitle("Next", forState: .Normal)
//        self.btnNext.addTarget(self, action: "btnNextAction:", forControlEvents: .TouchUpInside)
//        self.topBarView.addSubview(self.btnNext)
//        
//        self.imageScrollView = UIScrollView()
//        self.imageScrollView.delegate = self
//        self.view.addSubview(self.imageScrollView)
//        
//        self.postImageView = UIImageView()
//        self.postImageView.userInteractionEnabled = true
//        self.imageScrollView.addSubview(self.postImageView)
//        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
//        layout.minimumInteritemSpacing = 2
//        layout.minimumLineSpacing = 2
//        layout.itemSize = CGSize(width: (self.view.frame.size.width-4)/3, height: (self.view.frame.size.width-4)/3)
//        
//        self.photoCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
//        self.photoCollectionView.dataSource = self
//        self.photoCollectionView.delegate = self
//        self.photoCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
//        self.photoCollectionView.backgroundColor = UIColor.viewBackgroundColor()
//        self.view.addSubview(self.photoCollectionView)
//        
//        self.dragEditView = UIView()
//        self.dragEditView.userInteractionEnabled = true
//        self.view.addSubview(self.dragEditView)
//        
//        self.btnGallery = UIButton(type: .Custom)
//        self.btnGallery.backgroundColor = UIColor.fedButtonBackgroundColor()
//        self.btnGallery.setTitleColor(UIColor.primaryTextColor(), forState: .Normal)
//        self.btnGallery.setTitle("galary", forState: .Normal)
//        self.btnGallery.addTarget(self, action: "btnGalleryAction:", forControlEvents: .TouchUpInside)
//        self.view.addSubview(self.btnGallery)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.imageManager = PHCachingImageManager()
//        self.loadAlbums()
//        
//        //Add Gesture
//        let panRecognizer = UIPanGestureRecognizer(target:self, action:"dragImageView:")
//        self.dragEditView.addGestureRecognizer(panRecognizer)
//    }
//    
//    override func viewWillAppear(animated: Bool) {
//        self.navigationController?.navigationBarHidden = true
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        let mainFrameSize = self.view.frame.size
//        let xOffset: CGFloat = 0
//        var yOffset: CGFloat = 20
//        
//        self.topBarView.frame = CGRect(x: xOffset, y: yOffset, width: mainFrameSize.width, height: 44)
//        self.btnBack.frame = CGRect(x: 0, y: 2, width: 40, height: 40)
//        self.btnNext.frame = CGRect(x: mainFrameSize.width-40, y: 2, width: 40, height: 40)
//        
//        yOffset += self.topBarView.frame.size.height
//        if self.isDoubleMode {
//            self.imageScrollView.frame = CGRect(x: mainFrameSize.width/4, y: yOffset, width: mainFrameSize.width/2, height: mainFrameSize.width)
//        } else {
//            self.imageScrollView.frame = CGRect(x: xOffset, y: yOffset, width: mainFrameSize.width, height: mainFrameSize.width)
//        }
//        
//        self.dragEditView.frame = CGRect(x: 0, y: self.imageScrollView.frame.size.height-4, width: mainFrameSize.width, height: 8)
//        
//        yOffset += mainFrameSize.width
//        self.photoCollectionView.frame = CGRect(x: xOffset, y: yOffset, width: mainFrameSize.width, height: mainFrameSize.height-yOffset)
//        
//        self.btnGallery.frame = CGRect(x: mainFrameSize.width-60, y: mainFrameSize.height-60, width: 50, height: 50)
//        self.btnGallery.layer.cornerRadius = self.btnGallery.frame.size.height/2
//        view.layer.shadowColor = UIColor.blackColor().CGColor
//        view.layer.shadowOffset = CGSizeZero
//        view.layer.shadowOpacity = 0.5
//        view.layer.shadowRadius = 2
//    }
//    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        // Remember original location
//        self.lastLocation = self.imageScrollView.center
//    }
//    
//    //MARK: UIGestureRecognizer
//    
//    func dragImageView(recognizer:UIPanGestureRecognizer) {
//        /*
//        let translation  = recognizer.translationInView(self.view)
//        self.imageScrollView.center = CGPointMake(self.imageScrollView.center.x, self.lastLocation.y + translation.y)
//        self.cropView.center = CGPointMake(self.cropView.center.x, self.lastLocation.y + translation.y)
//        self.photoCollectionView.center = CGPointMake(self.photoCollectionView.center.x, self.lastLocation.y + translation.y)
//        */
//    }
//    
//    //MARK: UIButtonAction
//    
//    func btnBackAction(sender: UIButton) {
//        self.navigationController?.popViewControllerAnimated(true)
//    }
//    
//    func btnNextAction(sender: UIButton) {
////        let scale = 1.0/imageScrollView.zoomScale
//        var imageScale: CGFloat = 1
//        if self.selectedImage!.size.height > self.selectedImage!.size.width {
//            imageScale = self.selectedImage!.size.height/self.selectedImage!.size.width
//            self.postImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width*imageScale)
//        } else {
//            imageScale = self.selectedImage!.size.width/self.selectedImage!.size.height
//            self.postImageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width*imageScale, height: self.view.frame.size.width)
//        }
//        let croppedImage = self.cropImage()
//        if croppedImage != nil {
//            NSNotificationCenter.defaultCenter().postNotificationName("ImageSelected", object: nil, userInfo: ["image": croppedImage!])
//        }
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    func btnGalleryAction(sender: UIButton) {
////        let picker : UIImagePickerController = UIImagePickerController()
////        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
////        picker.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(.PhotoLibrary)!
//////        picker.delegate = self
////        picker.allowsEditing = false
////        self.presentViewController(picker, animated: true, completion: nil)
//        let albumVC = AlbumListVC()
//        albumVC.albums = self.smartAlbums
//        albumVC.albumSelectedDelegate = self
//        let albumNav = UINavigationController(rootViewController: albumVC)
//        self.presentViewController(albumNav, animated: true, completion: nil)
//    }
//    
//    //MARK: AlbumSelectedDelegate
//    
//    func albumDidSelect(index: Int) {
//        self.photoList.removeAll(keepCapacity: false)
//        self.loadPhotos(index)
//    }
//    
//    //MARK: UIScrollViewDelegate
//    
//    internal func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
//        return self.postImageView
//    }
//    
//    internal func scrollViewDidZoom(scrollView: UIScrollView) {
//        self.centerScrollViewContents()
//    }
//    
//    //MARK: UICollectionViewdataSource
//    
//    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
//        return 1
//    }
//    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if self.assetsFetchResult != nil {
//            return self.assetsFetchResult.count
//        }
//        return 0
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let photoCell = self.photoCollectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
//        let thumbNailSize = CGSize(width: (self.view.frame.size.width-4)/3, height: (self.view.frame.size.width-4)/3)
//        let imageView = UIImageView(frame: CGRect(x:0, y:0, width: thumbNailSize.width, height: thumbNailSize.height))
//        imageView.backgroundColor = UIColor.cellBackgroundColor()
//        photoCell.contentView.addSubview(imageView)
//        
////        imageView.image = UIImage(CGImage: self.photoList[indexPath.row].thumbnail().takeUnretainedValue())
//        let option = PHImageRequestOptions()
//        option.synchronous = true
//        let asset = self.assetsFetchResult[indexPath.item] as! PHAsset
//        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: thumbNailSize, contentMode: .AspectFill, options: option, resultHandler: {(result, info) in
//            imageView.image = result
//        })
//        return photoCell
//    }
//    
//    //MARK: UICollectionViewDelegate
//    
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        self.updateCropView(indexPath.row)
//    }
//    
//    //MARK: UICollectionViewDelegateFlowLayout
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSize(width: (self.view.frame.size.width-4)/3, height: (self.view.frame.size.width-4)/3)
//    }
//
//}
