//
//  ViewController.swift
//  MRG Racecar App
//
//  Created by Brandon Man on 17/7/2019.
//  Copyright © 2019 Brandon Man. All rights reserved.
//

import UIKit
import RBSManager
import BRHJoyStickView
import CoreGraphics

class ViewController: UIViewController, RBSManagerDelegate {
    let joystickSpan: CGFloat = 80.0
    
    
    //Buttons
    @IBOutlet var toggleTeleopAuto: UISegmentedControl!
    @IBOutlet var connectButton: UIButton!
    @IBOutlet var upButton: UIButton!
    @IBOutlet var downButton: UIButton!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var hostButton: UIButton!
    @IBOutlet var autoButton: UIButton!
    @IBOutlet var publishButton: UIButton!

    @IBOutlet var stopButton: UIButton!
    
    
    
    var hostButtonStatus:Bool!
    //Topic name
    var publishTopic:String!
    var debugTopic:String!
    var subscribeTopic:String!
    var aprilTagPublishTopic:String!
    
    //Data
    let linearSpeed:Float =  100.0
    let angularSpeed: Float = 0.34
    var aprilTags = [Int32]()
    
    


    //RBS Manager
    var racecarManager: RBSManager?
    var racecarPublisher: RBSPublisher?
    var racecarSubscriber: RBSSubscriber?
    var racecarDebugPublisher: RBSPublisher?
    var aprilTagPublisher: RBSPublisher?
    var lastTagMessage: Int32Message!
    
    
    //User settings
    var socketHost: String?
    
    var controlTimer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        
        racecarManager = RBSManager.sharedManager()
        racecarManager?.delegate = self
        updateButtonStates(false)
        
        
        loadSettings()
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let tabbar = tabBarController as! BaseTabBarControllerViewController
        
        print (tabbar.aprilTagPublisherTopic)
        aprilTagPublishTopic = String(tabbar.aprilTagPublisherTopic)
        publishTopic = String(tabbar.publisherTopic)
        debugTopic = String(tabbar.debugPublisherTopic)
        subscribeTopic = String(tabbar.subscriberTopic)
        hostButtonStatus = Bool(tabbar.host)
        aprilTags = tabbar.tags
        
        racecarPublisher = racecarManager?.addPublisher(topic: publishTopic, messageType: "sensor_msgs/Joy", messageClass: JoyMessage.self)
        
        racecarDebugPublisher = racecarManager?.addPublisher(topic: debugTopic, messageType: "std_msgs/String", messageClass: StringMessage.self)
        
        aprilTagPublisher = racecarManager?.addPublisher(topic: aprilTagPublishTopic, messageType: "std_msgs/String", messageClass: StringMessage.self)
        
        racecarSubscriber = racecarManager?.addSubscriber(topic: subscribeTopic, messageClass: Int32Message.self, response: { (message) -> (Void) in
            // store the message for other operations
            self.lastTagMessage = message as! Int32Message
            
            // update the view with message data
            self.updateWithMessage(self.lastTagMessage)
        })
        
