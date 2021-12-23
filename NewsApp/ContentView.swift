//
//  ContentView.swift
//  NewsApp
//
//  Created by Jacob MacKinnon on 2021-12-23.
//

import SwiftUI
struct Response: Codable {
    var articles: [Article]
}

struct Article: Codable, Identifiable {
    var id = UUID()
    var author: String
    var title: String
    var description: String
    var url: String
    var urlToImage: String
    
    enum CodingKeys: CodingKey {
        case author
        case title
        case description
        case url
        case urlToImage
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        author = try container.decode(String.self, forKey: .author)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        url = try container.decode(String.self, forKey: .url)
        urlToImage = try container.decode(String.self, forKey: .urlToImage)
    }
}
//View Story
struct StoryView: View {
    let title: String
    let author: String
    let description: String
    let url: String
    let urlToImage: String
    
    var body: some View {
        //AsyncImage(url: URL(string: urlToImage))
        AsyncImage(url: URL(string: urlToImage)) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 250, height: 250)
            VStack(alignment: .center) {
                Text(title)
                    .fontWeight(.bold)
                    .font(.title2)
                Text("Written By: \(author)")
                    .font(.subheadline)
                Text("\(description)")
                    .font(.body)
                    .padding(5)
                Link("Continue Reading", destination: URL(string: url)!)
                Spacer()
                Spacer()
                Spacer()
        }
    }
}
//api keys
//82a5b077813e4ab18af51156ffe779f1
//c2d3bd7de4b94226abe97ef19abd21a3
//daf917ff9f654c36878582b201d54693
struct ContentView: View {
    @State private var articles = [Article]()
    func loadData() async {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=82a5b077813e4ab18af51156ffe779f1") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                articles = decodedResponse.articles
            }
        } catch {
            print("Invalid data")
        }
    }
    var body: some View {
        NavigationView {
            List(articles, id: \.id) { item in
                NavigationLink(destination: StoryView(title: item.title, author: item.author, description: item.description, url: item.url, urlToImage: item.urlToImage)) {
                    
                    VStack(alignment: .leading) {
                        Text(item.author)
                            .font(.headline)
                        Text(item.title)
                    }
                }
            }.task {
                await loadData()
            }.navigationTitle("Top Tech Stories")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
