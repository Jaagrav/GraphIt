//
//  Editor.swift
//  GraphIt
//
//  Created by Jaagrav Seal on 11/02/24.
//

import SwiftUI

struct Editor: View {  
    @ObservedObject var sharedGraphs = SharedGraphs.shared
    @ObservedObject var graph: Graph
    
    @State var deleteAlert = false
    
    var body: some View {
        VStack {
            CodeMirror(graph: graph)
        }
        .toolbar(UIDevice.current.userInterfaceIdiom == .phone ? .visible : .hidden)
        .background(Color("background"))
    }
}
