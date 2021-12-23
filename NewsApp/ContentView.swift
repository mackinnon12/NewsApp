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
    
    enum CodingKeys: CodingKey {
        case author
        case title
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        author = try container.decode(String.self, forKey: .author)
        title = try container.decode(String.self, forKey: .title)
    }
}
//View Story
struct StoryView: View {
    let title: String
    let author: String

    var body: some View {
        Text(title)
            .font(.title2)
        Text("Written By: \(author)")
            .font(.subheadline)
    }
}

struct ContentView: View {
    @State private var articles = [Article]()
    func loadData() async {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=c2d3bd7de4b94226abe97ef19abd21a3") else {
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
                NavigationLink(destination: StoryView(title: item.title, author: item.author)) {
                    
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
