//
//  NotificationManager.swift
//  Pokedex
//
//  Created by Dylan on 24/02/2025.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if let error = error {
                print("Erreur lors de la demande de permission: \(error.localizedDescription)")
            } else {
                print("Permission accordée")
            }
        }
    }
    
    func scheduleDailyPokemonNotification(pokemon: Pokemon) {
        let identifier = "dailyPokemon"
        
        let content = UNMutableNotificationContent()
        
        content.title = "Pokémon du jour !"
        content.body = "Découvre \(pokemon.name.capitalized) aujourd'hui !"
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: DateComponents(hour: 9, minute: 0),
            repeats: false
        )

        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Erreur lors de la planification : \(error.localizedDescription)")
            } else {
                print("Notification quotidienne programmée avec succès !")
            }
        }
    }
    
    private func isNotificationScheduled(identifier: String, completion: @escaping (Bool) -> Void) {
         UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
             let isScheduled = requests.contains { $0.identifier == identifier }
             completion(isScheduled)
         }
     }
}
