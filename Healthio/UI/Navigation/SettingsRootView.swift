//
//  SettingsRootView.swift
//  Healthio
//
//  Created by Marek Baláž on 28/10/2024.
//

import Foundation
import SwiftUI
import Combine

struct SettingsRootView<T: View>: View {
    
    let content: () -> T
    
    @Environment(\.di) private var di
    
    @State private var router: [RouteSettings] = []
    
    var body: some View {
        NavigationStack(path: routerBinding) {
            content()
                .navigationDestination(for: RouteSettings.self) { route in
                    
                }
        }
        .onReceive(routerUpdate) {
            router = $0
        }
    }
}

private extension SettingsRootView {
    
    var routerUpdate: AnyPublisher<[RouteSettings], Never> {
        di.appState.updates(for: \.routerSettings)
    }
    
    var routerBinding: Binding<[RouteSettings]> {
        $router.dispatched(to: di.appState, \.routerSettings)
    }
}

#Preview {
    SettingsRootView {
        Text("test")
    }
}
