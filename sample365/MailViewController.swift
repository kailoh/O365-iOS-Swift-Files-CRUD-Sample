//
//  MailViewController.swift
//  sample365
//
//  Created by Kai Loh on 1/15/15.
//  Copyright (c) 2015 Kai. All rights reserved.
//

import UIKit

class MailViewController : UITableViewController {
    
    var messages: [MSOutlookMessage] = []
    var client: MSOutlookClient? = nil
    
    override func viewDidLoad() {
        
        let but1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addMail")
        self.navigationItem.rightBarButtonItem = but1
        self.navigationItem.title = "Mail"
        
        var resolver : MSODataDefaultDependencyResolver = MSODataDefaultDependencyResolver()
        
        var credentials : MSODataOAuthCredentials = MSODataOAuthCredentials()
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        credentials.addToken(defaults.objectForKey("accessTokenDefault") as String)
        
        var credentialsImpl : MSODataCredentialsImpl = MSODataCredentialsImpl()
        
        credentialsImpl.setCredentials(credentials)
        
        resolver.setCredentialsFactory(credentialsImpl)
        
        client = MSOutlookClient(url: "https://outlook.office365.com/api/v1.0", dependencyResolver: resolver)

        
        self.tableView.allowsMultipleSelection = false
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.purpleColor()
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: "getMessages", forControlEvents: UIControlEvents.ValueChanged)
        
        
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : MailCell = tableView.dequeueReusableCellWithIdentifier("mailCell", forIndexPath:indexPath) as MailCell
        
        var message: MSOutlookMessage = self.messages[indexPath.row]
        cell.fromLabel.text = message.From.EmailAddress.description
        cell.subjectLabel.text = message.Subject
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.Delete) {
//            var fileToDelete: MSSharePointItem = self.files[indexPath.row] as MSSharePointItem
//            self.client?.getfiles().getById(fileToDelete.id).addCustomHeaderWithName("If-Match", andValue: "*").deleteItem!({ (status: Int32, exception: MSODataException?) -> Void in
//                if (exception == nil) {
//                    dispatch_async(dispatch_get_main_queue(), {
//                        self.getFiles()
//                    })
//                } else {
//                    println("EXCEPTION: \(exception)")
//                }
//            }).resume()
//        }
    }
    
    func getMessages() {
        client!.getMe().getMessages().read{(someObjects:[AnyObject]!, exception:MSODataException?) -> Void in
            if (exception == nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.messages = someObjects as [MSOutlookMessage]
                    self.tableView.reloadData()
                })
            } else {
                println("Error: \(exception)")
            }
            }.resume()
    }
    
    func addMail() {
//        let addFileViewController: AddFileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddFileViewController") as AddFileViewController
//        addFileViewController.filesViewController = self
//        self.navigationController?.pushViewController(addFileViewController, animated: true)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let editFileViewController: EditFileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EditFileViewController") as EditFileViewController
//        editFileViewController.filesViewController = self
//        editFileViewController.currentFile = self.files[indexPath.row]
//        self.navigationController?.pushViewController(editFileViewController, animated: true)
    }



}