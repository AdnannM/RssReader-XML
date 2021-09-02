//
//  ViewController.swift
//  RssReader XML
//
//  Created by Adnann Muratovic on 02.09.21.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    private var rssItems: [ArticleItem]?
    
    enum CellState {
        case expended
        case collapsed
    }
    
    private var cellStates: [CellState]?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "News"
        
        tableView.estimatedRowHeight = 155.0
        tableView.rowHeight = UITableView.automaticDimension
        
        parseXML()

    }

    func parseXML() {
                
        let feedParser = FeedParser()
        feedParser.parseFeed(feedUrl: "https://www.nasa.gov/rss/dyn/breaking_news.rss", completionHandler: { (rssItem: [ArticleItem]) -> Void in
            
            self.rssItems = rssItem
            
            self.cellStates = [CellState](repeating: .collapsed, count: rssItem.count)
            
            OperationQueue.main.addOperation { () -> Void in
                self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension NewsTableViewController {
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rssItems = rssItems else {
            return 0
        }
        
        return rssItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsTableViewCell
        
        if let item = rssItems?[indexPath.row] {
            cell.titleLabel.text = item.title
            cell.descriptionLabel.text = item.description
            cell.dateLabel.text = item.pubDate
            
            if let cellStates = cellStates {
                cell.descriptionLabel.numberOfLines = (cellStates[indexPath.row] == .expended) ? 0 : 4
            }
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! NewsTableViewCell
        tableView.beginUpdates()
        cell.descriptionLabel.numberOfLines = (cell.descriptionLabel.numberOfLines == 0) ? 4 : 0
        cellStates?[indexPath.row] = (cell.descriptionLabel.numberOfLines == 0) ? .expended : .collapsed
        tableView.endUpdates()
    }
}




