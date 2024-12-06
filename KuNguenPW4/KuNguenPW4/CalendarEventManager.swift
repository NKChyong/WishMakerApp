//
//  CalendarEventManager.swift
//  kuNguenPW3
//
//  Created by Нгуен Куиет Чыонг on 06.12.2024.
//

import UIKit
import EventKit

// MARK: - Protocol Definition
protocol CalendarManaging {
    func create(eventModel: CalendarEventModel) -> Bool
}

// MARK: - Calendar Event Model
struct CalendarEventModel {
    var title: String
    var startDate: Date
    var endDate: Date
    var note: String?
}

// MARK: - Calendar Manager Implementation
final class CalendarManager: CalendarManaging {
    private let eventStore: EKEventStore = EKEventStore()

    // MARK: - Synchronous Event Creation
    func create(eventModel: CalendarEventModel) -> Bool {
        var result = false
        let group = DispatchGroup()

        group.enter()
        create(eventModel: eventModel) { isCreated in
            result = isCreated
            group.leave()
        }
        group.wait()
        return result
    }

    // MARK: - Asynchronous Event Creation
    func create(eventModel: CalendarEventModel, completion: ((Bool) -> Void)?) {
        let createEvent: EKEventStoreRequestAccessCompletionHandler = { [weak self] (granted, error) in
            guard granted, error == nil, let self else {
                completion?(false)
                return
            }

            let event = EKEvent(eventStore: self.eventStore)
            event.title = eventModel.title
            event.startDate = eventModel.startDate
            event.endDate = eventModel.endDate
            event.notes = eventModel.note
            event.calendar = self.eventStore.defaultCalendarForNewEvents

            do {
                try self.eventStore.save(event, span: .thisEvent)
                completion?(true)
            } catch let error as NSError {
                print("Failed to save event with error: \(error)")
                completion?(false)
            }
        }

        // Request access to calendar
        if #available(iOS 17.0, *) {
            eventStore.requestFullAccessToEvents(completion: createEvent)
        } else {
            eventStore.requestAccess(to: .event, completion: createEvent)
        }
    }
}
