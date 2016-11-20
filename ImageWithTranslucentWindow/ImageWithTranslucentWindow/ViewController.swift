//
//  ViewController.swift
//  ImageWithTranslucentWindow
//
//  Created by Christian Schraga on 11/20/16.
//  Copyright © 2016 Straight Edge Digital. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: ImageViewWithTranslucentWindow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "wonwon")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

