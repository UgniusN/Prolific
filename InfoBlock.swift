//
//  InfoBlock.swift
//  Prolific
//
//  Created by Ugnius Naujokas on 9/30/23.
//

import Foundation
import SwiftUI

struct InfoBlock: View {
    private var title: String
    private var value: String
    
    init(title: String, value: String) {
        self.title = title
        self.value = value
    }
    
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .b1Bold()
                .foregroundColor(Color("Neutral50"))
            Spacer().frame(height: 12)
            Text(value)
                .bold(size: 48)
                .foregroundColor(Color("Neutral50"))
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(16)
        .background(Color("Purple500"))
        .cornerRadius(24)
    }
}
