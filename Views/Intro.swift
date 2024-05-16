//
//  SwiftUIView.swift
//  
//
//  Created by Jaagrav Seal on 26/02/24.
//

import SwiftUI

struct Intro: View {
    @ObservedObject var sharedGraphs = SharedGraphs.shared
    @ObservedObject var documents = Documents()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "pencil.and.ruler.fill")
                    .resizable()
                    .frame(maxWidth: 70, maxHeight: 70)
                VStack(alignment: .leading) {
                    Text("Welcome to")
                        .font(.title2)
                    Text("GraphIt")
                        .font(.system(size: 48))
                        .fontWeight(.semibold)
                }
            }
            Text("GraphIt empowers users to master and create intricate Mermaid graphs with ease. Benefit from documentation, templates, and a light weight platform for all your graphing needs.")
                .padding(.vertical, 12)
            
            Text("Learn")
                .font(.title)
                .fontWeight(.medium)
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 20),
                GridItem(.flexible(), spacing: 20)
            ], spacing: 20) {
                ForEach(documents.documents.prefix(4)) { document in
                    NavigationLink {
                        Documentation(document: document)
                    } label: {
                        DocumentListItem(document: document)
                    }.tag(document.id)
                }
            }

            VStack {
                Text("or")
                Button {
                    sharedGraphs.showNewGraphModal = true
                } label: {
                    HStack {
                        Text("Create a new graph")
                        Image(systemName: "plus")
                    }
                }
            }.frame(maxWidth: .infinity)
        }
        .frame(maxWidth: 480)
    }
}
