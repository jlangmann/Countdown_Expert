//
//  LoadingScreenViewController.swift
//  counterApp
//
//  Created by Julie Langmann on 1/20/18.
//  Copyright © 2018 Julie Langmann. All rights reserved.
//

import UIKit

class LoadingScreenViewController: UIViewController {

    @IBOutlet var createBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        createBtn.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
