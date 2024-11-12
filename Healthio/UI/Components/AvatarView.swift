//
//  AvatarView.swift
//  Healthio
//
//  Created by Marek Baláž on 28/10/2024.
//

import Foundation
import SwiftUI

struct AvatarView: View {
    
    let avatar: Image?
    
    let width: CGFloat
    
    let height: CGFloat
    
    var body: some View {
        if let avatar {
            avatar
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: height)
                .clipShape(.circle)
        } else {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: width, height: height)
                .redacted(reason: .placeholder)
                .clipShape(.circle)
        }
    }
    
}
