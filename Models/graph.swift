//
//  graph.swift
//  GraphIt
//
//  Created by Jaagrav Seal on 23/02/24.
//

import Foundation
import CoreData
import SwiftUI

import Foundation

class Graph: ObservableObject, Identifiable, Codable, Hashable {
    @Published var title: String
    @Published var content: String
    @Published var createdAt: Date
    
    var uid: UUID
    
    var readOnly: Bool
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case title, content, createdAt, uid, readOnly, description
    }
    
    init(title: String, description: String = "", content: String, createdAt: Date, readOnly: Bool = false) {
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.readOnly = readOnly
        self.description = description
        self.uid = UUID()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        content = try container.decode(String.self, forKey: .content)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        uid = try container.decode(UUID.self, forKey: .uid)
        readOnly = try container.decode(Bool.self, forKey: .readOnly)
        description = try container.decode(String.self, forKey: .description)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(content, forKey: .content)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(uid, forKey: .uid)
        try container.encode(readOnly, forKey: .readOnly)
        try container.encode(description, forKey: .description)
    }
    
    static func == (lhs: Graph, rhs: Graph) -> Bool {
        return lhs.uid == rhs.uid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
}


class SharedGraphs: ObservableObject {
    static let shared = SharedGraphs()
    
    @Published var sidebarOpen: NavigationSplitViewVisibility = .automatic
    @Published var showNewGraphModal: Bool = false
    @Published var isGraphOpen: Bool = true
    
    @Published var graphs = [
        Graph(title: "Sample", content: "flowchart TD\nA[Christmas] -->|Get money| B(Go shopping)\nB --> C{Let me think}\nC -->|One| D[Laptop]\nC -->|Two| E[iPhone]\nC -->|Three| F[fa:fa-car Car]", createdAt: Date(), readOnly: false),
    ]
    
    func loadFromStore() -> [Graph]? {
        if let savedGraphs = UserDefaults.standard.object(forKey: "SavedGraphs") as? Data {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let loadedGraphs = try? decoder.decode([Graph].self, from: savedGraphs) {
                graphs = loadedGraphs
                return graphs
            }
        }
        return nil
    }
    
    func saveGraphs() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let encoded = try? encoder.encode(self.graphs) {
            UserDefaults.standard.set(encoded, forKey: "SavedGraphs")
        }
    }
    
    func createGraph(_ name: String) {
        let boilerPlate = "graph TD\n    A --> B\n    A --> C\n\n    B --> D\n    B --> E\n\n    C --> F\n    C --> G"
        
        let newGraph = Graph(title: name, content: boilerPlate, createdAt: Date(), readOnly: false)

        graphs.append(newGraph)
        saveGraphs()
    }
    
    func deleteGraph(_ id: ObjectIdentifier) {
        for (index, graph) in graphs.enumerated() {
            if graph.id == id {
                graphs.remove(at: index)
            }
        }
        saveGraphs()
    }
}
