//
//  HomeViewController.swift
//  NewsKit
//
//  Created by Sultan Rifaldy on 10/05/23.
//

import UIKit
import SDWebImage
import SafariServices

class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    weak var collectionView: UICollectionView?
    weak var refreshControl: UIRefreshControl!
    weak var pageControl: UIPageControl?
    
    var latestNewsList: [Articles] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "NewsViewCell", bundle: nil), forCellReuseIdentifier: "custom_news_cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        self.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(readingListDeleted(_:)), name: .deleteReadingList, object: nil)
        
        refreshControl.beginRefreshing()
        loadLatestNews()
    }
    
    @objc func readingListDeleted(_ sender: Any) {
        tableView.reloadData()
    }
    
    @objc func refresh(_ sender: Any) {
        loadLatestNews()
    }
    
    func loadLatestNews() {
        ApiService.shared.loadNews { result in
            self.refreshControl.endRefreshing()
            switch result {
            case .success(let newsList):
                self.latestNewsList =  newsList
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return latestNewsList.count > 0 ? 1 : 0
        } else {
            return latestNewsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "top_news_list_cell", for: indexPath) as! TopNewsListViewCell
            
            cell.titleLabel.text = "News For You"
            cell.subtitleLabel.text = "Top \(latestNewsList.count) news of the day"
            cell.pageControl.currentPage = latestNewsList.count
            self.pageControl = cell.pageControl
            self.collectionView = cell.collectionView
            
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            
            cell.delegate = self
            
            return cell
            
        } else {
            
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "custom_news_cell", for:  indexPath) as! NewsViewCell
            
            let news = latestNewsList[indexPath.row]
            
            cell.titileLabel.text = news.title
            cell.subtitleLabel.text = news.date
            
            
            if CoreDataStorage.shared.isAddedToReadingList(url: news.url) {
                if #available(iOS 13.0, *) {
                    cell.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                }
                cell.bookmarkButton.isEnabled = false
            } else {
                if #available(iOS 13.0, *) {
                    cell.bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
                }
                cell.bookmarkButton.isEnabled = true
            }
           
            cell.delegate = self
            
            cell.thumbImageView.sd_setImage(with: URL(string: news.image))
            
            return cell
        }
    }
}


extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else {
            return
        }
        
        let news = latestNewsList[indexPath.row]
        
        if let url = URL(string: news.url) {
            let controller = SFSafariViewController(url: url)
            present(controller, animated: true)
        }
        
    }
}


extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return latestNewsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "top_news_view_cell", for: indexPath) as! TopNewsViewCell
        
        let news = latestNewsList[indexPath.item]
        cell.thumbImageView.sd_setImage(with: URL(string: news.image))
        cell.titleLabel.text = news.title
        cell.subtitleLabel.text = news.date
        
        return cell
    }
}


extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: 256)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView != self.tableView{
            let page = Int (scrollView.contentOffset.x / scrollView.frame.width)
            pageControl?.currentPage = page
        }
    }
}


extension HomeViewController: NewsViewCellDelegate {
    func newsViewCellBookmarkButtonTapped(_ cell: NewsViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let news = latestNewsList[indexPath.row]
            
            CoreDataStorage.shared.addReadingList(articles: news)
            
            
            if #available(iOS 13.0, *) {
                cell.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }

            cell.bookmarkButton.isEnabled = false

        }
    }
}

extension HomeViewController: TopNewsListViewCellDelegate {
    func topListViewCellPageControlValueChanged(_ cell: TopNewsListViewCell) {
        let page = cell.pageControl.currentPage
        collectionView?.scrollToItem(at: IndexPath(item: page, section: 0), at: .centeredHorizontally, animated: true)
    }
}
