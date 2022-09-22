//
//  ViewController.swift
//  EggTimer
//
//  Created by Sabyrzhan Tynybayev on 21.09.2022.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var timeLeftField: NSTextField!
    @IBOutlet weak var eggImageView: NSImageView!

    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var resetButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func startButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func stopButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func resetButtonClicked(_ sender: Any) {
        
    }
    
}

