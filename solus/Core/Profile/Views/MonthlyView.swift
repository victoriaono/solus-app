//
//  MonthlyView.swift
//  solus
//
//  Created by Victoria Ono on 8/24/23.
//

import SwiftUI
import FirebaseFirestoreSwift
import Kingfisher

struct MonthlyView: View {
    @StateObject var viewModel: MonthlyViewModel
    @State var today = Date()
    @State var selectedDate = Date()
    @State private var viewNewDate = false
    private let days = ["S", "M", "T", "W", "T", "F", "S"]
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    @Environment(\.dismiss) private var dismiss
    @GestureState private var offSet = CGSize.zero
    @State var path = NavigationPath()
    @State var swipedMonth = 0
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: MonthlyViewModel(user: user))
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                HStack {
                    Button {
                        withAnimation {
                            viewModel.currentMonth -= 1
                        }
                    } label: {
                        Image("Chevron-Left")
                            .padding(.top, 20)
                            .padding(.trailing, 5)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("\(viewModel.extractMonthYear())")
                            .modifier(Default(fontSize: 18))
                            .padding(.leading)
                            .padding(.bottom, 1)
                        
                        HStack(spacing: 0) {
                            ForEach(days, id:\.self) { day in
                                Text(day)
                                    .modifier(Default())
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(viewModel.extractDates()) { value in
                                Button {
                                    // TODO: scroll down to the selected date
                                    selectedDate = value.date
                                } label: {
                                    DayView(value: value)
                                }
                            }
                        }
                    }
                    
                    Button {
                        withAnimation {
                            viewModel.currentMonth += 1
                        }
                    } label: {
                        Image("Chevron-Right")
                            .padding(.top, 20)
                            .padding(.leading, 5)
                    }
                }
                
                GeometryReader { geo in
                    ScrollView {
                        ForEach(viewModel.entries) { solodate in
                            NavigationLink(value: solodate) {
                                DateView(solodate, geo: geo)
                            }
                        }
                    }
                    .navigationDestination(for: SoloDate.self) { solodate in
                        SoloDateView(user: viewModel.user, solodate: solodate, mode: .view)
                    }
                }
                                
                Button {
                    viewNewDate.toggle()
                } label: {
                    Image("Plus")
                }
                .fullScreenCover(isPresented: $viewNewDate) {
                    NewSoloDateView(user: viewModel.user)
                }
            }
            .padding()
            .onChange(of: viewModel.currentMonth) { newValue in
                viewModel.fetchMonthlyEntries()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("X")
                    }
                }
            }
        }
        .task {
            viewModel.fetchMonthlyEntries()
        }
        // this publishes changes from within view updates which is not allowed :(
//        .gesture(DragGesture().updating($offSet, body: { (value, state, transaction) in
//            if (value.translation.width > 100 && value.translation.width < 150) {
//                viewModel.currentMonth -= 1
//            } else if (value.translation.width < -100 && value.translation.width > -150) {
//                viewModel.currentMonth += 1
//            }
//        }))
    }
    
    @ViewBuilder
    func DayView(value: DateValue) -> some View {
        VStack(spacing: 0) {
            if value.day != -1 {
                ZStack {
                    if let solodate = viewModel.entries.first(where: {$0.date.isInSameDay(as: value.date)}), value.date.isInSameDay(as: solodate.date) {
                        if solodate.date < today {
                            Circle()
                                .fill(Color("slate"))
                            Text("\(value.day)")
                                .modifier(Default(fontColor: "whiteish"))
                                .offset(y: 4)
                        } else {
                            Circle()
                                .strokeBorder(Color("slate"))
                            Text("\(value.day)")
                                .modifier(Default())
                                .offset(y: 4)
                        }
                    }
                    else {
                        Text("\(value.day)")
                            .modifier(Default())
                            .offset(y: 4)
                    }
                }.frame(width: 25, height: 25)
                    
                if value.date.isInSameDay(as: today) {
                    Circle()
                        .fill(Color("slate"))
                        .frame(width: 6, height: 6)
                }
            }
        }.frame(height: 30, alignment: .top)
    }
    
    @ViewBuilder
    func DateView(_ solodate: SoloDate, geo: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(solodate.date.toString(format: "EEEE, MMMM d, yyyy"))
            ZStack(alignment: .leading) {
                Text(solodate.title)
                    .offset(y: -12)
                Text(solodate.time.display)
                    .offset(y: 16)
                
                if let rating = solodate.rating, rating > 0 {
                    RatingView(rating: .constant(rating), mode: .view)
                        .offset(x: 70, y: 12)
                }
                if solodate.privateEntry {
                    Image("Locked")
                        .offset(x: geo.size.width * 0.7)
                }
                if let photos = solodate.imageURLs, photos.count > 0 {
                    KFImage(URL(string: photos[0]))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 45, height: 45)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .offset(x: geo.size.width * 0.8)
                }
            }
            .padding()
            .frame(width: geo.size.width, alignment: .leading)
            .frame(height: 70)
            .if(solodate.date > today) { view in
                view.background(RoundedRectangle(cornerRadius: 20).stroke(Color("slate"), lineWidth: 1))
            }
            .if(solodate.date <= today) { view in
                view.background(Color("whiteish"),
                                in: RoundedRectangle(cornerRadius: 20))
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .modifier(Default())
    }
}

struct MonthlyView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlyView(user: User.MOCK_USER)
    }
}
