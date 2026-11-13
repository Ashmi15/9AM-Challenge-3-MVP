//
//  HomeView.swift
//  9AM Challenge 3 MVP
//
//  Created by Ashmi Sharma on 13/11/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack() {
                    // Welcome
                    HStack {
                        VStack() {
                            Text("Hello Munchkin!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Text("Are you ready for your next food adventure?")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .bold()
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Your Current Food Persona")
                                    .font(.headline)
                                HStack(spacing: 15) {
                                    Text("🐶")
                                        .font(.system(size: 65))
                                    
                                    VStack(alignment:.leading, spacing: 6) {
                                        Text("The Comfort Foodie")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        
                                        Text("Like Cookie the puppy, lying on the couch while eating a tub of ice cream from Yo-Chi is your thing!")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                            .bold()
                                    }
                                    
                                    Spacer()
                                    
                                }
                            }
                            .padding(20)
                            .frame(width: 375, height: 205)
                            .background(Color(red: 1.0, green: 0.87, blue: 0.75))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                            VStack(alignment: .leading, spacing: 5) {
                                VStack {
                                    Text("Goals Left For This Month")
                                        .font(.headline)
                                    
                                    Text("November")
                                        .font(.subheadline)
                                        .foregroundStyle(.gray)
                                        .bold()
                                    
                                    GoalProgressRow(
                                        title: "Try 3 new restaurants",
                                        progress: 2,
                                        total: 3
                                    )
                                    
                                    GoalProgressRow(
                                        title: "Explore 2 new cuisines",
                                        progress: 1,
                                        total: 2
                                    )
                                    
                                    GoalProgressRow(
                                        title: "Review 5 restaurants",
                                        progress: 3,
                                        total: 5
                                    )
                                }
                                    .padding(20)
                                    .background(Color(red: 0.65, green: 0.89, blue: 0.75))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .frame(width: 375, height: 205)
                                    
                                    
                                    
                            }
                        }
                        
                    }
                    
                    
                    
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
