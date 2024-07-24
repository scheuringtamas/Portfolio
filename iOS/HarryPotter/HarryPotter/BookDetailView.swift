import SwiftUI

struct BookDetailView: View {
    let bookentity: BookEntity
    
    var body: some View {
            VStack(spacing: 20) {
                Text(bookentity.title ?? "")
                    .padding()
                    .font(.title3)
                    .fontWeight(.bold)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack {
                    NavigationLink(destination: BookCoverView(bookentity: bookentity)) {
                        if let coverURL = URL(string: bookentity.cover ?? "") {
                            AsyncImage(url: coverURL) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 190, height: 190)
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                        .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                                        .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                                case .failure:
                                    Text("Failed to load image")
                                case .empty:
                                    ProgressView()
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            Text("Invalid URL")
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Author: \(bookentity.author ?? "")")
                        Text("Pages: \(bookentity.pages)")
                    }
                }
                
                Text("About the book")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding()
                
                Text(bookentity.summary ?? "")
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)

                
                if let wikiURLString = bookentity.wiki, let wikiURL = URL(string: wikiURLString) {
                    Link(destination: wikiURL, label: {
                        Text("Read more about it")
                    })
                    .foregroundStyle(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding()
                } else {
                    Text("Wiki link not available")
                }
                Spacer()
            }
            .padding()
    }
}
