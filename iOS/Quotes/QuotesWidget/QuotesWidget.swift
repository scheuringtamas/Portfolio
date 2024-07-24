import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> SimpleEntry {
        let context = PersistenceController.shared.container.viewContext
        let newQuoteEntity = QuoteEntity(context: context)
        return SimpleEntry(date: Date(), quote: newQuoteEntity)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let context = PersistenceController.shared.container.viewContext
        let newQuoteEntity = QuoteEntity(context: context)
        let snapshotEntry = SimpleEntry(date: Date(), quote: newQuoteEntity)
        completion(snapshotEntry)
    }


    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        do {
            let quoteEntities = try getData()
            let currentDate = Date()
           
            for (index, quoteEntity) in quoteEntities.enumerated() {
                let entryDate = Calendar.current.date(byAdding: .minute, value: index + 5, to: currentDate)!
                let entry = SimpleEntry(date: entryDate, quote: quoteEntity)
                entries.append(entry)
                
            }
        } catch {
            print("Error fetching data: \(error)")
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    
    private func getData() throws -> [QuoteEntity] {
        let context = PersistenceController.shared.container.viewContext
        
        let request = QuoteEntity.fetchRequest()
        let result = try context.fetch(request)
        
        return result
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let quote: QuoteEntity
}

struct QuotesWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.quote.q ?? "")
                .font(.title2)
                .foregroundStyle(.white)
                
            Text(entry.quote.a ?? "")
                .italic()
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

struct QuotesWidget: Widget {
    let kind: String = "QuotesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                QuotesWidgetEntryView(entry: entry)
                    .containerBackground(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing), for: .widget)
                
            } else {
                QuotesWidgetEntryView(entry: entry)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
            }
        }
        .configurationDisplayName("My Widget")
    }
}
