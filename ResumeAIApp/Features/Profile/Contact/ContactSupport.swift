//
//  ContactSupport.swift
//  ResumeAIApp
//
//  Created by mac on 3/19/26.
//

import SwiftUI

struct ContactSupportView: View {
    @State private var message = ""
    @State private var subject = "Help with CV Pilot"
    
    var body: some View {
        Form {
            Section("How can we help?") {
                Picker("Subject", selection: $subject) {
                    Text("Technical Issue").tag("Technical Issue")
                    Text("Billing").tag("Billing")
                    Text("Feature Request").tag("Feature Request")
                    Text("Other").tag("Other")
                }
                TextEditor(text: $message)
                    .frame(height: 150)
                    .overlay(alignment: .topLeading) {
                        if message.isEmpty {
                            Text("Describe your issue here...")
                                .foregroundColor(.gray.opacity(0.5))
                                .padding(.top, 8)
                                .padding(.leading, 5)
                        }
                    }
            }
            
            Button {
                // Here you would send this to your Supabase 'support_tickets' table
                print("Ticket sent: \(message)")
            } label: {
                Text("Send Message")
                    .frame(maxWidth: .infinity)
                    .fontWeight(.bold)
            }
            .disabled(message.isEmpty)
        }
        .navigationTitle("Support")
    }
}

#Preview {
    ContactSupportView()
}
