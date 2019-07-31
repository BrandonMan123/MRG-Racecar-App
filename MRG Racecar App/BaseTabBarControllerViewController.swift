//
//  BaseTabBarControllerViewController.swift
//  MRG Racecar App
//
//  Created by Brandon Man on 23/7/2019.
//  Copyright © 2019 Brandon Man. All rights reserved.
//

import UIKit

class BaseTabBarControllerViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    var publisherTopic = "/vesc/joy"
    var debugPublisherTopic = "/listen"
    var subscriberTopic = "/detected_tags"
    var aprilTagPublisherTopic = "/aprilTag"
    var host = false
    var tags = [Int32]()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
