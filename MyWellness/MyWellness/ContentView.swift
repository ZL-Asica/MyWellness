//
//  ContentView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/4/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0
    
    var body: some View {
        // Whole page should be scrollable
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
