//
//  SettingsScreen.swift
//  Healthio
//
//  Created by Marek Baláž on 28/10/2024.
//

import Foundation
import SwiftUI

struct SettingsScreen: View {
    
    var body: some View {
        content
            .navigationTitle(LocalizedStringKey("title_settings"))
            .navigationBarTitleDisplayMode(.inline)
    }
    
}

// MARK: - UI

extension SettingsScreen {
    var content: some View {
        PlaceholderView(
            icon: Image("barricade-big"),
            title: String(localized: "soon_title"),
            subtitle: String(localized: "soon_subtitle")
        )
    }
}
