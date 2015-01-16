//
//  EditFileViewController.swift
//  sample365
//
//  Created by Kai Loh on 1/13/15.
//  Copyright (c) 2015 Kai. All rights reserved.
//

import UIKit

class EditFileViewController : UIViewController {
    
    var currentFile : MSSharePointItem? = nil
    var fileId : String? = nil
    var filesViewController: FilesViewController? = nil
    
    @IBOutlet weak var propertiesLabel: UILabel!
    @IBOutlet weak var contentView: UITextView!
    
    override func viewDidLoad() {
        
        fileId = currentFile!.id
        filesViewController!.client?.getfiles().getById(fileId).asFile().getContentWithCallback({ (data: NSData?, exception: MSODataException?) -> Void in
            if (exception == nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    let fileContent = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    self.contentView.text = fileContent
                    self.navigationItem.title = self.currentFile?.name
              
                    self.propertiesLabel.text = "DateTimeLastModified: \(self.currentFile!.dateTimeLastModified)"
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    var alert = UIAlertController(title: "Cannot Get Content", message: "If it's a folder, get content won't work. Try again later. Check output for possible errors.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                        self.navigationController?.popViewControllerAnimated(true)
                        return
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
        }).resume()
        
        super.viewDidLoad()
    }
    
    @IBAction func saveChanges(sender: AnyObject) {
        let encodedContent = contentView.text.dataUsingEncoding(NSUTF8StringEncoding)
        filesViewController!.client?.getfiles().getById(fileId).asFile().putContent(encodedContent, withCallback: { (result: Int, exception:MSODataException?) -> Void in
            if (exception == nil) {
                dispatch_async(dispatch_get_main_queue(), {
                    self.filesViewController?.getFiles()
                    var alert = UIAlertController(title: "Changes saved", message: "File updated", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                        self.navigationController?.popViewControllerAnimated(true)
                        return
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.navigationController?.popViewControllerAnimated(true)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    var alert = UIAlertController(title: "Cannot Update File", message: "Try again later. Check output for possible errors.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                        self.navigationController?.popViewControllerAnimated(true)
                        return
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                })
            }
        }).resume()
        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
