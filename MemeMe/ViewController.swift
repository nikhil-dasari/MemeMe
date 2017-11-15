//
//  ViewController.swift
//  MemeMe
//
//  Created by Nikhil Dasari on 11/14/17.
//  Copyright © 2017 Nikhil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Outlets
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    //Mark: Properties
    
    
    //MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Actions
    
    @IBAction func pickAnImage(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        self.present(imagePickerController, animated: true, completion: nil)
    }
    

}

