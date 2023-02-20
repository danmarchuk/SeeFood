//
//  ViewController.swift
//  SeeFood
//
//  Created by Данік on 20/02/2023.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing =  false
    }
    // what to do when the user has taken a photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // original unedited image selected by the user
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert UIImage into CIImage")
            }
            
            detect(image: ciImage)
        }
        
        // dismiss the image picker
        imagePicker.dismiss(animated: true)
        
    }
    
    func detect(image: CIImage) {
        do {
            let model = try VNCoreMLModel(for: Inceptionv3.init(configuration: MLModelConfiguration()).model)
            let request = VNCoreMLRequest(model: model) { request, error in
                let results = request.results as? [VNClassificationObservation]
                if let firstResult = results?.first {
                    self.navigationItem.title = firstResult.identifier
                }
            }
            let handler = VNImageRequestHandler(ciImage: image)
            try handler.perform([request])
            
        } catch {
            print(error)
        }
        
        
    }
    

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

