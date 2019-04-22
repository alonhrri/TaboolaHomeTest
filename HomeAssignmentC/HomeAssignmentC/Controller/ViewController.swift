//
//  ViewController.swift
//  HomeAssignmentC
//
//  Created by Alon Harari on 22/04/2019.
//  Copyright © 2019 Alon Harari. All rights reserved.
//

//MARK: - Properties of class
import UIKit
import TaboolaFramework


//MARK: - Class
class ViewController: UIViewController {
    
    @IBAction func goToSecondApp(_ sender: Any) {
        chooseColor()
    }
    
    //MARK: - Properties of class
    @IBOutlet weak var collectionView: UICollectionView!
    var colorStr : String?
    var items = [Amazon]()
    
    var taboolaWidget : TaboolaView!
    var taboolaFeed : TaboolaView!
    var taboolaWidgetHeight: CGFloat = 0.0
    
    fileprivate struct TaboolaRow {
        let placement: String
        let mode: String
        let index: Int
        let scrollIntercept: Bool
        
        static let widget = TaboolaRow(placement: "Below Article", mode: "alternating-widget-without-video", index: 2, scrollIntercept: false)
        static let feed = TaboolaRow(placement: "Feed without video", mode: "thumbs-feed-01", index: 8, scrollIntercept: true)
    }
    
    //MARK: - ViewController LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setColor()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taboolaWidget = taboolaView(mode: TaboolaRow.widget.mode,
                                    placement: TaboolaRow.widget.placement,
                                    scrollIntercept: TaboolaRow.widget.scrollIntercept)
        taboolaFeed = taboolaView(mode: TaboolaRow.feed.mode,
                                  placement: TaboolaRow.feed.placement,
                                  scrollIntercept: TaboolaRow.feed.scrollIntercept)
        //setColor()
        fetchJSON()
    }
    // MARK: - Taboola methods
    
    func taboolaView(mode: String, placement: String, scrollIntercept: Bool) -> TaboolaView {
        let taboolaView = TaboolaView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200))
        taboolaView.delegate = self
        taboolaView.ownerViewController = self
        taboolaView.mode = mode
        taboolaView.publisher = "sdk-tester"
        taboolaView.pageType = "article"
        taboolaView.pageUrl = "https://www.ynet.co.il"
        taboolaView.placement = placement
        taboolaView.targetType = "mix"
        taboolaView.setInterceptScroll(scrollIntercept)
        taboolaView.logLevel = .debug
        taboolaView.setOptionalModeCommands(["useOnlineTemplate": true])
        taboolaView.fetchContent()
        taboolaView.autoResizeHeight = true
        
        
        
        taboolaView.setProgressBarEnabled(true)
        taboolaView.progressBarColor = "#4286f4"
        taboolaView.progressBarAnimationTime = 3
        
        
        return taboolaView
    }
    deinit {
        taboolaWidget.reset()
        taboolaFeed.reset()
    }
    // MARK: - Private methods
    
    fileprivate func setColor() {
        
        if let color = colorStr {
            let array = color.components(separatedBy: ",").map{
                ($0 as NSString).floatValue}
            let chossenColor = UIColor(red: CGFloat(array[0]/255), green: CGFloat(array[1]/255), blue: CGFloat(array[2]/255), alpha: 1)
            self.collectionView.backgroundColor = chossenColor
            self.taboolaWidget.backgroundColor = chossenColor
            self.taboolaFeed.backgroundColor = chossenColor
        }
    }
    fileprivate func fetchJSON() {
        //let urlString = "https://s3-us-west-2.amazonaws.com/taboola-mobile-sdk/public/home_assignment/data.json"
        let urlString = "https://api.myjson.com/bins/ct1nw"
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            DispatchQueue.main.async {
                if let err = err {
                    print("Failed to get data from url:", err)
                    return
                }
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    self.items = try decoder.decode([Amazon].self, from: data)
                    self.insert2EmptyCells()
                    self.collectionView.reloadData()
                } catch let jsonErr {
                    print("Failed tp decode:", jsonErr)
                }
            }
            }.resume()
    }
    fileprivate func insert2EmptyCells() {
        
        let emptyCell = Amazon(name:nil, thumbnail: nil, description:nil)
        self.items.insert(emptyCell, at: 2)
        self.items.insert(emptyCell, at: 8)
        
    }
    fileprivate func configureCell(_ cell: AmazonCell, with item: Amazon) {
        cell.nameLabel.text =  item.name
        cell.descriptionLabel.text = item.description
        if let url = item.thumbnail{
            cell.thumnailImageView.loadImageUsingCacheWithURLString(url, placeHolder: UIImage(named: "placeholder"))
        }
    }
    fileprivate func chooseColor() {
        
        let application = UIApplication.shared
        let secondAppPath = "secondApp://"
        let appUrl = URL(string: secondAppPath)!
        let websiteUrl = URL(string: "https://taboola.com")!
        if application.canOpenURL(appUrl) {
            application.open(appUrl, options: [:], completionHandler: nil)
        } else {
            application.open(websiteUrl)
        }
    }
    
}

