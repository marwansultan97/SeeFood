//
//  ViewController.swift
//  SeeFood
//
//  Created by Marwan Osama on 9/16/20.
//  Copyright © 2020 Marwan Osama. All rights reserved.
//

import UIKit
import VisualRecognition
import SVProgressHUD

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cameraOutlet: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    let authenticator = WatsonIAMAuthenticator(apiKey: "jve5CivKIaJLuUc9ZVYWtuSUNNRcJwSjDLw5VYpGG9rk")
    let version = "2020-09-16"
    var classificationResults : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
}
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            imageView.image = userPickedImage
            
            self.cameraOutlet.isEnabled = false
            
            SVProgressHUD.show()
            
            let visualRecognition = VisualRecognition(version: version, authenticator: authenticator)
            
            visualRecognition.serviceURL = "https://api.us-south.visual-recognition.watson.cloud.ibm.com/instances/e8ec80cc-e719-42d1-96b7-3b21ea383a82"
            
            visualRecognition.classify(image: userPickedImage) { (classifiedImages, watsonErr) in
                let classes = classifiedImages?.result?.images.first!.classifiers.first!.classes
                self.classificationResults = []
                
                for index in 0..<classes!.count {
                    self.classificationResults.append(classes![index].class)
                }
                
                print(self.classificationResults)
                
                if self.classificationResults.contains("hotdog") {
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self.cameraOutlet.isEnabled = true
                        self.navigationItem.title = "Hotdog!"
                        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
                    }
                } else {
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self.cameraOutlet.isEnabled = true
                        self.navigationItem.title = "Not Hotdog!"
                        self.navigationController?.navigationBar.barTintColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)


                    }
                }
                
                
                
            }

            

            
        } else {
            print("Image Error")
        }
        imagePicker.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
}

