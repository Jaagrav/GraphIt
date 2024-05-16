//
//  SideBar.swift
//  GraphIt
//
//  Created by Jaagrav Seal on 11/02/24.
//

import SwiftUI

struct GraphListItem: View {
    @ObservedObject var graph: Graph
    @ObservedObject var sharedGraphs = SharedGraphs.shared
    
    var isSample: Bool = false
    
    func getFormattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        
        return formatter.string(from: date)
    }
    
    var body: some View {
        NavigationLink(destination: Editor(graph: graph), label: {
            HStack(spacing: 14) {
                Image(systemName: "flowchart")
                VStack(alignment: .leading) {
                    Text(graph.title)
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    if isSample {
                        Text(graph.description)
                            .foregroundColor(Color.secondary)
                            .font(.caption)
                            .lineLimit(2)
                            .truncationMode(.tail)
                    }
                    else {
                        Text(getFormattedDate(graph.createdAt))
                            .foregroundColor(Color.secondary)
                            .font(.caption)
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
        })
    }
    
}

struct DocumentListItem: View {
    @ObservedObject var document: Document
    
    var body: some View {
        NavigationLink(destination: Documentation(document: document), label: {
            HStack(spacing: 14) {
                Image(systemName: "doc.richtext")
                VStack(alignment: .leading) {
                    Text(document.title)
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text(document.description)
                        .foregroundColor(Color.secondary)
                        .font(.caption)
                        .lineLimit(2)
                        .truncationMode(.tail)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
        })
    }
}

struct SideBar: View {
    @ObservedObject var sharedGraphs = SharedGraphs.shared
    var documents = Documents()
    
    var body: some View {
                VStack(alignment: .leading) {
        if UIDevice.current.userInterfaceIdiom != .phone {
            HStack {
                Spacer()
                VStack {
                    Text("GraphIt")
                        .font(.system(size: 28))
                        .fontWeight(.medium)
                    Text("by Jaagrav • v1.0.0")
                        .font(.caption)
                }
                Spacer()
            }
            .padding(.bottom, 12)
        }
        ZStack {
            Circle()
                .fill(Color.blue)
                .opacity(0.8)
                .frame(width: 125, height: 125)
                .position(x: 100, y: -150)
                .blur(radius: 50)
            
            Circle()
                .fill(Color.green)
                .opacity(0.8)
                .frame(width: 125, height: 125)
                .position(x: 0, y: -50)
                .blur(radius: 50)
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                Spacer()
                    .navigationBarTitle("GraphIt")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button {
                                sharedGraphs.showNewGraphModal = true
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
            }
            
            List {
                Section(header: Text("My Graphs")) {
                    ForEach(sharedGraphs.graphs) { graph in
                        GraphListItem(graph: graph)
                            .tag(graph.id)
                    }
                }
                Section(header: Text("Samples")) {
                    ForEach(documents.sampleGraphs) { graph in
                        GraphListItem(graph: graph, isSample: true)
                            .tag(graph.id)
                    }
                }
                Section(header: Text("Learn")) {
                    ForEach(documents.documents) { document in
                        DocumentListItem(document: document)
                            .tag(document.id)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            
        }
                    
        Divider()
            .padding(0)
        
        Button {
            sharedGraphs.showNewGraphModal = true
        } label: {
            HStack {
                Image(systemName: "plus.circle")
                Text("New graph")
            }
            .padding(.top, 10)
            .padding(.bottom, 18)
            .frame(maxWidth: .infinity)
        }
        .padding(0)
        .buttonStyle(.plain)
        .foregroundColor(.accentColor)
    }
            .background(Color("background"))
        }
}

#Preview {
    SideBar()
}
