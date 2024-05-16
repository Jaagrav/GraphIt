//
//  CodeMirror.swift
//  GraphIt
//
//  Created by Jaagrav Seal on 11/02/24.
//

import SwiftUI
import CodeViewer
import Combine
import SplitView

struct CodeMirror: View {
    @ObservedObject var sharedGraphs = SharedGraphs.shared
    @ObservedObject var graph: Graph
    
    @State var isLoading = true
    @State var loaderOpacity = 0.0
    @State var showEditor = true
    @State var showDeleteAlert = false
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom != .phone {
            HStack {
                Button {
                    withAnimation {
                        sharedGraphs.sidebarOpen = .automatic
                    }
                } label: {
                    Image(systemName: "sidebar.left")
                        .font(.title2)
                }
                .offset(x: sharedGraphs.sidebarOpen == .detailOnly ? 0 : -100, y: 0)
                .animation(.bouncy, value: sharedGraphs.sidebarOpen)
                if graph.readOnly {
                    Text(graph.title)
                        .font(.title2)
                        .fontWeight(.medium)
                        .offset(x: sharedGraphs.sidebarOpen == .detailOnly ? 0 : -30, y: 0)
                        .animation(.bouncy, value: sharedGraphs.sidebarOpen)
                }
                else {
                    TextField("Graph title", text: $graph.title)
                        .font(.title2)
                        .fontWeight(.medium)
                        .offset(x: sharedGraphs.sidebarOpen == .detailOnly ? 0 : -30, y: 0)
                        .animation(.bouncy, value: sharedGraphs.sidebarOpen)
                        .onChange(of: graph.title) { _ in
                            sharedGraphs.saveGraphs()
                        }
                }
                Spacer()
                
                if !graph.readOnly {
                    Button {
                        showDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .font(.title2)
                    }
                    .alert("Are you sure?", isPresented: $showDeleteAlert) {
                        Button("Yes", role: .destructive) {
                            sharedGraphs.deleteGraph(graph.id)
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        Button("No", role: .cancel) {
                            showDeleteAlert = false
                        }
                    }
                }
                
            }
            .padding(.horizontal, 12)
            .padding(.top, 8)
            .padding(.bottom, 4)
            Divider()
        }
        ZStack {
            if UIDevice.current.userInterfaceIdiom != .phone {
                HSplit(left: {
                    VStack {
                        if showEditor {
                            CodeViewer(
                                content: $graph.content,
                                mode: .swift,
                                darkTheme: .tomorrow_night,
                                lightTheme: .xcode,
                                isReadOnly: graph.readOnly,
                                fontSize: 16
                            )
                            .onChange(of: graph.content) { _ in
                                sharedGraphs.saveGraphs()
                            }
                        }
                    }
                }, right: {
                    Output(code: graph.content)
                        .background(
                            colorScheme == .dark ? .clear : Color("background")
                        )
                })
                .constraints(minPFraction: 0.25, minSFraction: 0.2)
                .splitter {
                    Splitter(styling: SplitStyling(color: Color("secondaryBackground"), visibleThickness: 2))
                }
            }
            else {
                NavigationStack {
                    VStack {
                        if showEditor {
                            CodeViewer(
                                content: $graph.content,
                                mode: .swift,
                                darkTheme: .tomorrow_night,
                                lightTheme: .xcode,
                                isReadOnly: graph.readOnly,
                                fontSize: 48
                            )
                            .navigationBarTitle(graph.title, displayMode: .inline)
                            .edgesIgnoringSafeArea(.all)
                            .onChange(of: graph.content) { _ in
                                sharedGraphs.saveGraphs()
                            }
                            .background(Color("background"))
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink {
                                Output(code: graph.content)
                                    .edgesIgnoringSafeArea(.all)
                                    .navigationBarTitle("Output", displayMode: .inline)
                            } label: {
                                Image(systemName: "play")
                            }
                        }
                        if !graph.readOnly {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    showDeleteAlert = true
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.accentColor)
                                }
                                .alert("Are you sure?", isPresented: $showDeleteAlert) {
                                        Button("Yes", role: .destructive) {
                                            sharedGraphs.deleteGraph(graph.id)
                                            self.presentationMode.wrappedValue.dismiss()
                                        }
                                        Button("No", role: .cancel) {
                                            showDeleteAlert = false
                                        }
                                    }
                            }
                        }
                    }
                }
            }
            if isLoading {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("background"))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isLoading = false
            }
        }
        .onChange(of: graph.id) { _ in
            isLoading = true
            showEditor = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                showEditor = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isLoading = false
            }
        }
        
    }
}
