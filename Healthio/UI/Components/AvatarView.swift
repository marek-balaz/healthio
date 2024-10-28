//
//  AvatarView.swift
//  Healthio
//
//  Created by Marek Baláž on 28/10/2024.
//

import Foundation
import SwiftUI

struct AvatarView: View {
    
    let userProfile: UserProfile??
    
    let width: CGFloat
    
    let height: CGFloat
    
    var body: some View {
        if let profile = userProfile,
           let data = profile?.avatar,
           let img = UIImage(data: data)
        {
            Image(uiImage: img)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: height)
                .clipShape(.circle)
        } else {
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: width, height: height)
                .redacted(reason: .placeholder)
        }
    }
    
}
