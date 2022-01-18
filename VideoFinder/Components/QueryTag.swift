//
//  QueryTag.swift
//  VideoFinder
//
//  Created by Stephanie Diep on 2022-01-18.
//

import SwiftUI

struct QueryTag: View {
    var query: Query
    var isSelected: Bool
    
    var body: some View {
        Text(query.rawValue)
            .font(.caption)
            .bold()
            .foregroundColor(isSelected ? .black : .gray)
            .padding(10)
            .background(.thinMaterial)
            .cornerRadius(10)
    }
}

struct QueryTag_Previews: PreviewProvider {
    static var previews: some View {
        QueryTag(query: Query.food, isSelected: true)
    }
}
