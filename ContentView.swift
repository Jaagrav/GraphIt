//
//  ContentView.swift
//  GraphIt
//
//  Created by Jaagrav Seal on 10/02/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var graphName: String = ""
    @ObservedObject var sharedGraphs = SharedGraphs.shared
    
    var body: some View {
        VStack {
            if UIDevice.current.userInterfaceIdiom == .phone {
                NavigationStack {
                    SideBar()
                        .onAppear {
                            _ = sharedGraphs.loadFromStore()
                        }
                }
            } else {
                NavigationSplitView(columnVisibility: $sharedGraphs.sidebarOpen) {
                    SideBar()
                        .onAppear {
                            _ = sharedGraphs.loadFromStore()
                        }
                } detail: {
                    Intro()
                }
            }
        }
        .alert("New Graph", isPresented: $sharedGraphs.showNewGraphModal) {
            TextField("Graph Name", text: $graphName)
            HStack {
                Button("Create") {
                    sharedGraphs.createGraph(graphName)
                }
                Button("Cancel") {
                    sharedGraphs.showNewGraphModal = false
                }
            }
            .onChange(of: sharedGraphs.showNewGraphModal) { _ in
                graphName = ""
            }
        } message: {
            Text("Please enter the name for your new note.")
        }
    }
}

#Preview {
    ContentView()
}
