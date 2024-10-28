//
//  PlaceholderView.swift
//  Healthio
//
//  Created by Marek Baláž on 28/10/2024.
//

import SwiftUI

struct PlaceholderView<T: View>: View {
    
    typealias Action = () -> T
    
    private let icon: Image?
    
    private let title: String
    
    private let subtitle: String?
    
    private let action: Action
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 8) {
                
                if let icon = icon {
                    icon
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color.gray)
                        .frame(width: 100, height: 100)
                }
                
                Text(title)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 18, weight: .bold))
                
                if let subtitle {
                    Text(subtitle)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 13))
                    
                }
            }
            .padding(.horizontal, 32)
            action()
        }
        .padding(.horizontal, 32)
        .padding(.vertical)
    }
    
    init(icon: Image? = nil, title: String, subtitle: String? = nil, action: @escaping Action) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }
    
    init(icon: Image? = nil, title: String, subtitle: String? = nil) where T == EmptyView {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.action = {
            EmptyView()
        }
    }
    
}
