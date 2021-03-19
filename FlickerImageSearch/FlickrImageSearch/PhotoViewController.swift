//
//  PhotoViewController.swift
//  FlickerImageSearch
//
//  Created by AJ Batja on 2/25/21.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        store.fetchImage(for: photo) { (result) -> Void in
            switch result {
                case let .success(image):
                    self.imageView.image = image
                case let .failure(error):
                    print("Error fetching image for photo: \(error)")
            }
        }
    }
    


}
