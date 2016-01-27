//
//  PostFeedModeSelectionViewController.swift
//  Pixapals
//
//  Created by DARI on 1/11/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import ImagePicker
import Toucan


class PostFeedModeSelectionViewController: UIViewController, UINavigationControllerDelegate, ImagePickerDelegate {

    @IBOutlet weak var singleModeButton: UIButton!
    @IBOutlet weak var doubleModeButton: UIButton!
    
    var CapturedImage:UIImage!
    
    var popover:UIPopoverController?=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        singleModeButton.layer.borderColor = UIColor(red:0.914, green:0.910, blue:0.922, alpha:1.00).CGColor
        singleModeButton.layer.borderWidth = 3
        doubleModeButton.layer.borderColor = UIColor(red:0.914, green:0.910, blue:0.922, alpha:1.00).CGColor
        doubleModeButton.layer.borderWidth = 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.navigationItem.title = "Select Post Mode"
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    @IBAction func btnChooseSingleImage(sender: AnyObject) {
        
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            if reachability.isReachable()  {
                singleModeButton.selected=true


                let imagePickerController = ImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.imageLimit = 1
                presentViewController(imagePickerController, animated: true, completion: nil)
                Configuration.doneButtonTitle = "Next"
                Configuration.noImagesTitle = "Sorry! There are no images here!"

            }
            
        } catch {
            print("Unable to create Reachability")
            return
        }
    }
    
    @IBAction func btnChooseDoubleImage(sender: AnyObject) {
        

    }




    
    func wrapperDidPress(images: [UIImage]){
        
    }
    func doneButtonDidPress(images: [UIImage]){
        self.dismissViewControllerAnimated(false, completion: nil)
        
        
            let uploadLiamge:UIImage = images[0].fixOrientation()
        
        let cropedImage = Toucan(image: uploadLiamge).resize(CGSize(width: 100, height: 100), fitMode: Toucan.Resize.FitMode.Crop).image
        CapturedImage = cropedImage

        
            let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
            let vc: PostFeedViewController = storyboard.instantiateViewControllerWithIdentifier("PostFeedViewController") as! PostFeedViewController
            vc.image1=CapturedImage
        
            self.navigationController?.pushViewController(vc, animated: true)
        

    }
    func cancelButtonDidPress(){
        
    }

}









extension PostFeedModeSelectionViewController: UIImagePickerControllerDelegate{














func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {




picker .dismissViewControllerAnimated(true, completion: nil)



}


}

//func openCamera()
//{
//if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
//{
//picker!.sourceType = UIImagePickerControllerSourceType.Camera
//self .presentViewController(picker!, animated: true, completion: nil)
//}
//else
//{
//openGallary()
//}
//}
//func openGallary()
//{
//picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//if UIDevice.currentDevice().userInterfaceIdiom == .Phone
//{
//self.presentViewController(picker!, animated: true, completion: nil)
//}
//else
//{
//popover=UIPopoverController(contentViewController: picker!)
//popover!.presentPopoverFromRect(singleModeButton.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
//}
//}







extension UIImage {

func fixOrientation() -> UIImage {

// No-op if the orientation is already correct
if ( self.imageOrientation == UIImageOrientation.Up ) {
return self;
}

// We need to calculate the proper transformation to make the image upright.
// We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
var transform: CGAffineTransform = CGAffineTransformIdentity

if ( self.imageOrientation == UIImageOrientation.Down || self.imageOrientation == UIImageOrientation.DownMirrored ) {
transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height)
transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
}

if ( self.imageOrientation == UIImageOrientation.Left || self.imageOrientation == UIImageOrientation.LeftMirrored ) {
transform = CGAffineTransformTranslate(transform, self.size.width, 0)
transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
}

if ( self.imageOrientation == UIImageOrientation.Right || self.imageOrientation == UIImageOrientation.RightMirrored ) {
transform = CGAffineTransformTranslate(transform, 0, self.size.height);
transform = CGAffineTransformRotate(transform,  CGFloat(-M_PI_2));
}

if ( self.imageOrientation == UIImageOrientation.UpMirrored || self.imageOrientation == UIImageOrientation.DownMirrored ) {
transform = CGAffineTransformTranslate(transform, self.size.width, 0)
transform = CGAffineTransformScale(transform, -1, 1)
}

if ( self.imageOrientation == UIImageOrientation.LeftMirrored || self.imageOrientation == UIImageOrientation.RightMirrored ) {
transform = CGAffineTransformTranslate(transform, self.size.height, 0);
transform = CGAffineTransformScale(transform, -1, 1);
}

// Now we draw the underlying CGImage into a new context, applying the transform
// calculated above.
let ctx: CGContextRef = CGBitmapContextCreate(nil, Int(self.size.width), Int(self.size.height),
CGImageGetBitsPerComponent(self.CGImage), 0,
CGImageGetColorSpace(self.CGImage),
CGImageGetBitmapInfo(self.CGImage).rawValue)!;

CGContextConcatCTM(ctx, transform)

if ( self.imageOrientation == UIImageOrientation.Left ||
self.imageOrientation == UIImageOrientation.LeftMirrored ||
self.imageOrientation == UIImageOrientation.Right ||
self.imageOrientation == UIImageOrientation.RightMirrored ) {
CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage)
} else {
CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage)
}

// And now we just create a new UIImage from the drawing context and return it
return UIImage(CGImage: CGBitmapContextCreateImage(ctx)!)
}
}

