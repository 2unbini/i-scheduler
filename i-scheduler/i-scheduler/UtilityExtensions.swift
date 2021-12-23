//
//  UtilityExtensions.swift
//  i-scheduler
//
//  Created by sun on 2021/12/13.
//

import SwiftUI

extension Date {
    var midnight: Date {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        let midnightString = formatter.string(from: self)
        return formatter.date(from: midnightString) ?? self
    }
    
    var tomorrowMidnight: Date {
        var components = DateComponents()
        components.day = 1
        return Calendar.current.date(byAdding: components, to: midnight) ?? midnight
    }
}

extension Int: Identifiable {
    public var id: Int { self }
}

extension View {
    func cardify(size: CGSize) -> some View {
        self.modifier(Cardify(size: size))
    }
}
