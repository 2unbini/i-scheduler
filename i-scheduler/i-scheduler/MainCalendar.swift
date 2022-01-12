//
//  MainCalendar.swift
//  i-scheduler
//
//  Created by sun on 2022/01/07.
//

import SwiftUI

struct MainCalendar: View {
    @Environment(\.calendar) var calendar
    //    let contents: (Date) -> DateView
    let interval: DateInterval = DateInterval(start: Date(), end: Date().addingTimeInterval(60 * 60 * 24 * 365))
    let sevendaysInterval: DateInterval = DateInterval(
        start: Date(timeIntervalSince1970: 60 * 60 * 24 * 3),
        end: Date(timeIntervalSince1970: 60 * 60 * 24 * 9)
    )
    //    init(interval: DateInterval, @ViewBuilder contents: @escaping (Date) -> DateView) {
    //        self.interval = interval
    //        self.contents = contents
    //    }
    //    @State var year: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { value in
                //                year
                daysOfTheWeek
                Divider()
                ScrollView(.vertical) {
                    CalendarBody(interval: interval) { month, date in
                        DateView(month: month, date: date)
                            .onAppear {
                                //
                            }
                    }
//                    LazyVStack{
//                        ForEach(years, id: \.self) { year in
//                            YearView(of: year, content: contents)
//                        }
//                    }
                }
                .onAppear(perform: {
                    value.scrollTo(calendar.dateInterval(of: .month, for: Date()), anchor: .top)
                })
                .background(Color.white)
            }
        }
        .background(Color.init(white: 0.95).ignoresSafeArea(.all, edges: .top))
    }
    func header(month: Date) -> some View {
        let formatter = DateFormatter.yearAndMonth
        return Text(formatter.string(from: month))
            .font(.title)
            .padding()
    }
    //    private var year: some View {
    //        // TODO: @State로 만들기
    //        Text("2021")
    //    }
    private var daysOfTheWeek: some View {
        HStack(spacing: 0) {
            let daysOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
            ForEach(daysOfTheWeek, id: \.self) { dayOfTheWeek in
                Text(dayOfTheWeek)
                    .font(.caption)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 5)
    }
    var years: [Date] {
        return calendar.generateDates(interval: interval, dateComponents: DateComponents(month: 1, day: 1, hour: 0, minute: 0, second: 0))
    }
    func createDaysThroughMonth(month: Date) -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month),
              let firstWeekInterval = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let lastWeekInterval = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end)
        else { return [] }
        return calendar.generateDates(interval: DateInterval(start: firstWeekInterval.start, end: lastWeekInterval.end), dateComponents: DateComponents(hour:0))
    }
    
    var createAnArrayToDisplayWeekDay: [Date] {
        calendar.generateDates(interval: sevendaysInterval, dateComponents: DateComponents(hour: 0))
    }
    
    func showWeekDay(date: Date) -> some View {
        let formatter = DateFormatter.weekday
        return Text(formatter.string(from: date))
    }
    
    var createMonths: [Date] {
        calendar.generateDates(interval: interval, dateComponents: DateComponents(day: 1))
    }
}

//struct RootView: View {
//    @Environment(\.calendar) var calendar
//    var customDateInterval: DateInterval = DateInterval(start: Date(timeIntervalSinceNow: 60 * 60 * 24 * 365 * -1), end: Date(timeIntervalSinceNow: 60 * 60 * 24 * 365))
//    var body: some View {
//        MainCalendar(interval: customDateInterval) { date in
//            Text(String(calendar.component(.day, from: date)))
//                .frame(width: 40, height: 40, alignment: .center)
//                .padding()
//        }
//    }
//}

//struct YearView<DateView>: View where DateView: View {
//    @Environment(\.calendar) var calendar
//    let year: Date
//    let content: (Date) -> DateView
//    init(of year: Date, @ViewBuilder content: @escaping (Date) -> DateView){
//        self.year = year
//        self.content = content
//    }
//    var body: some View {
//        LazyVStack{
//            ForEach(months, id: \.self) { month in
//                MonthView(of: month, content: content)
//            }
//        }
//    }
//    var months: [Date] {
//        guard let yearInterval = calendar.dateInterval(of: .year, for: year)
//        else { return [] }
//        return calendar.generateDates(interval: yearInterval, dateComponents: DateComponents(day: 1))
//    }
//}

//struct MonthLabel: View {
//    @Environment(\.calendar) var calendar
//    let month: Date
//    let week: Date
//    private var startDayOfMonth: Date {
//        return calendar.startOfDay(for: month)
//    }
//    init(of month: Date, upon week: Date) {
//        self.month = month
//        self.week = week
//    }
//
//}
//struct MonthView<DateView>: View where DateView: View {
//    @Environment(\.calendar) var calendar
//    let month: Date
//    let content: (Date) -> DateView
//    init(of month: Date, @ViewBuilder content: @escaping (Date) -> DateView){
//        self.month = month
//        self.content = content
//    }
//    var body: some View {
//        LazyVStack{
//            ForEach(0..<weeks.count, id: \.self) { nth in
//                if nth == 0 {
//                    MonthLabel(of: month, upon: weeks[nth])
//                }
//                WeekView(of: weeks[nth], content: content)
//            }
//        }
//    }
//    var weeks: [Date] {
//        guard let monthInterval = calendar.dateInterval(of: .month, for: month)
//        else { return[] }
//        return calendar.generateDates(interval: monthInterval, dateComponents: DateComponents(hour: 0, minute: 0, second: 0, weekday: calendar.firstWeekday))
//    }
//}
struct WeekView<DateView>: View where DateView: View {
    @Environment(\.calendar) var calendar
    let week: Date
    let content: (Date) -> DateView
    init(of week: Date, @ViewBuilder content: @escaping (Date) -> DateView){
        self.week = week
        self.content = content
    }
    var days: [Date] {
        guard let weekInterval = calendar.dateInterval(of: .weekOfMonth, for: week)
        else { return[] }
        return calendar.generateDates(interval: weekInterval, dateComponents: DateComponents(hour: 0, minute: 0, second: 0))
    }
    var body: some View {
        LazyHStack(spacing: 0) {
            ForEach(days, id: \.self) { day in
                if calendar.isDate(day, equalTo: week, toGranularity: .month) {
                    content(day)
                } else {
                    content(day).hidden()
                }
            }
        }
    }
}
struct DayView: View {
    let label: String
    init(presenting label: String){
        self.label = label
    }
    var body: some View {
        Text("1")
            .hidden()
            .padding(10)
            .padding(.bottom, 20)
            .overlay (
                VStack {
                    Divider()
                    Text(label)
                }
            )
    }
}
//struct MainCalendar_Previews: PreviewProvider {
//    static var previews: some View {
//        MainCalendar()
//    }
//}
