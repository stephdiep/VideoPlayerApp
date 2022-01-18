//
//  VideoManager.swift
//  VideoFinder
//
//  Created by Stephanie Diep on 2022-01-18.
//

import Foundation

// An enumeration of the tags query our app offers
enum Query: String, CaseIterable {
    case nature, animals, people, ocean, food
}

class VideoManager: ObservableObject {
    @Published private(set) var videos: [Video] = []
    @Published var selectedQuery: Query = Query.nature {
        // Once the selectedQuery variable is set, we'll call the API again
        didSet {
            Task.init {
                await findVideos(topic: selectedQuery)
            }
        }
    }
    
    // On initialize of the class, fetch the videos
    init() {
        // Need to Task.init and await keyword because findVideos is an asynchronous function
        Task.init {
            await findVideos(topic: selectedQuery)
        }
    }
    
    // Fetching the videos asynchronously
    func findVideos(topic: Query) async {
        do {
        // Make sure we have a URL before continuing
        guard let url = URL(string: "https://api.pexels.com/videos/search?query=\(topic)&per_page=10&orientation=portrait") else { fatalError("Missing URL") }
        
        // Create a URLRequest
        var urlRequest = URLRequest(url: url)
        
        // Setting the Authorization header of the HTTP request - replace YOUR_API_KEY by your own API key
        urlRequest.setValue("YOUR_API_KEY", forHTTPHeaderField: "Authorization")
        
            // Fetching the data
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            // Making sure the response is 200 OK before continuing
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }
            
            // Creating a JSONDecoder instance
            let decoder = JSONDecoder()
            
            // Allows us to convert the data from the API from snake_case to cameCase
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            // Decode into the ResponseBody struct below
            let decodedData = try decoder.decode(ResponseBody.self, from: data)
            
            // Setting the videos variable
            DispatchQueue.main.async {
                // Reset the videos (for when we're calling the API again)
                self.videos = []
                
                // Assigning the videos we fetched from the API
                self.videos = decodedData.videos
            }

        } catch {
            // If we run into an error, print the error in the console
            print("Error fetchig data from Pexels: \(error)")
        }
    }
}

// ResponseBody structure that follow the JSON data we get from the API
// Note: We're not adding all the variables returned from the API since not all of them are used in the app
struct ResponseBody: Decodable {
    var page: Int
    var perPage: Int
    var totalResults: Int
    var url: String
    var videos: [Video]
    
}

struct Video: Identifiable, Decodable {
    var id: Int
    var image: String
    var duration: Int
    var user: User
    var videoFiles: [VideoFile]
    
    struct User: Identifiable, Decodable {
        var id: Int
        var name: String
        var url: String
    }
    
    struct VideoFile: Identifiable, Decodable {
        var id: Int
        var quality: String
        var fileType: String
        var link: String
    }
}
