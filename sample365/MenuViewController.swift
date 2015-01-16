//
//  ViewController.swift
//  sample365
//
//  Created by Kai Loh on 1/11/15.
//  Copyright (c) 2015 Kai. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    var resourceID : String = "https://clippy-my.sharepoint.com"
    var authorityURL : String = "https://login.windows.net/clippy.onmicrosoft.com"
    var clientID : String = "6b909311-ad01-4adf-8bc7-58f2244b732e"
    var redirectURI : NSURL = NSURL(string: "https://www.google.com")!

    override func viewDidLoad() {
        super.viewDidLoad()
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        var er : ADAuthenticationError? = nil
        var authContext:ADAuthenticationContext = ADAuthenticationContext(authority: authorityURL, error: &er)
        
        authContext.acquireTokenWithResource(resourceID, clientId: clientID, redirectUri: redirectURI) { (result: ADAuthenticationResult!) -> Void in
            if (result.accessToken == nil) {
                println("token nil")
            } else {
                defaults.setObject(result.accessToken, forKey: "accessTokenDefault")
                defaults.synchronize()
                println("accessToken: \(result.accessToken)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

