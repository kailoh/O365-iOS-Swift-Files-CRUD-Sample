//
//  FilesViewController.swift
//  sample365
//
//  Created by Kai Loh on 1/11/15.
//  Copyright (c) 2015 Kai. All rights reserved.
//

import UIKit

class FilesViewController : UITableViewController {
    
    var files: [MSSharePointItem] = []
    var client: MSSharePointClient? = nil
    
    override func viewDidLoad() {
        
        let but1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addFile")
        self.navigationItem.rightBarButtonItem = but1
        self.navigationItem.title = "Files"
        
        var resolver : MSODataDefaultDependencyResolver = MSODataDefaultDependencyResolver()
        
        var credentials : MSODataOAuthCredentials = MSODataOAuthCredentials()
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        credentials.addToken(defaults.objectForKey("accessTokenDefault") as String)
        
        var credentialsImpl : MSODataCredentialsImpl = MSODataCredentialsImpl()
        
        credentialsImpl.setCredentials(credentials)
        
        resolver.setCredentialsFactory(credentialsImpl)
        
        client = MSSharePointClient(url: "https://clippy-my.sharepoint.com/_api/v1.0/me", dependencyResolver: resolver)
        
        self.getFiles()
        self.tableView.allowsMultipleSelection = false
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.purpleColor()
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: "getFiles", forControlEvents: UIControlEvents.ValueChanged)

        
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.files.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : FileCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath:indexPath) as FileCell
        
        var file: MSSharePointItem = self.files[indexPath.row]
        cell.label.text = file.name

        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            var fileToDelete: MSSharePointItem = self.files[indexPath.row] as MSSharePointItem
            self.client?.getfiles().getById(fileToDelete.id).addCustomHeaderWithName("If-Match", andValue: "*").deleteItem!({ (status: Int32, exception: MSODataException?) -> Void in
                if (exception == nil) {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.getFiles()
                    })
                } else {
                    println("EXCEPTION: \(exception)")
                }
            }).resume()
        }
    }
    
    func getFiles() {
        client!.getfiles().read{(someObjects:[AnyObject]!, exception:MSODataException?) -> Void in
            if (exception == nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.files = someObjects as [MSSharePointItem]
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                    println("messages obtained")
                })
            } else {
                
                println("Error: \(exception)")
            }
        }.resume()
    }
    
    func addFile() {
        let addFileViewController: AddFileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddFileViewController") as AddFileViewController
        addFileViewController.filesViewController = self
        self.navigationController?.pushViewController(addFileViewController, animated: true)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let editFileViewController: EditFileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EditFileViewController") as EditFileViewController
        editFileViewController.filesViewController = self
        editFileViewController.currentFile = self.files[indexPath.row]
        self.navigationController?.pushViewController(editFileViewController, animated: true)
    }
    
}
