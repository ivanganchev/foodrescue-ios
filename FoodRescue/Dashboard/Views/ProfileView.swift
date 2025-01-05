//
//  ProfileView.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2025-01-05.
//

import SwiftUI

struct ProfileView: View {
    var logoutAction: () -> Void
    
    var body: some View {
        Text("My Profile")
            .multilineTextAlignment(.center)
            .font(.title)
            .fontWeight(.bold)
        List {
            Section {
                Button(action: logoutButtonTapped) {
                    HStack {
                        Text("Logout")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    func logoutButtonTapped() {
        logoutAction()
    }
}
