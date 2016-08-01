//
//  WorkoutManager.swift
//  Heart Control
//
//  Created by Thomas Paul Mann on 01/08/16.
//  Copyright © 2016 Thomas Paul Mann. All rights reserved.
//

import HealthKit

class WorkoutManager: NSObject {

    // MARK: - Properties

    private let healthStore = HKHealthStore()

    private var workoutSession: HKWorkoutSession?
    private var workoutStartDate: Date?

    // MARK: - API

    func start() {
        // If we have already started the workout, then do nothing.
        if (workoutSession != nil) {
            // Another workout is running.
            return
        }

        // Configure the workout session.
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .other
        workoutConfiguration.locationType = .indoor

        // Create workout session.
        do {
            workoutSession = try HKWorkoutSession(configuration: workoutConfiguration)
            workoutSession!.delegate = self

            workoutStartDate = Date()
        } catch {
            fatalError("Unable to create Workout Session!")
        }

        // Start workout session.
        healthStore.start(workoutSession!)
    }

    func stop() {
        // If we have already stopped the workout, then do nothing.
        if (workoutSession == nil) {
            return
        }

        // Stop the workout session.
        healthStore.end(workoutSession!)

        // Clear the workout session.
        workoutSession = nil
    }

}


// MARK: - Workout Session Delegate

extension WorkoutManager: HKWorkoutSessionDelegate {

    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("Switch to \(toState.description()) from \(fromState.description())")
    }


    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: NSError) {
        fatalError(error.localizedDescription)
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didGenerate event: HKWorkoutEvent) {
        print("Did generate \(event)")
    }
    
}