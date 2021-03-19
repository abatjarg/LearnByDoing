import UIKit

enum EndPoint: String {
    case latestTvShows = "/tv/latest"
    case popularTvShows = "/tv/popular"
}

struct TvShows: Codable {
    var results: [TvShow]
}

struct TvShow: Codable {
    var backdropPath: URL
    var firstAirDate: Date
    var genreIds: [Int]
    var id: Int
    var name: String
    var originCountry: [String]
    var originalLanguage: String
    var originalName: String
    var overview: String
    var popularity: Double
    var posterPath: URL
    var voteAverage: Double
    var voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case genreIds = "genre_ids"
        case id
        case name
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension TvShow: Equatable {
    static func == (lhs: TvShow, rhs: TvShow) -> Bool {
        // Two Photos are the same if they have the same photoID
        return lhs.id == rhs.id
    }
}

class tmdbAPI {
    private static let baseURLString = "https://api.themoviedb.org/3"
    private static let apiKey = "0e7bf9123871b0fe728caf5636fd7e47"
    
    static var latestTvShowsURL: URL {
        return tmdbURL(endPoint: .latestTvShows, parameters: nil)
    }
    
    static var popularTvShowsURL: URL {
        return tmdbURL(endPoint: .popularTvShows, parameters: nil)
    }
    
    private static func tmdbURL(endPoint: EndPoint, parameters: [String: String]?) -> URL {
        var components = URLComponents(string: baseURLString.appending(endPoint.rawValue))!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "language": "en-US",
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
    
    static func shows(fromJSON data: Data) -> Result<TvShows, Error> {
        do {
            let decoder = JSONDecoder()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            
            let response = try decoder.decode(TvShows.self, from: data)
            return .success(response)
        } catch  {
            return .failure(error)
        }
    }
}

class ShowStore {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchPopularTvShows(completion: @escaping (Result<TvShows, Error>) -> Void) {
        let url = tmdbAPI.popularTvShowsURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            guard let jsonData = data else {
                return
            }
            let result = tmdbAPI.shows(fromJSON: jsonData)
            completion(result)
        }
        task.resume()
    }
}

let store = ShowStore()
store.fetchPopularTvShows { (response) in
    switch response {
    case let .success(response):
        for result in response.results {
            print("\(result)\n")
        }
    case let .failure(error):
        print("Error fetching interesting photos: \(error)")
    }
}
