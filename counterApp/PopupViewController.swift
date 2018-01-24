//
//  PopupViewController.swift
//  counterApp
//
//  Created by Julie Langmann on 1/13/18.
//  Copyright © 2018 Julie Langmann. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    @IBOutlet var doneBtn: UIButton!
    @IBOutlet var popupDatePicker: UIDatePicker!
    @IBOutlet var popupView: UIView!
    @IBOutlet var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }

    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        guard let button = sender as? UIBarButtonItem, button === doneBtn else {
            return
        }
    }
}
