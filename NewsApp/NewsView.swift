//
//  NewsView.swift
//  NewsApp
//
//  Created by Jacob MacKinnon on 2022-01-31.
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
    var publishedAt: String
    
    enum CodingKeys: CodingKey {
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        author = try container.decode(String.self, forKey: .author)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        url = try container.decode(String.self, forKey: .url)
        urlToImage = try container.decode(String.self, forKey: .urlToImage)
        publishedAt = try container.decode(String.self, forKey: .publishedAt)
    }
}
//View Story
struct StoryView: View {
    let title: String
    let author: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    
    var body: some View {
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
//Sources https://newsapi.org/docs/endpoints/sources
//BBC https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=c2d3bd7de4b94226abe97ef19abd21a3
//CBC https://newsapi.org/v2/top-headlines?sources=cbc-news&apiKey=daf917ff9f654c36878582b201d54693
struct NewsView: View {
    
    var newsChoice: String
    
    @State private var apiNews = "https://newsapi.org/v2/top-headlines?sources=cbc-news&apiKey=c2d3bd7de4b94226abe97ef19abd21a3"
    
    @State private var navTitle = "cbcBanner"
    
    @State private var articles = [Article]()
    func loadData() async {
        guard let url = URL(string: apiNews) else {
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
                NavigationLink(destination: StoryView(title: item.title, author: item.author, description: item.description, url: item.url, urlToImage: item.urlToImage, publishedAt: item.publishedAt)) {
                    VStack {
                        AsyncImage(url: URL(string: item.urlToImage)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 275, height: 200)
                        .cornerRadius(radius: 10, corners: [.topLeft])
                        HStack {
                            VStack(alignment: .leading) {
                                Image(navTitle)
                                    .resizable()
                                    .frame(width: 100, height: 15)
                                Text(item.title)
                                    .font(.subheadline)
                                    .fontWeight(.heavy)
                                    .foregroundColor(.black)
                                Divider()
                                let time = item.publishedAt.replacingOccurrences(of: "[a-zA-Z]+.*[a-zA-Z]+", with: "", options: [.regularExpression])
                                Text("Published at \(time)")
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }
                        }
                        .padding()
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding([.horizontal])
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }.task {
                if (newsChoice == "cbc") {
                    navTitle = "cbcBanner"
                    apiNews = "https://newsapi.org/v2/top-headlines?sources=cbc-news&apiKey=daf917ff9f654c36878582b201d54693"
                } else if (newsChoice == "bbc") {
                    navTitle = "bbcLogo"
                    apiNews = "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=daf917ff9f654c36878582b201d54693"
                }
                await loadData()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text("News")
                            .font(.title)
                            .fontWeight(.heavy)
                        Divider()
                        Text(Date.now, format: .dateTime.month(.wide).day())
                            .font(.title2)
                            .foregroundColor(.gray)
                            .fontWeight(.heavy)
                    }
                }
            }
            
        }
    }
}
struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    
    struct CornerRadiusShape: Shape {
        
        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners
        
        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }
    
    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}
//struct NewsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewsView()
//    }
//}
