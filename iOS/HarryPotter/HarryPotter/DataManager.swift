import Foundation
import CoreData

class DataManager {
    let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
        getBooks()
    }

    func getBooks() {
        guard let url = URL(string: "https://api.potterdb.com/v1/books") else {
            return
        }

        downloadData(fromURL: url) { returnedData in
            if let data = returnedData {
                guard let decodedResponse = try? JSONDecoder().decode(BookResponse.self, from: data) else {
                    print("Cannot decode the JSON file")
                    return
                }

                DispatchQueue.main.async { [weak self] in
                    self?.saveBooksToCoreData(decodedResponse.data)
                    print("Successfully saved")
                }
            } else {
                print("No data returned!")
            }
        }
    }

    func downloadData(fromURL url: URL, completionHandler: @escaping (_ data: Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  error == nil,
                  let response = response as? HTTPURLResponse,
                  response.statusCode >= 200 && response.statusCode < 300 else {
                print("Error downloading data!")
                completionHandler(nil)
                return
            }
            completionHandler(data)
        }.resume()
    }

    func saveBooksToCoreData(_ books: [BookData]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for bookData in books {
            if !bookExists(id: bookData.id) {
                let newBookEntity = BookEntity(context: viewContext)
                newBookEntity.id = UUID(uuidString: bookData.id)
                newBookEntity.slug = bookData.attributes.slug
                newBookEntity.author = bookData.attributes.author
                newBookEntity.cover = bookData.attributes.cover
                newBookEntity.dedication = bookData.attributes.dedication
                newBookEntity.pages = Int64(bookData.attributes.pages)
                newBookEntity.release_date = dateFormatter.date(from: bookData.attributes.release_date) ?? Date()
                newBookEntity.summary = bookData.attributes.summary
                newBookEntity.title = bookData.attributes.title
                newBookEntity.wiki = bookData.attributes.wiki
            }
        }
        do {
            try viewContext.save()
        } catch {
            print("Error saving data to Core Data: \(error)")
        }
    }
    
    func bookExists(id: String) -> Bool {
        let fetchRequest: NSFetchRequest<BookEntity> = BookEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1
        
        do {
            let count = try viewContext.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking if book exists: \(error)")
            return false
        }
    }
}
