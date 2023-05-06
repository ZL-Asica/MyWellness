//
//  ContentView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/4/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    
    // This is the main view of the app
    var body: some View {
        // Any page should be scrollable if the content is longer than the screen
        // The tab view should be at the bottom of the screen
        TabView(selection: $selection) {
            // Home page
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            // Calendar page
            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(1)
            // Settings page
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
