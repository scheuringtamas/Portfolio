import SwiftUI

struct CardView: View {
    let bookentity: BookEntity
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let rect = $0.frame(in: .named("ScrollView"))
            
            let minY = rect.minY
            
            HStack(spacing: -25) {
                NavigationLink(destination: BookDetailView(bookentity: bookentity)) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(bookentity.title ?? "")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Text("By \(bookentity.author ?? "")")
                                .font(.caption)
                                .foregroundStyle(.gray)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundStyle(.blue)
                            
                        }
                    }
                }
                .foregroundStyle(.black)
                .padding(20)
                .frame(width: size.width / 1.8, height: size.height * 0.8)
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 5, y: 5)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: -5, y: -5)
                }
                .zIndex(1)
                
                ZStack {
                    NavigationLink(destination: BookCoverView(bookentity: bookentity)) {
                        if let coverURL = URL(string: bookentity.cover ?? "") {
                            AsyncImage(url: coverURL) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: size.width / 2, height: size.height)
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(width: size.width)
        }
        .frame(height: 220)
    }
}
