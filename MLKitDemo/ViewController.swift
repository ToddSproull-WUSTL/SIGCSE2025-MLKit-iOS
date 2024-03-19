//
//  ViewController.swift
//  MLKitDemo
//
//  Created by Todd Sproull on 3/7/21.
//  Copyright © 2021 Todd Sproull. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var currentImage = 0
     let totalImages = 5
     
     @IBOutlet weak var theSpinner: UIActivityIndicatorView!
     @IBOutlet weak var theImage: UIImageView!
     @IBOutlet weak var theLog: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
           updateImage()
        
    }

    @IBAction func textRecognition(_ sender: Any) {
        print("in text recognition")
    }
 
    @IBAction func imageLabeling(_ sender: Any) {
         print("in image labeling")
    }
     
    @IBAction func faceDetection(_ sender: Any) {
        print("in face detection")
    }
    

    
    func updateImage(){
        clearScreen()
        let imageToDisplay = "\(currentImage).png"
        theImage.image = UIImage.init(named: imageToDisplay)
        theLog.text = ""
    }
    
     func clearScreen(){
         self.theImage.image = nil
         for v in theImage.subviews{
            v.removeFromSuperview()
         }
     }
     
    
    @IBAction func nextImage(_ sender: Any) {
        currentImage += 1
        if(currentImage >= totalImages) {
            currentImage = 0
        }
        updateImage()
    }
    
    @IBAction func previousImage(_ sender: Any) {
        currentImage -= 1
        if(currentImage < 0) {
            currentImage = totalImages - 1
        }
        updateImage()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    // The info dictionary may contain multiple representations of the image. You want to use the original.
       guard let selectedImage = info[.originalImage] as? UIImage else {
        fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        theImage.image = selectedImage
        
        dismiss(animated:true, completion: nil)

            
    }
    @IBAction func takePicture(_ sender: Any) {
        
        
        #if targetEnvironment(simulator)
          // your simulator code
        print("camera not supported in simulator")
        #else
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
        
        #endif
        
        
    }
    
    
    private func transformMatrix() -> CGAffineTransform {
      guard let image = theImage.image else { return CGAffineTransform() }
      let imageViewWidth = theImage.frame.size.width
      let imageViewHeight = theImage.frame.size.height
      let imageWidth = image.size.width
      let imageHeight = image.size.height

      let imageViewAspectRatio = imageViewWidth / imageViewHeight
      let imageAspectRatio = imageWidth / imageHeight
      let scale =
        (imageViewAspectRatio > imageAspectRatio)
        ? imageViewHeight / imageHeight : imageViewWidth / imageWidth

      // Image view's `contentMode` is `scaleAspectFit`, which scales the image to fit the size of the
      // image view by maintaining the aspect ratio. Multiple by `scale` to get image's original size.
      let scaledImageWidth = imageWidth * scale
      let scaledImageHeight = imageHeight * scale
      let xValue = (imageViewWidth - scaledImageWidth) / CGFloat(2.0)
      let yValue = (imageViewHeight - scaledImageHeight) / CGFloat(2.0)

      var transform = CGAffineTransform.identity.translatedBy(x: xValue, y: yValue)
      transform = transform.scaledBy(x: scale, y: scale)
      return transform
    }

}

private enum Constants {
  static let smallDotRadius: CGFloat = 5.0
}
