//
//  ImageGridView.swift
//  solus
//
//  Created by Victoria Ono on 8/6/23.
//

import SwiftUI
import Kingfisher

struct ImageGridView: View {

    var soloDates: [SoloDate]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                let count = Int(ceil(Double(soloDates.count)/3.0))
                ForEach(0 ..< count, id: \.self) { i in
                    HStack {
                        ForEach(0..<3) { j in
                            let index = i*3 + j
                            if index < soloDates.count {
                                if let imageURLs = soloDates[index].imageURLs {
                                    KFImage(URL(string: imageURLs[0]))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 111)
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
//                                            .cancelOnDisappear(true) if it's out of the screen?
                                }
//
//                                let imageURL = URL(string: soloDates[index].imageURL) ?? URL(string: "")
//                                AsyncImage(url: imageURL) { image in
//                                    image
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: 100, height: 111)
//                                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                                    .onTapGesture {
//                                        let renderer = ImageRenderer(content: image)
//                                        uiImage = renderer.uiImage ?? UIImage()
//                                    }
//                                } placeholder: {
//                                    RoundedRectangle(cornerRadius: 20)
//                                        .fill(Color("lightsage"))
//                                        .frame(width: 100, height: 111)
//                                }
                            }
                            else {
                                Rectangle()
                                    .frame(width: 100, height: 111)
                                    .opacity(0)
                            }
                        }
                    }
                    .frame(maxWidth: 329)
                }
            }
        }
        
    }
}

struct ImageGridView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGridView(soloDates: [SoloDate.MOCK_DATE])
    }
}
