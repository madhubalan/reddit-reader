//
//  ViewController.swift
//  Reddit-reader
//
//  Created by Madhu on 19/09/19.
//  Copyright © 2019 task. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var feeds : Feeds?
    
    
    //MARK: ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeInterface()
        getData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Helper Methods
    
    func initializeInterface(){
        self.tableView.estimatedRowHeight = 695
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        self.tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        
    }
    
    func getData()  {
        
        self.activityIndicator.startAnimating()
        NetworkManager.sharedInstance.getFeed(completion: { feeds in
            self.activityIndicator.stopAnimating()
            self.feeds = feeds
            self.tableView.reloadData()
            
        }) { (error) in
            self.activityIndicator.stopAnimating()
            let alert = UIAlertController(title: "Error", message: "Could not fetch data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                print(action.style)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}


//MARK: UITableView Datasource & Delegate Methods

extension FeedViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let feeds = self.feeds{
            return feeds.children.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let feeds = self.feeds else {
            return UITableViewCell()
        }
        
        let data = feeds.children[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedItemTableViewCell", for: indexPath) as? FeedItemTableViewCell
        cell?.scoreLbl.text = "\(data.score)"
        if let author = data.author{
            cell?.auotherLbl.text = "Posted by \(String(describing: author))"
        }
        cell?.titleLbl.text = data.title
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let feeds = self.feeds{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let urlStr = feeds.children[indexPath.row].url, let url = URL(string: urlStr),  let controller = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController{
                controller.url = url
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}

