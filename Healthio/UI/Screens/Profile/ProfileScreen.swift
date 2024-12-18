//
//  Profile.swift
//  Healthio
//
//  Created by Marek Baláž on 28/10/2024.
//

import Foundation
import SwiftUI
import Combine

struct ProfileScreen: View {
    
    @Environment(\.di) private var di
    
    @Environment(\.dismiss) var dismiss
    
    @State private var apiError: (Error?, Bool) = (nil, false)
    
    @State private var isLoading: Bool = false
    
    @State private var cancelBag = CancelBag()
    
    // Impl
    
    @AppStorage(UserDefaults.C.userSelectedProfileIdKey)
    private var selectedProfileId: String?
    
    @State private var userProfiles: Loadable<[UserProfile]> = .notRequested
    
    var body: some View {
        
        content
            .navigationTitle(LocalizedStringKey("title_profile"))
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $apiError.1) {
                Alert(
                    title: Text("\(apiError.0?.localizedDescription ?? NSLocalizedString("global_not_available", comment: ""))"),
                    dismissButton: .default(Text(LocalizedStringKey("global_ok")))
                )
            }
            .onAppear {
                search()
            }
    }
    
}

// MARK: - UI

extension ProfileScreen {
    
    @ViewBuilder
    var content: some View {
        switch userProfiles {
        case .notRequested, .isLoading:
            ProgressView()
        case .loaded(let profiles):
            detail(for: profiles)
        case .failed:
            PlaceholderView(
                title: String(localized: "unspecified_error")
            )
        }
    }
    
}

extension ProfileScreen {
    
    func detail(for profiles: [UserProfile]) -> some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(profiles, id: \.id) { profile in
                    Button {
                        di.services.usersService.getSelectedUser(id: profile.id)
                    } label: {
                        HStack(spacing: 16) {
                            AvatarView(
                                avatar: profile.avatarImg(),
                                width: 32, height: 32
                            )
                            
                            Text(profile.name)
                                .font(.system(size: 16))
                            
                            Spacer()
                            
                            if profile.id.uuidString == selectedProfileId {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 16, height: 16)
                                    .foregroundStyle(.green)
                            }
                        }
                        .padding(.horizontal)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .frame(height: 80)
                    
                    Divider()
                }
            }
        }
    }
    
}

// MARK: - API

extension ProfileScreen {
    
    func search(by text: String? = nil) {
        cancelBag.cancel()
        di.services.usersService.fetchUsers(
            search: ""
        )
        .receive(on: DispatchQueue.main)
        .sink { result in
            switch result {
            case .finished:
                break
            case .failure(let error):
                apiError = (error, true)
            }
        } receiveValue: { userProfiles in
            self.userProfiles = .loaded(userProfiles)
        }
        .store(in: cancelBag)
    }
    
    func delete(userProfile: UserProfile) {
        di.services.usersService.deleteUser(userProfile.id)
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .finished:
                    search()
                case .failure(let error):
                    apiError = (error, true)
                }
            } receiveValue: { _ in
                // skip
            }
            .store(in: cancelBag)
    }
    
}
