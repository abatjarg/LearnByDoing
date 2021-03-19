import UIKit

class FlickrPhoto: Codable {
    let title: String
    let remoteURL: URL?
    let photoID: String
    let dateTaken: Date
    
    enum CodingKeys: String, CodingKey {
        case title
        case remoteURL = "url_z"
        case photoID = "id"
        case dateTaken = "datetaken"
    }
}

extension FlickrPhoto: Equatable {
    static func == (lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
        // Two Photos are the same if they have the same photoID
        return lhs.photoID == rhs.photoID
    }
}

enum EndPoint: String {
    case interestingPhotos = "flickr.interestingness.getList"
}

class FlickrAPI {
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "a6d819499131071f158fd740860a5a88"
    
    static var interestingPhotosURL: URL {
        return flickrURL(endPoint: .interestingPhotos, parameters: ["extras": "url_z,date_taken"])
    }
    
    struct FlickrResponse: Codable {
        let photosInfo: FlickrPhotosResponse
        
        enum CodingKeys: String, CodingKey {
            case photosInfo = "photos"
        }
    }
    
    struct FlickrPhotosResponse: Codable {
        let photos: [FlickrPhoto]
        
        enum CodingKeys: String, CodingKey {
            case photos = "photo"
        }
    }
    
    private static func flickrURL(endPoint: EndPoint, parameters: [String: String]?) -> URL {
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": endPoint.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": apiKey
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        return components.url!
    }
    
    static func photos(fromJSON data: Data) -> Result<[FlickrPhoto], Error> {
        do {
            let decoder = JSONDecoder()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            let flickrResponse = try decoder.decode(FlickrResponse.self, from: data)
            let photos = flickrResponse.photosInfo.photos.filter { $0.remoteURL != nil }
            return .success(photos)
        } catch  {
            return .failure(error)
        }
    }
}

class PhotoStore {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchInterestingPhotos(completion: @escaping (Result<[FlickrPhoto], Error>) -> Void) {
        let url = FlickrAPI.interestingPhotosURL
        print("URL: \(url)")
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            let result = self.processPhotosRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    
    private func processPhotosRequest(data: Data?, error: Error?) -> Result<[FlickrPhoto], Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        switch FlickrAPI.photos(fromJSON: jsonData) {
        case let .success(flickrPhotos):
            return .success(flickrPhotos)
        case let .failure(error):
            return .failure(error)
        }
    }
}

var store = PhotoStore()

store.fetchInterestingPhotos { (photoResult) in
    switch photoResult {
        case let .success(photos):
            print("Successfully found \(photos.count) photos.")
        case let .failure(error):
            print("Error fetching interesting photos: \(error)")
    }
}
