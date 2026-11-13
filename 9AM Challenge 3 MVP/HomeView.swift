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
