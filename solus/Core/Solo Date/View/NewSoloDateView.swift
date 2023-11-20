//
//  NewSoloDateView.swift
//  solus
//
//  Created by Victoria Ono on 8/1/23.
//

import SwiftUI
import PhotosUI

struct NewSoloDateView: View {
    @State private var title = ""
    @State private var date: Date = Date()
    @State var hour = 12
    @State var minute = 0
    @State var am = true
    @State private var time: Time = Time(hour: 12, minute: 0, am: false)
    @State private var location = ""
    @State private var searchResults = [SearchResult]()
    @State private var rating = 0
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var feeling = ""
    @State private var favorite = ""
    @State private var thoughts = ""
    @State private var learning = ""
    @State private var showDatePicker = false
    @State private var showTimePicker = false
    @State private var timeChosen = false
    @State private var dateChosen = false
    @State private var presentAlert = false
    @StateObject var viewModel: SoloDateViewModel
    
    @Environment(\.dismiss) private var dismiss
    @State var isSaving = false
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: SoloDateViewModel(user: user))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                        .frame(height: 40)
                    HStack(alignment: .lastTextBaseline) {
                        Text("New solo date.")
                            .modifier(Title())
                        
                        Spacer()
                        
                        Button {
                            isSaving.toggle()
                            let newEntry = SoloDate(title: title, date: date, time: time, location:location,
                                                    rating: rating, feeling: feeling, favorite: favorite, thoughts: thoughts, learning: learning)
                            Task {
                                try await viewModel.saveSoloDate(newEntry)
                                let solodate = viewModel.entry
                                try await viewModel.saveImages(solodate: solodate, images: selectedImages)
                                dismiss()
                            }
                        } label: {
                            if !isSaving {
                                Text("done")
                            }
                            else {
                                ProgressView()
                            }
                        }
                        .modifier(Default())
                        .fontWeight(.bold)
                        .disabled(!formIsValid)
                        .opacity(formIsValid ? 1.0 : 0.5)
                        .padding(.horizontal, 5)
                        .onTapGesture {
                            hideKeyboard()
                        }
                    }
                    
                    ScrollView {
                        VStack(spacing: 5) {
                            InputView(text: $title, placeholder: "title", alignment: .leading)
                            
                            VStack(spacing: 0) {
                                HStack {
                                    if dateChosen {
                                        Text(date.toString(format: "EEEE, M/d/yyyy"))
                                            .padding(.leading, 10)
                                            .padding(.top, 8)
                                    } else {
                                        Text("date")
                                            .padding(.leading, 10)
                                            .padding(.top, 8)
                                            .foregroundStyle(Color.gray.opacity(0.6))
                                    }
                                    Spacer()
                                    Image("Chevron-Right")
                                            .rotationEffect(.degrees(showDatePicker ? 90 : 0))
                                            .animation(.easeInOut, value: showDatePicker)
                                            .padding(.horizontal)
                                }
                                .modifier(Default())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                

                                if showDatePicker {
                                    CustomDatePicker(currentDate: $date)
                                }
                            }.background(Color("whiteish"), in: RoundedRectangle(cornerRadius: 20))
                                .onTapGesture {
                                    if showDatePicker {
                                        dateChosen = true
                                    }
                                    withAnimation {
                                        showDatePicker.toggle()
                                    }
                                }

                            
                            VStack(spacing: 0) {
                                HStack {
                                    if timeChosen {
                                        Text(time.display)
                                            .padding(.leading, 10)
                                            .padding(.top, 8)
                                    } else {
                                        Text("time")
                                            .padding(.leading, 10)
                                            .padding(.top, 8)
                                            .foregroundStyle(Color.gray.opacity(0.6))
                                    }
                                    Spacer()
                                    Image("Chevron-Right")
                                            .rotationEffect(.degrees(showTimePicker ? 90 : 0))
                                            .animation(.easeInOut, value: showTimePicker)
                                            .padding(.horizontal)
                                }
                                .modifier(Default())
                                .frame(maxWidth: .infinity, alignment: .leading)

                                if showTimePicker {
                                    CustomTimePicker(hour: $hour, minute: $minute, am: $am)
                                        .padding()
                                }
                            }.background(Color("whiteish"), in: RoundedRectangle(cornerRadius: 20))
                                .onTapGesture {
                                    if showTimePicker {
                                        timeChosen = true
                                        time = Time(hour: hour, minute: minute, am: am)
                                    }
                                    withAnimation {
                                        showTimePicker.toggle()
                                    }
                                }
                            
                            PlacePicker(searchResults: $searchResults)
                            
                            if dateChosen && timeChosen && date <= Date() {
                                HStack {
                                    RatingView(rating: $rating)
                                        .frame(width: 120, height: 30)
                                        .padding(.horizontal)
                                        .background(Color("whiteish"), in: RoundedRectangle(cornerRadius: 20))
                                    Spacer()
                                }
                                
                                ScrollView(.horizontal) {
                                    HStack {
                                        if viewModel.selectedImages.count > 0 {
                                            ForEach(viewModel.selectedImages, id: \.self) { img in
                                                Image(uiImage: img)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 165, height: 200)
                                                    .cornerRadius(20)
                                            }
                                        }
                                        PhotosPicker(selection: $viewModel.photoSelections, maxSelectionCount: 3, matching: .any(of: [.images, .not(.videos)])) {
                                            Image("Cafe")
                                        }
                                        .tint(Color("slate"))
                                        .frame(width: 165, height: 200)
                                        .background(Color("whiteish"))
                                        .cornerRadius(20)
                                    }
                                }
                                    
                                
                                
                                VStack(alignment: .leading) {
                                    Text("how did this solo date make me feel?")
                                    LongInputView(text: $feeling)
                                    
                                    Text("favorite parts of this solo date")
                                    LongInputView(text: $favorite)
                                    
                                    Text("what insecurities or uncomfortable thoughts came up?")
                                    LongInputView(text: $thoughts)
                                    
                                    Text("what did I learn?")
                                    LongInputView(text: $learning)
                                }
                                .modifier(Default())
                            }
                        }
                    }
                }
                .padding()
                .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                presentAlert.toggle()
                            } label: {
                                Image("X")
                            }
                        }
                }
                if presentAlert {
                    AlertView(presentAlert: $presentAlert, alertType: .new, leftButtonAction: self.handleDismiss) {
                        withAnimation {
                            presentAlert.toggle()
                        }
                    }
                }
            }
        }
    }
    
    private func handleDismiss() {
        self.dismiss()
    }
}

extension NewSoloDateView: FormProtocol {
    var formIsValid: Bool {
        if date < Date() {
            return title.count != 0 && dateChosen && timeChosen
            && viewModel.photoSelections.count > 0
        }
        else {
            return title.count != 0 && dateChosen && timeChosen
        }
        
    }
}

struct RatingView: View {
    @Binding var rating: Int
    @State var mode: Mode = .edit
    let highestRating = 5
    var body: some View {
        HStack(spacing: 12) {
            ForEach(1...highestRating, id:\.self) { number in
                showRating(for: number)
                    .foregroundColor(number > rating ? .clear : Color("sage"))
                    .frame(width: 13, height: 13)
                    .onTapGesture {
                        if mode == .edit {
                            rating = number
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    func showRating(for number: Int) -> some View {
        if number > rating {
            Circle().strokeBorder(Color("sage"), lineWidth: 2)
        } else {
            Circle().fill(Color("sage"))
        }
    }
}

struct NewSoloDateView_Previews: PreviewProvider {
    static var previews: some View {
        NewSoloDateView(user: User.MOCK_USER)
    }
}
