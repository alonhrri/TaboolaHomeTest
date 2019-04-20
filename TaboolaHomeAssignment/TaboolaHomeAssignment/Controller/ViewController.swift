//
//  ViewController.swift
//  TaboolaHomeAssignment
//
//  Created by Alon Harari on 20/04/2019.
//  Copyright © 2019 Alon Harari. All rights reserved.
//

//MARK: - Properties of class
import UIKit

//MARK: - Class
class ViewController: UIViewController {
    
    //MARK: - Properties of class
    @IBOutlet weak var collectionView: UICollectionView!
    var items = [Amazon]()

    //MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchJSON()
    }
    
    // MARK: - Private methods
    fileprivate func fetchJSON() {
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

}

// MARK: - UICollectionView  Delegate and DataSource Extension

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AmazonCell", for: indexPath) as? AmazonCell ?? AmazonCell()
        let amazonItem = self.items[indexPath.row]
        configureCell(cell, with: amazonItem)
        return cell
    }
    
}
// MARK: - UICollectionView FlowLayout Delegate Extension
extension ViewController: UICollectionViewDelegateFlowLayout {
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
