//
//  ContentView.swift
//  MyWellness
//
//  Created by ZL Asica on 5/4/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var profileViewModel = UserProfileSettingsViewModel()
    @StateObject var userSession: UserSession
    
    @State private var showLoginView = false
    @State private var showSignUpView = false
    
    @State private var selection = 0
    @State private var userEmail: String = ""
    
    init() {
        let viewModel = UserProfileSettingsViewModel()
        self._profileViewModel = StateObject(wrappedValue: viewModel)
        self._userSession = StateObject(wrappedValue: UserSession(profileViewModel: viewModel))
    }
    
    // This is the main view of the app
    var body: some View {
        VStack {
            if userSession.isLoading {
                VStack {
                    Image("AppIcon-Pic") // logo here
                        .resizable()
                        .cornerRadius(30)
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding(.top, 50)
                    ProgressView()
                }
            }else {
                if userSession.userEmail == "" {
                    NavigationView {
                        VStack {
                            Image("AppIcon-Pic") // logo here
                                .resizable()
                                .cornerRadius(30)
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding(.top, 50)
                            Button(action: {
                                showLoginView.toggle()
                            }) {
                                Text("Sign In")
                                    .multilineTextAlignment(.center)
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 200, height: 40)
                            }
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding()
                            .sheet(isPresented: $showLoginView) {
                                LoginView(userSession: userSession)
                            }
                            
                            Button(action: {
                                showSignUpView.toggle()
                            }) {
                                Text("Sign Up")
                                    .multilineTextAlignment(.center)
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 200, height: 40)
                            }
                            .background(Color.green)
                            .cornerRadius(10)
                            .padding()
                            .sheet(isPresented: $showSignUpView) {
                                SignUpView(userSession: userSession)
                            }
                        }
                    }
                }else {
                    // Any page should be scrollable if the content is longer than the screen
                    // The tab view should be at the bottom of the screen
                    TabView(selection: $selection) {
                        // Home page
                        HomeView(userSession: userSession)
                            .tabItem {
                                Label("Home", systemImage: "house")
                            }
                            .tag(0)
                        // Calendar page
                        CalendarView(userSession: userSession)
                            .tabItem {
                                Label("Calendar", systemImage: "calendar")
                            }
                            .tag(1)
                        // Settings page
                        SettingsView(userSession: userSession)
                            .tabItem {
                                Label("Settings", systemImage: "gear")
                            }
                            .tag(2)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
