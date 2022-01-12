//
//  CalendarBody.swift
//  i-scheduler
//
//  Created by 권은빈 on 2022/01/07.
//

import SwiftUI

struct ScrollableCalendarVGrid<DateView: View>: View {
    @Environment(\.calendar) private var calendar
    @ObservedObject var calendarConfig: CalendarConfig
//    let interval: DateInterval
    let content: (Date, Date, CGFloat) -> DateView
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollView in
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 7), spacing: 0) {
                        ForEach(months) { month in
                            monthSection(month: month, width: geometry.size.width / 7)
                        }
                    }
                }
                .background(Color.white)
                .onAppear {
                    scrollView.scrollTo(calendarConfig.initialDateId, anchor: .top)
                }
            }
        }
    }
    private func monthSection(month: Date, width: CGFloat) -> some View {
        Section {
            monthLabel(month: month)
                .onAppear {
                    if month.month == 12 && calendarConfig.yearLabel != String(month.year) {
                        calendarConfig.yearLabel = String(month.year)
                    }
                }
            ForEach(days(of: month)) { date in
                if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                    content(month, date, width)
                } else {
                    content(month, date, width).hidden()
                }
            }
        }
        .id(month)
    }
    
    @ViewBuilder
    private func monthLabel(month: Date) -> some View {
        if let monthFirstWeekInterval = calendar.dateInterval(of: .weekOfMonth, for: month) {
            let daysOfMonthFirstWeek = calendar.generateDates(interval: monthFirstWeekInterval, dateComponents: DateComponents(hour: 0, minute: 0, second: 0))
            ForEach(daysOfMonthFirstWeek) { date in
                if date.day == 1 {
                    Text(String(month.month) + "월")
                        .bold()
                        .font(.title3)
                        .foregroundColor(calendar.isDate(date, equalTo: Date(), toGranularity: .month) ? .pink : .primary)
                        .padding(.top, 10)
                        .padding(.bottom, 5)
                }
                else {
                    Text(String(month.month))
                        .font(.title3)
                        .bold()
                        .hidden()
                }
            }
        }
    }
    
    private var months: [Date] {
        calendar.generateDates(interval: DateInterval(start: calendarConfig.interval.start, end: calendarConfig.interval.end.addingTimeInterval(1)), dateComponents: DateComponents(day: 1))
    }
    private func days(of month: Date) -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month),
              let firstWeekInterval = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let lastDayOfMonth = calendar.date(byAdding: .day, value: -1, to: monthInterval.end),
                let lastWeekInterval = calendar.dateInterval(of: .weekOfMonth, for: lastDayOfMonth)
        else { return [] }
        return calendar.generateDates(interval: DateInterval(start: firstWeekInterval.start, end: lastWeekInterval.end), dateComponents: DateComponents(hour:0, minute: 0, second: 0))
    }
}

struct CalendarBody<DateView: View>: View {
    @Environment(\.calendar) private var calendar
    let interval: DateInterval
    let content: (Date, Date) -> DateView
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 7), spacing: 0) {
            ForEach(months) { month in
                Section {
                    ForEach(days(of: month)) { date in
                        if calendar.isDate(date, equalTo: month, toGranularity: .month) {
                            content(month, date)
                        } else {
                            content(month, date).hidden()
                        }
                    }
                }
                .id(month)
            }
        }
    }
    private var months: [Date] {
        calendar.generateDates(interval: DateInterval(start: interval.start, end: interval.end.addingTimeInterval(1)), dateComponents: DateComponents(day: 1))
    }
    private func days(of month: Date) -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month),
              let firstWeekInterval = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
              let lastDayOfMonth = calendar.date(byAdding: .day, value: -1, to: monthInterval.end),
                let lastWeekInterval = calendar.dateInterval(of: .weekOfMonth, for: lastDayOfMonth)
        else { return [] }
        return calendar.generateDates(interval: DateInterval(start: firstWeekInterval.start, end: lastWeekInterval.end), dateComponents: DateComponents(hour:0, minute: 0, second: 0))
    }
}
