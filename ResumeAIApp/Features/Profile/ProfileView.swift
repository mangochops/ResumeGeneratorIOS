import SwiftUI


struct ProfileView: View {
    // Fetch user details from your existing AuthService
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    HeaderTitleView(
                        name: "Profile"
                        
                    )
                    
                    // MARK: - PROFILE HEADER CARD
                    VStack(spacing: 16) {
                        HStack(spacing: 20) {
                            ZStack {
                                Circle()
                                    .fill(Color.blue.gradient.opacity(0.1))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "person.fill")
                                    .font(.system(size: 30, weight: .bold))
                                    .foregroundStyle(.blue.gradient)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                        // Updated to use our new Profile model logic
                                        Text(viewModel.profile?.fullName ?? "User")
                                    .font(.title3.bold())
                                        
                                        // Show Badge if User is Pro
                                Text("\(viewModel.profile?.credits ?? 0) Credits Remaining")
                                                                    .font(.caption)
                                                                    .foregroundStyle(.secondary)
                                    }
                            
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .padding(.horizontal)

                    // MARK: - ACCOUNT SECTION
                    profileSection(title: "ACCOUNT") {
                        NavigationLink(destination: EditProfileView()) {
                            settingsRow(icon: "person.crop.circle", title: "Edit Profile", color: .blue)
                        }
                        Divider().padding(.leading, 50)
                        NavigationLink(destination: Text("Premium")) {
                            settingsRow(icon: "crown.fill", title: "Upgrade to Premium", color: .orange)
                        }
                    }

                    

                    // MARK: - SUPPORT & LEGAL
                    profileSection(title: "SUPPORT") {
                        NavigationLink(destination: ContactSupportView()) {
                        settingsRow(icon: "gear", title: "Contact Support", color: .cyan)
                        }
                        Divider().padding(.leading, 50)
                        NavigationLink(destination: PrivacyPolicyView()) {
                        settingsRow(icon: "shield.lefthalf.filled", title: "Privacy Policy", color: .cyan)
                        }
                        Divider().padding(.leading, 50)
                        NavigationLink(destination: TermsConditionView()) {
                        settingsRow(icon: "doc.append.fill.rtl", title: "Terms & Conditions", color: .cyan)
                        }
                    }

                    // MARK: - LOGOUT BUTTON
                    Button(role: .destructive) {
                        Task { try? await AuthService.shared.signOut() }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                            Text("Sign Out")
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    Text("CV Pilot v1.0.4")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .padding(.bottom, 20)
                }
                .padding(.top)
            }
            .background(Color(UIColor.systemGroupedBackground))
            
            .task {
                await viewModel.loadUserData()
                        }
//            .onAppear {
//                await viewModel.loadUserData()
//            }
        }
    }

    // MARK: - Helper Views to keep code clean
    
    private func profileSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .padding(.leading, 24)
            
            VStack(spacing: 0) {
                content()
            }
            .background(Color(UIColor.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal)
        }
    }

    private func settingsRow(icon: String, title: String, color: Color) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.body.bold())
                .foregroundStyle(color)
                .frame(width: 32, height: 32)
                .background(color.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(title)
                .font(.body)
                .foregroundStyle(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundStyle(.tertiary)
        }
        .padding()
    }
    
    private func settingsButton(icon: String, title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            settingsRow(icon: icon, title: title, color: color)
        }
    }
}
#Preview {
    ProfileView()
}
