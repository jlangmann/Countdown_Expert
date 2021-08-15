//
//  LoadingScreenViewController.swift
//  counterApp
//
//  Created by Julie Langmann on 1/20/18.
//  Copyright © 2018 Julie Langmann. All rights reserved.
//

import UIKit

class LoadingScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        UIView.animate(
            withDuration: 2,
            delay: 0.0,
            options: .curveEaseInOut,
            animations: {
            },
            completion: {_ in
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "homePage") as! CounterTableViewController
                newViewController.modalPresentationStyle = .fullScreen
                let navController = UINavigationController(rootViewController: newViewController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated:true, completion: nil)
            })

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
