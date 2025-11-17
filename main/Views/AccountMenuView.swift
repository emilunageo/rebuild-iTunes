//
//  AccountMenuView.swift
//  main
//
//  Created by iTunes Store MVP
//

import SwiftUI

struct AccountMenuView: View {
    @State private var isQuickLinksExpanded = false
    
    var body: some View {
        NavigationStack {
            List {
                // Account Section
                Section {
                    NavigationLink(destination: InfoView(title: "Account")) {
                        MenuRow(icon: "person.circle.fill", title: "View Account", iconColor: .blue)
                    }
                    
                    NavigationLink(destination: PurchasedView()) {
                        MenuRow(icon: "bag.fill", title: "Purchased", iconColor: .green)
                    }
                    
                    NavigationLink(destination: DownloadsView()) {
                        HStack {
                            MenuRow(icon: "arrow.down.circle.fill", title: "Downloads", iconColor: .orange)
                            Spacer()
                            // Mock download count badge
                            Text("3")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.red)
                                .cornerRadius(10)
                        }
                    }
                } header: {
                    Text("Account")
                }
                
                // Store Section
                Section {
                    NavigationLink(destination: RedeemCodeView()) {
                        MenuRow(icon: "giftcard.fill", title: "Redeem Gift Card or Code", iconColor: .red)
                    }
                    
                    NavigationLink(destination: InfoView(title: "Send Gift")) {
                        MenuRow(icon: "gift.fill", title: "Send Gift", iconColor: .pink)
                    }
                    
                    NavigationLink(destination: InfoView(title: "Add Funds")) {
                        MenuRow(icon: "dollarsign.circle.fill", title: "Add Funds to Apple ID", iconColor: .green)
                    }
                } header: {
                    Text("Store")
                }
                
                // Support Section
                Section {
                    NavigationLink(destination: TermsView()) {
                        MenuRow(icon: "doc.text.fill", title: "Terms & Conditions", iconColor: .gray)
                    }
                    
                    NavigationLink(destination: InfoView(title: "Privacy Policy")) {
                        MenuRow(icon: "hand.raised.fill", title: "Privacy Policy", iconColor: .blue)
                    }
                    
                    NavigationLink(destination: InfoView(title: "Contact Support")) {
                        MenuRow(icon: "questionmark.circle.fill", title: "Contact Support", iconColor: .purple)
                    }
                } header: {
                    Text("Support")
                }
                
                // Quick Links Section (Expandable)
                Section {
                    DisclosureGroup(
                        isExpanded: $isQuickLinksExpanded,
                        content: {
                            NavigationLink(destination: InfoView(title: "Top Charts")) {
                                MenuRow(icon: "chart.bar.fill", title: "Top Charts", iconColor: .orange, isSubItem: true)
                            }
                            
                            NavigationLink(destination: InfoView(title: "New Releases")) {
                                MenuRow(icon: "sparkles", title: "New Releases", iconColor: .yellow, isSubItem: true)
                            }
                            
                            NavigationLink(destination: InfoView(title: "Genres")) {
                                MenuRow(icon: "guitars.fill", title: "Genres", iconColor: .red, isSubItem: true)
                            }
                            
                            NavigationLink(destination: MusicVideosView()) {
                                MenuRow(icon: "play.rectangle.fill", title: "Music Videos", iconColor: .blue, isSubItem: true)
                            }
                            
                            NavigationLink(destination: RingtonesView()) {
                                MenuRow(icon: "bell.fill", title: "Ringtones", iconColor: .green, isSubItem: true)
                            }
                        },
                        label: {
                            MenuRow(icon: "link.circle.fill", title: "Music Quick Links", iconColor: .indigo)
                        }
                    )
                } header: {
                    Text("Quick Links")
                }
            }
            .navigationTitle("Account")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// Menu row component
struct MenuRow: View {
    let icon: String
    let title: String
    let iconColor: Color
    var isSubItem: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: isSubItem ? 16 : 20))
                .foregroundColor(iconColor)
                .frame(width: isSubItem ? 24 : 28)
            
            Text(title)
                .font(isSubItem ? .subheadline : .body)
        }
    }
}

#Preview {
    AccountMenuView()
}

