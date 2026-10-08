import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn = false
    @State private var showError = false

    // Demo only credentials
    let correctUsername = "FantasyAssistantDemo"
    let correctPassword = "FantasyPassword0102"

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                // App logo (home screen)
                VStack(spacing: 32) {
                    if let logo = UIImage(named: "ASSISTANT") {
                        Image(uiImage: logo)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 180)
                    }
                    // Username field
                    VStack(spacing: 16) {
                        TextField("Username", text: $username)
                            .padding()
                            .background(Color.gray.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .autocapitalization(.none)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.yellow, lineWidth: 2)
                            )
                        // Password field
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.gray.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.yellow, lineWidth: 2)
                            )
                    }

                    if showError {
                        Text("Incorrect username or password.")
                            .foregroundColor(.red)
                            .font(.subheadline)
                    }

                    // Login button
                    Button(action: {
                        if username == correctUsername && password == correctPassword {
                            isLoggedIn = true
                            showError = false
                        } else {
                            showError = true
                        }
                    }) {
                        Text("LOGIN")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                MainTabView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    LoginView()
}
