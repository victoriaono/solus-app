//
//  ComponentViews.swift
//  solus
//
//  Created by Victoria Ono on 8/12/23.
//

import SwiftUI
import Kingfisher

struct HeaderView: View {
    @Environment(\.dismiss) private var dismiss
    var title: String
    
    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Button {
                dismiss()
            } label: {
                Image("Chevron-Left")
                    .padding(5)
            }
            Text(title)
                .modifier(Default(fontSize: 20))
                .offset(y: -5)
        }
    }
}

struct SpotRowView: View {
    var imageName: String
    var name: String
    var addressLine1: String
    var addressLine2: String
    
    var body: some View {
        HStack(spacing: 20) {
            if (imageName.first == "h") { // janky way of checking if it's an image url lol
                CircularImageView(imageName: imageName, type: .logo, size: .s)
            } else { // means the image name passed in was category
                CircularImageView(imageName: imageName, type: .icon, size: .s)
            }
            VStack(alignment: .leading) {
                Text(name)
                VStack(alignment: .leading, spacing: -10) {
                    Text(addressLine1)
                    Text(addressLine2)
                }
            }
            .modifier(Default())
        }
    }
}

struct CircularImageView: View {
    let imageName: String
    let type: PhotoType
    let size: ImageSize
    
    var body: some View {
        switch type {
        case .profile:
            AsyncImage(url: URL(string: imageName)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: size.rawValue, height: size.rawValue)
            .clipShape(Circle())
            .overlay(Circle().stroke(.white, lineWidth: 5))
        case .logo:
            KFImage(URL(string: imageName))
                .resizable()
                .scaledToFit()
                .frame(width: size.rawValue, height: size.rawValue)
                .overlay(Circle().stroke(Color("greyish"), lineWidth: 1))
                .clipShape(Circle())
        case .icon:
            ZStack {
                Circle()
                    .strokeBorder(Color("greyish"), lineWidth: 1)
                    .background(Circle().fill(.white))
                    .frame(width: size.rawValue, height: size.rawValue)
                    
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size.rawValue-20.0, height: size.rawValue-20.0)
                    .clipShape(Circle())
            }
        }
    }
}

struct ButtonView: View {
    let text: String
    let num: Int
    @Binding var frequency: Int
    var mode: Mode
    
    var body: some View {
        Button {
            frequency = num
        } label: {
            Text(text)
        }
        .modifier(Default(fontSize: 12, fontColor: frequency == num ? "whiteish" : "slate"))
        .offset(y: 4)
        .frame(width: 100, height: 35)
        .background(frequency == num ? Color("slate") : Color("whiteish"), in: RoundedRectangle(cornerRadius: 25))
        .if(mode == .view) { view in
            view.disabled(true)
        }
    }
}

struct LongInputView : View {
    @Binding var text: String
    var body: some View {
        TextEditor(text: $text)
            .modifier(Default())
            .padding(.leading, 5)
            .textInputAutocapitalization(.never)
            .scrollContentBackground(.hidden)
            .background(Color("whiteish"))
            .cornerRadius(20)
            .frame(height: 60)
    }
}
