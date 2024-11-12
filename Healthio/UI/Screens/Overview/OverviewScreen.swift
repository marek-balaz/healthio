//
//  OverviewScreen.swift
//  Healthio
//
//  Created by Marek Baláž on 28/10/2024.
//

import Foundation
import SwiftUI
import Combine

struct OverviewScreen: View {
    
    @Environment(\.di) private var di
    
    @State private var cancelBag = CancelBag()
    
    @State private var apiError: (Error?, Bool) = (nil, false)
    
    // Impl
    
    @State private var userProfile: Loadable<UserProfile?> = .notRequested
    var userProfileUpdate: AnyPublisher<Loadable<UserProfile?>, Never> {
        di.appState.updates(for: \.userData.userProfile)
    }
    
    @State private var bloodPressureRecords: Loadable<[BloodPressure]> = .notRequested
    
    var body: some View {
        
        content
            .navigationTitle(LocalizedStringKey("title_overview"))
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $apiError.1) {
                Alert(
                    title: Text("\(apiError.0?.localizedDescription ?? NSLocalizedString("global_not_available", comment: ""))"),
                    dismissButton: .default(Text(LocalizedStringKey("global_ok")))
                )
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        di.appState[\.routerOverview].append(.userProfileDetail)
                    } label: {
                        AvatarView(
                            avatar: userProfile.unwrap().value?.avatarImg(),
                            width: 32, height: 32
                        )
                    }
                }
            }
            .onReceive(userProfileUpdate) {
                userProfile = $0
            }
            .background(Color.gray.opacity(0.1))
    }
    
}

// MARK: - UI

extension OverviewScreen {
    
    @ViewBuilder
    var content: some View {
        switch userProfile {
        case .notRequested, .failed, .isLoading:
            overview(for: UserProfile.mockProfile)
                .redacted(reason: .placeholder)
        case .loaded(let profile):
            if let profile {
                overview(for: profile)
            }
            // else anonymous / not logged in
        }
    }
    
    func greeting(for profile: UserProfile) -> some View {
        VStack(alignment: .leading) {
            Text(getGreeting())
                .font(.system(size: 32))
            Text(profile.name + " 👋🏻")
                .font(.system(size: 32, weight: .medium))
                .foregroundStyle(Color.blue.opacity(0.7))
        }
        .padding()
    }
    
    func overview(for profile: UserProfile) -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                greeting(for: profile)
                
                BloodPressureView(profile: profile)
                    .padding()
                    .background{
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(UIColor.systemBackground))
                    }
                    .padding(.horizontal)
            }
        }
    }
    
}

extension OverviewScreen {
    
    func getGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 5..<12:
            return String(localized: "greetings_morning") + ","
        case 12..<17:
            return String(localized: "greetings_afternoon") + ","
        case 17..<21:
            return String(localized: "greetings_evening") + ","
        default:
            return String(localized: "greetings_night") + ","
        }
    }
    
}
