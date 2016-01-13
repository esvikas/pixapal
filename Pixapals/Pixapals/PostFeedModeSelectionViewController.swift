//
//  PostFeedModeSelectionViewController.swift
//  Pixapals
//
//  Created by DARI on 1/11/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit

class PostFeedModeSelectionViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var singleModeButton: UIButton!
    @IBOutlet weak var doubleModeButton: UIButton!
    
    var popover:UIPopoverController?=nil
    var picker:UIImagePickerController?=UIImagePickerController()
    
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
    
    
    @IBAction func btnChangeProfilePic(sender: AnyObject) {
        
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            if reachability.isReachable()  {
                
                
                let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
                let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
                    {
                        UIAlertAction in
                        self.openCamera()
                }
                let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.Default)
                    {
                        UIAlertAction in
                        self.openGallary()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
                    {
                        UIAlertAction in
                }
                // Add the actions
                self.picker?.delegate = self
                alert.addAction(cameraAction)
                alert.addAction(gallaryAction)
                alert.addAction(cancelAction)
                // Present the controller
                if UIDevice.currentDevice().userInterfaceIdiom == .Phone
                {
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                else
                {
                    self.popover=UIPopoverController(contentViewController: alert)
                    popover!.presentPopoverFromRect(singleModeButton.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
                }
            }
            
        } catch {
            print("Unable to create Reachability")
            return
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}











extension PostFeedModeSelectionViewController: UIImagePickerControllerDelegate{














func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {




picker .dismissViewControllerAnimated(true, completion: nil)
let image = (info[UIImagePickerControllerOriginalImage] as! UIImage)




let uploadLiamge:UIImage = image.fixOrientation()


let imageData:NSData = NSData(data:(UIImageJPEGRepresentation(uploadLiamge, 1))!)
//self.updateImageToServer(imageData)


}

func imagePickerControllerDidCancel(picker: UIImagePickerController) {

picker.dismissViewControllerAnimated(true, completion: nil)

}

func openCamera()
{
if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
{
picker!.sourceType = UIImagePickerControllerSourceType.Camera
self .presentViewController(picker!, animated: true, completion: nil)
}
else
{
openGallary()
}
}
func openGallary()
{
picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
if UIDevice.currentDevice().userInterfaceIdiom == .Phone
{
self.presentViewController(picker!, animated: true, completion: nil)
}
else
{
popover=UIPopoverController(contentViewController: picker!)
popover!.presentPopoverFromRect(singleModeButton.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
}
}




}


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

