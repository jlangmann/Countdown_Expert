//
//  MainViewController.swift
//  counterApp
//
//  Created by Julie Langmann on 1/6/18.
//  Copyright © 2018 Julie Langmann. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewDidAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        let savedCountdowns = loadCountdowns()
        if (savedCountdowns != nil && savedCountdowns! != [])
        {
            loadCounterView()
        }
        else
        {
            loadMainView()
        }
    }
    
    private func loadMainView()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "launchView")
        self.present(newViewController, animated: true, completion: nil)
    }
    
    private func loadCounterView()
    {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "counterNavigation") as! UINavigationController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    private func loadCountdowns() -> [Counter]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Counter.ArchiveURL.path) as? [Counter]
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
