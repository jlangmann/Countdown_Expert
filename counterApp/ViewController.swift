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

    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var nameTextField: UITextField!
    
    var counter: Counter?
    
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
        let photo1 = UIImage(named: "defaultPhoto")
        counter = Counter(name: name, photo: photo1, date: datePicker!.date)
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        
        // edit existing counter
        if let counter = counter {
            navigationItem.title = counter.name
            nameTextField.text = counter.name
            datePicker.date = counter.date
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

