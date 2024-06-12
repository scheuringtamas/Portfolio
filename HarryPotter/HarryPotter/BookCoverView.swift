import SwiftUI

struct BookCoverView: View {
    let bookentity: BookEntity
    
    var body: some View {
        VStack {
            HStack {
                if let coverURL = URL(string: bookentity.cover ?? "") {
                    AsyncImage(url: coverURL) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
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
                   .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Text("Invalid URL")
                }
            }
        }
    }
}


