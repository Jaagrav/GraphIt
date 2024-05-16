//
//  documents.swift
//  GraphIt
//
//  Created by Jaagrav Seal on 24/02/24.
//

import Foundation

class Document: ObservableObject, Identifiable {
    var title: String
    var description: String
    var doc: String
    init(title: String, description: String, doc: String) {
        self.title = title
        self.description = description
        self.doc = doc
    }
}

class Documents: ObservableObject {
    @Published var sampleGraphs = [
        Graph(title: "Flowchart", description: "Flowcharts are composed of nodes (geometric shapes) and edges (arrows or lines). The Mermaid code defines how nodes and edges are made and accommodates different arrow types, multi-directional arrows, and any linking to and from subgraphs.", content: "flowchart TD\nA[Christmas] -->|Get money| B(Go shopping)\nB --> C{Let me think}\nC -->|One| D[Laptop]\nC -->|Two| E[iPhone]\nC -->|Three| F[fa:fa-car Car]", createdAt: Date(), readOnly: true),
        Graph(title: "Mindmap", description: "A mind map is a diagram used to visually organize information into a hierarchy, showing relationships among pieces of the whole. It is often created around a single concept, drawn as an image in the center of a blank page, to which associated representations of ideas such as images, words and parts of words are added. Major ideas are connected directly to the central concept, and other ideas branch out from those major ideas.", content: "mindmap\n  root((mindmap))\n    Origins\n      Long history\n      ::icon(fa fa-book)\n      Popularisation\n        British popular psychology author Tony Buzan\n    Research\n      On effectivness<br/>and features\n      On Automatic creation\n        Uses\n            Creative techniques\n            Strategic planning\n            Argument mapping\n    Tools\n      Pen and paper\n      Mermaid", createdAt: Date(), readOnly: true),
        Graph(title: "Entity Relationship Diagram", description: "An entity–relationship model (or ER model) describes interrelated things of interest in a specific domain of knowledge. A basic ER model is composed of entity types (which classify the things of interest) and specifies relationships that can exist between entities (instances of those entity types).", content: "erDiagram\nCUSTOMER }|..|{ DELIVERY-ADDRESS : has\nCUSTOMER ||--o{ ORDER : places\nCUSTOMER ||--o{ INVOICE : \"liable for\"\nDELIVERY-ADDRESS ||--o{ ORDER : receives\nINVOICE ||--|{ ORDER : covers\nORDER ||--|{ ORDER-ITEM : includes\nPRODUCT-CATEGORY ||--|{ PRODUCT : contains\nPRODUCT ||--o{ ORDER-ITEM : \"ordered in\"", createdAt: Date(), readOnly: true)
    ]
    
    @Published var documents = [
        Document(title: "Flowcharts", description: "Flowcharts offer a unique and efficient way to document workflows, processes, and decision trees using simple text-based syntax. This guide is dedicated to helping you understand and create Mermaid flowcharts from the ground up.", doc: try! String(contentsOfFile: Bundle.main.path(forResource: "Flowchart", ofType: "md")!, encoding: .utf8)),
        Document(title: "Sequence Diagrams", description: "Sequence diagrams are a powerful tool for visualizing interactions between actors in a system. They help in understanding the flow of messages, events, or actions from one actor to another, making them essential for documenting complex systems, especially in software development and system design. This guide will walk you through the basics of creating sequence diagrams with Mermaid, along with advanced features to enhance your diagrams.", doc: try! String(contentsOfFile: Bundle.main.path(forResource: "Sequence", ofType: "md")!, encoding: .utf8)),
        Document(title: "Class Diagrams", description: "Class diagrams are a cornerstone of object-oriented modeling, offering a static view of the system structure by showing classes, their attributes, operations (methods), and the relationships among classes.", doc: try! String(contentsOfFile: Bundle.main.path(forResource: "Class", ofType: "md")!, encoding: .utf8)),
        Document(title: "State Diagrams", description: "State diagrams, also known as state machine diagrams, are a staple in modeling the behavior of systems.", doc: try! String(contentsOfFile: Bundle.main.path(forResource: "State", ofType: "md")!, encoding: .utf8)),
        Document(title: "Entity Relationship Diagrams", description: "Entity Relationship Diagrams (ERDs) are essential for modeling the data structure of database systems, providing a clear visual representation of entities, their attributes, and the relationships between them.", doc: try! String(contentsOfFile: Bundle.main.path(forResource: "EntityRelationship", ofType: "md")!, encoding: .utf8)),
        Document(title: "Gantt Charts", description: "Gantt charts are a popular tool for project management, providing a visual timeline for projects, highlighting tasks, their durations, dependencies, and milestones.", doc: try! String(contentsOfFile: Bundle.main.path(forResource: "Gantt", ofType: "md")!, encoding: .utf8)),
        Document(title: "Mindmap", description: "Mindmaps are a visual representation of ideas and concepts, organized around a central theme or problem. ", doc: try! String(contentsOfFile: Bundle.main.path(forResource: "Mindmap", ofType: "md")!, encoding: .utf8)),
    ]
}
