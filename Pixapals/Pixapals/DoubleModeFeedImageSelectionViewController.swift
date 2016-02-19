//
//  DoubleModeFeedImageSelectionViewController.swift
//  Pixapals
//
//  Created by DARI on 1/15/16.
//  Copyright © 2016 com.pixpal. All rights reserved.
//

import UIKit
import ImagePicker
import Toucan


class DoubleModeFeedImageSelectionViewController: UIViewController, ImagePickerDelegate {
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var verticalSeparatorView: UIView!
    @IBOutlet weak var horizontalSeparatorView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    var CapturedImage:UIImage!
    var CapturedImage2:UIImage!
    var image1Selected:Bool!
    var image2Selected:Bool!

    @IBOutlet weak var instructionLbl: UILabel!

    
    
    var stateVertical: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrangeViews(false)
        // Do any additional setup after loading the view.
        image1.userInteractionEnabled = true
        image2.userInteractionEnabled = true

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("image1Pressed"))
        image1.addGestureRecognizer(gestureRecognizer)
        image2.userInteractionEnabled = true
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: Selector("image2Pressed"))
        image2.addGestureRecognizer(gestureRecognizer2)
        
        self.view.backgroundColor=UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        

        

    }
    
    func image1Pressed(){
   
        image1Selected=true
        image2Selected=false

        let imagePickerController = ImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        Configuration.doneButtonTitle = "Next"
        Configuration.noImagesTitle = "Sorry! There are no images here!"
        presentViewController(imagePickerController, animated: true, completion: nil)

        
            

        
    }
    func image2Pressed(){
        
        image1Selected=false
        image2Selected=true
        
        let imagePickerController = ImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        Configuration.doneButtonTitle = "Next"
        Configuration.noImagesTitle = "Sorry! There are no images here!"
        presentViewController(imagePickerController, animated: true, completion: nil)

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeStatePressed(sender: AnyObject) {
        self.stateVertical = !self.stateVertical
        arrangeViews(self.stateVertical)
    }
    
    @IBAction func btnNext(sender: AnyObject) {
        if CapturedImage != nil && CapturedImage2 != nil {
        let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
        let vc: PostFeedViewController = storyboard.instantiateViewControllerWithIdentifier("PostFeedViewController") as! PostFeedViewController
        vc.image1=CapturedImage
        vc.imageMode=2
            vc.imagePostMode=2

        vc.image2=CapturedImage2
        self.navigationController?.pushViewController(vc, animated: true)
        }else{
            print("Only one Image")
        }
    }
    
    private func arrangeViews(stateVertical: Bool){
        if stateVertical {
            self.verticalSeparatorView.hidden = true
            self.horizontalSeparatorView.hidden = false
            self.stackView.axis = UILayoutConstraintAxis.Vertical
        } else {
            self.verticalSeparatorView.hidden = false
            self.horizontalSeparatorView.hidden = true
            self.stackView.axis = UILayoutConstraintAxis.Horizontal
        }
    }

    
    func wrapperDidPress(images: [UIImage]){
        
    }
    func doneButtonDidPress(images: [UIImage]){
        self.dismissViewControllerAnimated(false, completion: nil)
        
        if image1Selected==true{
            image1.contentMode = UIViewContentMode.ScaleToFill
            let uploadLiamge:UIImage = images[0].fixOrientation()
            
            let cropedImage = Toucan(image: uploadLiamge).resize(CGSize(width: 100, height: 200), fitMode: Toucan.Resize.FitMode.Crop).image
            CapturedImage = cropedImage
            
            
            
//            CapturedImage = uploadLiamge
            image1.image = cropedImage

            }
        else{
            
            let uploadLiamge:UIImage = images[0].fixOrientation()
            image2.contentMode = UIViewContentMode.ScaleToFill
            
            let cropedImage = Toucan(image: uploadLiamge).resize(CGSize(width: 100, height: 200), fitMode: Toucan.Resize.FitMode.Crop).image
            CapturedImage2 = cropedImage
            
            image2.image = cropedImage


        }
        
        if let _ = CapturedImage, let _ = CapturedImage2 {
            instructionLbl.text = "Both image successfully captured."
        } else {
            if let _ = CapturedImage {
                instructionLbl.text = "First image successfully captured. Take or upload second image."
            } else {
                instructionLbl.text = "Second image successfully captured. Take or upload first image."
            }
        }
        
        
        
    }
    func cancelButtonDidPress(){
        
    }
    

}
