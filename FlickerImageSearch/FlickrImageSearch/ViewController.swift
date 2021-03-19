//
//  ViewController.swift
//  FlickerImageSearch
//
//  Created by AJ Batja on 2/21/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    var store: PhotoStore!
    var photos: [Photo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
        store.fetchInterestingPhotos { (photoResult) in
            switch photoResult {
                case let .success(photos):
                    print("Successfully found \(photos.count) photos.")
                    self.photos = photos
                    self.photosCollectionView.reloadData()
                case let .failure(error):
                    print("Error fetching interesting photos: \(error)")
            }
        }
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "photosCollectionViewCell", for: indexPath) as! FlickrCollectionViewCell
        let photo = photos[indexPath.row]
        store.fetchImage(for: photo) { (result) in
            guard let photoIndex = self.photos.firstIndex(of: photo), case let .success(image) = result else { return }
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            
            if let cell = self.photosCollectionView.cellForItem(at: photoIndexPath) as? FlickrCollectionViewCell {
                cell.imageView.image = image
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPhoto":
            if let selectedIndexPath = photosCollectionView.indexPathsForSelectedItems?.first {
                let photo = photos[selectedIndexPath.row]
                let dvc = segue.destination as! PhotoViewController
                dvc.photo = photo
                dvc.store = store
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
}

