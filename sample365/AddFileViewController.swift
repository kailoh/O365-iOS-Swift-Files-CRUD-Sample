//
//  AddFileViewController.swift
//  sample365
//
//  Created by Kai Loh on 1/11/15.
//  Copyright (c) 2015 Kai. All rights reserved.
//

import UIKit

class AddFileViewController : UIViewController {
    
    @IBOutlet weak var bodyTextField: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    
    var filesViewController: FilesViewController? = nil
    
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func uploadFile(sender: AnyObject) {
        var newItem : MSSharePointItem = MSSharePointItem()
        newItem.name = titleTextField.text
        newItem.type = "File"
        let content = bodyTextField.text
        let encodedContent = content.dataUsingEncoding(NSUTF8StringEncoding)
        
        self.filesViewController!.client?.getfiles().addItem(newItem, withCallback: { (item:MSSharePointItem?, exception:MSODataException?) -> Void in
            if (exception == nil) {
                self.filesViewController!.client?.getfiles().getById(item!.id).asFile().putContent(encodedContent, withCallback: { (result: Int, exception:MSODataException?) -> Void in
                    if (exception == nil) {
                        dispatch_async(dispatch_get_main_queue(), {
                            println("Result: \(result)")
                            println("We are done")
                            self.filesViewController!.getFiles()
                            self.navigationController?.popViewControllerAnimated(true)
                        })
                        
                    } else {
                        println("Exception: \(exception)")
                    }
                }).resume()
                
            } else {
                println("Exception: \(exception)")
            }
        }).resume()
    }
    
    
}