        // Do any additional setup after loading the view.
        racecarSubscriber?.messageType = "std_msgs/Int32"
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let tabbar = tabBarController as! BaseTabBarControllerViewController
        tabbar.host = hostButtonStatus
        tabbar.tags = aprilTags
        print ("Host button state: ", hostButtonStatus!)
    }
    
    func loadSettings(){
        let defaults = UserDefaults.standard
        socketHost = defaults.string(forKey:"socket_host")
    }
    
    func saveSettings() {
        let defaults = UserDefaults.standard
        defaults.set(socketHost, forKey: "socket_host")
    }
    
 
    //*** PROTOCOL STUBS ***
    
    func manager(_ manager: RBSManager, didDisconnect error: Error?) {
        updateButtonStates(false)
        
        print(error?.localizedDescription ?? "connection did disconnect")
    }
    
    func managerDidConnect(_ manager: RBSManager) {
        updateButtonStates(true)
        
    }
    
    func manager(_ manager: RBSManager, threwError error: Error) {
        if (manager.connected == false) {
            updateButtonStates(false)
        }
        print(error.localizedDescription)
    }
    
    
    
    
    //*** BUTTONS ***
    
    func updateButtonStates(_ connected: Bool) {
        leftButton.isEnabled = connected
        rightButton.isEnabled = connected
        downButton.isEnabled = connected
        upButton.isEnabled = connected
        toggleTeleopAuto.isEnabled = connected
        autoButton.isEnabled = connected
        publishButton.isEnabled = connected
        stopButton.isEnabled = connected
        hostButton.isEnabled = !connected
        
        
        if connected {
            let redColor = UIColor(red: 0.729, green: 0.131, blue: 0.144, alpha: 1.0)
            connectButton.backgroundColor = redColor
            connectButton.setTitle("Disconnect", for: .normal)
            
        } else {
            let greenColor = UIColor(red: 0.329, green: 0.729, blue: 0.273, alpha: 1.0)
            connectButton.backgroundColor = greenColor
            connectButton.setTitle("Connect", for: .normal)
            
        }
    }
    func updateWithMessage(_ message: Int32Message) {
        if aprilTags.isEmpty{
            aprilTags.append(message.data)
            print (aprilTags)
        }else{
            if aprilTags[aprilTags.count - 1] != message.data{
                aprilTags.append(message.data)
                print (aprilTags)
            }
        }
        
        print (aprilTags)
        
    }
 
    
    @IBAction func onDirectionButtonUp(_ button: UIButton) {
        // build the message based on the button tapped
        if allButtonsInactive() {
            controlTimer?.invalidate()
            controlTimer = nil
        }
        sendDriveMessage()
    }
    @IBAction func onHostButton(_ sender: Any) {
        // change the host used by the websocket
        let alertController = UIAlertController(title: "Enter socket host", message: "IP or name of ROS master", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField) -> Void in
            textField.placeholder = "Host"
            textField.text = self.socketHost
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
        }
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            if let textField = alertController.textFields?.first {
                self.socketHost = textField.text
                self.saveSettings()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func allButtonsInactive() -> Bool {
        if leftButton.isHighlighted || rightButton.isHighlighted || upButton.isHighlighted || downButton.isHighlighted ||
            autoButton.isHighlighted ||
            publishButton.isHighlighted{
            return false
        }
        return true
    }
    
    @IBAction func onDirectionButtonDown(_ button: UIButton) {
        // trigger the timer to start sending message
        if controlTimer == nil {
            controlTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(sendDriveMessage), userInfo: nil, repeats: true)
        }
        print("Sending drive message")
        sendDriveMessage()
        print("Drive Message sent")
    }
    
   
    
    @IBAction func deadmanSwitchChanged(_ sender: UISegmentedControl) {
        switch toggleTeleopAuto.selectedSegmentIndex{
        case 0:
            print ("Off selected")
        case 1:
            print ("Teleop selected")
        case 2:
            print ("Auto selected")
        default:
            print ("something's wrong")
        }
        
        
    }
    //send button messages along with joy stick messages
    
    @IBAction func publishMessage(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Enter publish message", message: "Publish message should be an integer", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField) -> Void in
            textField.placeholder = "Message"
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
        }
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            if let textField = alertController.textFields?.first {
                let tagMessage = StringMessage()
                tagMessage.data = textField.text!
                self.aprilTagPublisher?.publish(tagMessage)
                print (textField.text!)
            }
            
            print ("Hello world")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //*** HOW TO PUBLISH MESSAGES ***
    
    @objc func sendDriveMessage() {
        let driveMessage = JoyMessage()
        let debugMessage = StringMessage()
        debugMessage.data = "Button is not pressed"
        if upButton.isHighlighted {
            driveMessage.axes[1] = 1.0
            debugMessage.data = "Up button pressed"
        } else if downButton.isHighlighted {
            driveMessage.axes[1] = -1.0
            debugMessage.data = "Down button pressed"
        }
        
        if leftButton.isHighlighted {
            driveMessage.axes[3] = 1.0
            debugMessage.data = "Left button pressed"
        } else if rightButton.isHighlighted {
            driveMessage.axes[3] = -1.0
            debugMessage.data = "Right button pressed"
        }
        
        if autoButton.isHighlighted {
            driveMessage.buttons = [0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0]
            debugMessage.data = "Auto button pressed"
        }
        
        if stopButton.isHighlighted{
            driveMessage.buttons = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            
            racecarPublisher?.publish(driveMessage)
        }
        
        switch(toggleTeleopAuto.selectedSegmentIndex){
        case 0:
            driveMessage.buttons = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        case 1:
            driveMessage.buttons = [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0]
        case 2:
            driveMessage.buttons = [0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0]
        default:
            driveMessage.buttons = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        }
        // send the message with the publisher
        racecarPublisher?.publish(driveMessage)
        racecarDebugPublisher?.publish(debugMessage)
        
    }
    
    
    
    

    
    @IBAction func onConnectButton(_ sender: UIButton) {
        
        if racecarManager?.connected == true {
            racecarManager?.disconnect()
            hostButtonStatus = false //No longer a host
        } else {
            if socketHost != nil {
                // the manager will produce a delegate error if the socket host is invalid
                racecarManager?.connect(address: socketHost!)
                hostButtonStatus = true //There is a host
            } else {
                // print log error
                print("Missing socket host value --> use host button")
            }
        }
    }
    
    // **Segue function to pass information from remote control to publishers and subscribers
    
    
    
}

