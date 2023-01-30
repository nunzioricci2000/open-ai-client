//
//  Clippable.swift
//  OpenAI Client
//
//  Created by Nunzio Ricci on 29/01/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct Clippable: View {
    @State var text: String
    @State var clipped: Bool = false
    
    var body: some View {
        Button {
            UIPasteboard.general
                .setValue(text, forPasteboardType: UTType.plainText.identifier)
            clipped = true
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } label: {
            HStack(alignment: .top) {
                Text(text).transition(.scale)
                Spacer()
                Image(systemName: clipped ? "checkmark" : "square.on.square")
                    .foregroundColor(clipped ? .green : .secondary)
            }.foregroundColor(.primary)
        }
    }
}

struct Clippable_Previews: PreviewProvider {
    static var previews: some View {
        Clippable(text: "Clip this text")
    }
}
