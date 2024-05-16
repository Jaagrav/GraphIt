//
//  Output.swift
//  GraphIt
//
//  Created by Jaagrav Seal on 22/02/24.
//

import SwiftUI
import WebKit
import Foundation

#if os(iOS)
typealias ViewRepresentable = UIViewRepresentable
#elseif os(macOS)
typealias ViewRepresentable = NSViewRepresentable
#endif

struct PlatformWebView: ViewRepresentable {
    let code: String
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    func makeNSView(context: Context) -> WKWebView {
        let wkWebView = WKWebView()
        wkWebView.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
        
        wkWebView.isOpaque = false
        wkWebView.backgroundColor = .clear
        wkWebView.scrollView.backgroundColor = .clear
        
        #if os(macOS)
        wkWebView.setValue(false, forKey: "drawsBackground")
        #endif
        
        let mermaidLibrary = try? String(contentsOfFile: Bundle.main.path(forResource: "Mermaid", ofType: "js")!, encoding: .utf8)
        let graphItStyle = try? String(contentsOfFile: Bundle.main.path(forResource: "GraphIt", ofType: "css")!, encoding: .utf8)
        let graphItScript = try? String(contentsOfFile: Bundle.main.path(forResource: "GraphIt", ofType: "js")!, encoding: .utf8)
            
        let template = "<html><head><script>\(mermaidLibrary ?? "")</script><style>\(graphItStyle ?? "")</style></head><body><div id=\"mermaid\" class=\"mermaid\">\(code)</div><script>\(graphItScript ?? "")</script></body></html>"
        
        wkWebView.loadHTMLString(template, baseURL: nil)
        
        return wkWebView
    }
    
    func updateNSView(_ wkWebView: WKWebView, context: Context) {
        wkWebView.evaluateJavaScript("updateDiagram(`\(code)`, '\(colorScheme == .dark ? "dark" : "default")');", completionHandler: nil)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        makeNSView(context: context)
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        updateNSView(uiView, context: context)
    }
}

struct Output: View {
    var code: String
    var body: some View {
        GeometryReader { geometry in
            PlatformWebView(code: code)
                .frame(height: min(geometry.size.height, .infinity))
        }
    }
}

#Preview {
    Output(code: "")
}
