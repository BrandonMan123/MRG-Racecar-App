//
//  PubAndSubViewController.swift
//  MRG Racecar App
//
//  Created by Brandon Man on 23/7/2019.
//  Copyright © 2019 Brandon Man. All rights reserved.
//

import UIKit

class PubAndSubViewController: UIViewController {
    
    
    @IBOutlet var publisher: UILabel!
    @IBOutlet var subscriber: UILabel!
    @IBOutlet var warning: UILabel!
    @IBOutlet var pubTextField: UITextField!
    @IBOutlet var subTextField: UITextField!
    
    
    @IBOutlet var debugPubTextField: UITextField!
    @IBOutlet var debugPublisher: UILabel!
    
    @IBOutlet var aprilTagPublisher: UILabel!
    @IBOutlet var aprilTagPublisherTextField: UITextField!
    
    var hostStatus:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func publisherEdited(_ sender: UITextField) {
        print ("Hello world!")
        print ("Publisher text field is:" + String(pubTextField.text!))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let tabbar = tabBarController as! BaseTabBarControllerViewController
        tabbar.publisherTopic = pubTextField.text!
        tabbar.debugPublisherTopic = debugPubTextField.text!
        tabbar.subscriberTopic = subTextField.text!
        tabbar.aprilTagPublisherTopic = aprilTagPublisherTextField.text!
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let tabbar = tabBarController as! BaseTabBarControllerViewController
        
        hostStatus = Bool(tabbar.host)
        print ("Host status in pub and sub: ",hostStatus)
        pubTextField.text = String(tabbar.publisherTopic)
        debugPubTextField.text = String(tabbar.debugPublisherTopic)
        subTextField.text = String(tabbar.subscriberTopic)
        aprilTagPublisherTextField.text = String(tabbar.aprilTagPublisherTopic)
        
        //if there is a host, then it is true; if there is not a host status, then it is false
        if hostStatus == true{
            publisher.isHidden = true
            pubTextField.isHidden = true
            subscriber.isHidden = true
            subTextField.isHidden = true
            debugPublisher.isHidden = true
            debugPubTextField.isHidden = true
            aprilTagPublisherTextField.isHidden = true
            aprilTagPublisher.isHidden = true
            warning.isHidden = false
        }else if hostStatus == false{
            publisher.isHidden = false
            pubTextField.isHidden = false
            subscriber.isHidden = false
            subTextField.isHidden = false
            debugPublisher.isHidden = false
            debugPubTextField.isHidden = false
            aprilTagPublisherTextField.isHidden = false
            aprilTagPublisher.isHidden = false
            warning.isHidden = true
        }
    }
    
   //add a load settings and save settings function
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