// MARK: - UICollectionView  Delegate and DataSource Extension

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case TaboolaRow.widget.index:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaboolaCell", for: indexPath) as? TaboolaCell ?? TaboolaCell()
            cell.contentView.addSubview(taboolaWidget)
            return cell
        case TaboolaRow.feed.index:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaboolaCell", for: indexPath) as? TaboolaCell ?? TaboolaCell()
            cell.contentView.addSubview(taboolaFeed)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AmazonCell", for: indexPath) as? AmazonCell ?? AmazonCell()
            let amazonItem = self.items[indexPath.row]
            configureCell(cell, with: amazonItem)
            return cell
        }
    }
}
// MARK: - UICollectionView FlowLayout Delegate Extension
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case TaboolaRow.widget.index:
            if taboolaWidgetHeight > 0 {
                return CGSize(width: view.frame.size.width, height: taboolaWidgetHeight)
            }
            else {
                return CGSize(width: view.frame.size.width, height: 0)
            }
        case TaboolaRow.feed.index:
            return CGSize(width: view.frame.size.width, height: TaboolaView.widgetHeight())
        default:
            if let descriptionText = self.items[indexPath.row].description {
                print(description)
                
                let approximateWidthOfBioTextView = view.frame.width - 8 - 8 - 8
                
                let size = CGSize(width: approximateWidthOfBioTextView, height: 1000)
                
                let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
                
                let estimatedFrame = NSString(string: descriptionText).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                return CGSize(width: view.frame.width, height: estimatedFrame.height + 274)
                
            }
            return CGSize(width: view.frame.width, height: 200)
        }
    }
    func scrollViewDidScroll(toTopTaboolaView taboolaView: UIView!) {
        if taboolaFeed.scrollEnable {
            print("did finish scrolling taboola")
            taboolaFeed.scrollEnable = false
            collectionView.isScrollEnabled = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didEndScrollOfParrentScroll()
    }
    
    func didEndScrollOfParrentScroll(){
        let height = collectionView.frame.size.height
        var yContentOffset = collectionView.contentOffset.y
        
        if #available(iOS 11.0, *) {
            yContentOffset = yContentOffset - collectionView.adjustedContentInset.bottom
        } else {
            yContentOffset = yContentOffset - collectionView.contentInset.bottom
        }
        
        let distanceFromBotton = collectionView.contentSize.height - yContentOffset
        if distanceFromBotton < height, collectionView.isScrollEnabled, collectionView.contentSize.height > 0 {
            collectionView.isScrollEnabled = false
            taboolaFeed.scrollEnable = true
        }
    }
}

// MARK: - TaboolaView Delegate Extension
extension ViewController: TaboolaViewDelegate {
    func taboolaView(_ taboolaView: UIView!, didLoadPlacementNamed placementName: String!, withHeight height: CGFloat) {
        if placementName == TaboolaRow.widget.placement {
            taboolaWidgetHeight = height
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    func taboolaView(_ taboolaView: UIView!, didFailToLoadPlacementNamed placementName: String!, withErrorMessage error: String!) {
        print("Did fail: \(String(describing: placementName)) error: \(String(describing: error))")
    }
    
    func onItemClick(_ placementName: String!, withItemId itemId: String!, withClickUrl clickUrl: String!, isOrganic organic: Bool) -> Bool {
        return true
    }
}


