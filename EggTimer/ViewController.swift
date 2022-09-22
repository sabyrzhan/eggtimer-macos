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
        print("Start button clicked")
    }
    
    @IBAction func stopButtonClicked(_ sender: Any) {
        print("Stop button clicked")
    }
    
    @IBAction func resetButtonClicked(_ sender: Any) {
        print("Reset button clicked")
    }
    
    
    @IBAction func startMenuItemSelected(_ sender: Any) {
        startButtonClicked(sender)
    }
    
    @IBAction func stopMenuItemSelected(_ sender: Any) {
        stopButtonClicked(sender)
    }
    
    @IBAction func resetMenuItemSelected(_ sender: Any) {
        resetButtonClicked(sender)
    }
    
    
}

