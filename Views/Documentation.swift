//
//  SwiftUIView.swift
//  
//
//  Created by Jaagrav Seal on 26/02/24.
//

import SwiftUI
import MarkdownUI

struct Documentation: View {
    @ObservedObject var document: Document
    
    var body: some View {
        ScrollView {
            Markdown(document.doc)
                .markdownTheme(.gitHub)
                .font(.title)
                .padding(24)
        }
        .background(Color("background"))
        .navigationTitle(document.title)
    }
}
