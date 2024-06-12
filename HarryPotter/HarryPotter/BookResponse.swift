import Foundation

struct BookResponse: Codable {
    let data: [BookData]
}

struct BookData: Codable {
    let id: String
    let type: String
    let attributes: BookAttributes
}

struct BookAttributes: Codable {
    let slug: String
    let author: String
    let cover: String
    let dedication: String
    let pages: Int
    let release_date: String
    let summary: String
    let title: String
    let wiki: String
}
