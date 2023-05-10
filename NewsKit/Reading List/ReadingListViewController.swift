//
//  ReadingListViewController.swift
//  NewsKit
//
//  Created by Sultan Rifaldy on 10/05/23.
//

import UIKit
import SafariServices
import SDWebImage

class ReadingListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var readingList: [Articles] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "NewsViewCell", bundle: nil), forCellReuseIdentifier: "custom_news_cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(readingListAdded(_:)), name: .addReadingList, object: nil)
      
        loadReadingList()
        
    }
    
    @objc func readingListAdded(_ sender: Any) {
        loadReadingList()
        tableView.reloadData()
    }
    
    func loadReadingList() {
        readingList = CoreDataStorage.shared.getReadingList()
    }

}

//MARK: -UITableViewDataSource
extension ReadingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        readingList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom_news_cell", for:  indexPath) as! NewsViewCell
        
        let news = readingList[indexPath.row]
        cell.titileLabel.text = news.title
        cell.subtitleLabel.text = news.date
        
        cell.bookmarkButton.isHidden = true
        
        cell.thumbImageView.sd_setImage(with: URL(string: news.image))
        
        return cell
    }
}

//MARK: -UITableViewDelegate
extension ReadingListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = readingList[indexPath.row]
        if let url = URL(string: news.url) {
            let viewController = SFSafariViewController(url: url)
            present(viewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteActions = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
            
            let news = self.readingList.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            CoreDataStorage.shared.deleteReadingList(url: news.url)
            
            completion(true)
        }
        
        if #available(iOS 13.0, *) {
            deleteActions.image = UIImage(systemName: "trash")
        }
        
        
        
        return UISwipeActionsConfiguration(actions: [deleteActions])
    }
}
