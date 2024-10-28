//
//  OverviewRootView.swift
//  Healthio
//
//  Created by Marek Baláž on 28/10/2024.
//

import Foundation
import SwiftUI
import Combine

struct OverviewRootView<T: View>: View {
    
    let content: () -> T
    
    @Environment(\.di) private var di
    
    @State private var router: [RouteOverview] = []
    
    var body: some View {
        NavigationStack(path: routerBinding) {
            content()
                .navigationDestination(for: RouteOverview.self) { route in
                    switch route {
                    case .userProfileDetail:
                        ProfileScreen()
                    }
                }
        }
        .onReceive(routerUpdate) {
            router = $0
        }
    }
}

private extension OverviewRootView {
    
    var routerUpdate: AnyPublisher<[RouteOverview], Never> {
        di.appState.updates(for: \.routerOverview)
    }
    
    var routerBinding: Binding<[RouteOverview]> {
        $router.dispatched(to: di.appState, \.routerOverview)
    }
}

#Preview {
    OverviewRootView {
        Text("test")
    }
}
