//
//  ViewController.swift
//  counterApp
//
//  Created by Julie Langmann on 11/20/17.
//  Copyright © 2017 Julie Langmann. All rights reserved.
//

import UIKit
import os.log


class ViewController:  UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var saveButton: UIBarButtonItem!

    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var nameTextField: UITextField!
    
    var counter: Counter?
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }

    @IBOutlet var editPhotoBtn: UIButton!
    
    @IBAction func editPhotoAction(_ sender: Any) {
        // Hide the keyboard
        nameTextField.resignFirstResponder()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard
        nameTextField.resignFirstResponder()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        datePicker.minimumDate = Date()
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let addMode = presentingViewController is UINavigationController
        
        if addMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
                os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let name = nameTextField.text ?? ""
        let photo1 = photoImageView.image
        if (name == "")
        {
            let alertController = UIAlertController(title: "Cannot Save Counter", message: "Invalid counter name", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
    
        }
        counter = Counter(name: name, photo: photo1, date: datePicker!.date)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if (identifier == "saveCounterSegue"){
            if (nameTextField.text  == "")
            {
                let alertController = UIAlertController(title: "Cannot Save Counter", message: "Please enter a counter name", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
                return false
            }
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Handle the text field’s user input through delegate callbacks.
       // nameTextField.delegate = self
        
        // edit existing counter
        if let counter = counter {
        //    navigationItem.title = "Edit " + counter.name
        //    nameTextField.text = counter.name
        //    datePicker.date = counter.date
        //    photoImageView.image = counter.photo
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

