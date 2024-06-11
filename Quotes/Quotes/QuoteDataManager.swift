import Foundation
import CoreData

class QuoteDataManager {
    let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        getQuotes()
    }
    
    func getQuotes() {
        guard let url = URL(string: "https://zenquotes.io/api/quotes") else {
            return
        }
        
        downloadData(fromURL: url) { returnedData in
            if let data = returnedData {
                guard let decodedQuotes = try? JSONDecoder().decode([Quote].self, from: data) else {
                    return
                }
                
                DispatchQueue.main.async { [weak self] in
                    self?.saveQuotesToCoreData(decodedQuotes)
                }
            } else {
                print("No data returned")
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
    
    func saveQuotesToCoreData(_ quotes: [Quote]) {
        for quote in quotes {
            let newQuoteEntity = QuoteEntity(context: viewContext)
            newQuoteEntity.q = quote.q
            newQuoteEntity.a = quote.a
        }
        do {
            try viewContext.save()
        } catch {
            print("Error saving data to Core Data: \(error)")
        }
    }
}
