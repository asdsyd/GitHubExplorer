//
//  UserProfile.swift
//  GitHubExplorer
//
//  Created by Asad Sayeed on 04/08/24.
//

import SwiftUI

struct UserProfile: View {
    let username: String!
    @State private var user: User?
    @State private var note: Note?
    @State private var noteText: String = ""
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let user = user {
                    ProfileHeaderView(user: user)
                    StatsView(user: user)
                    ProfileInfoView(user: user)
                    UserSinceView(user: user)
                    Spacer()
                    NoteView(noteText: $noteText, isTextFieldFocused: _isTextFieldFocused, onSubmit: saveNote)
                    Spacer()
                } else {
                    ProgressView()
                }
            }
            .padding()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { fetchUserProfile() }
        .onAppear { loadNote() }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    
    private func fetchUserProfile() {
        NetworkManager.shared.getUserInfo(for: username) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
                case .failure(let error):
                    self.showAlert(title: "Something went wrong", message: error.rawValue)
                }
            }
        }
    }
    
    private func loadNote() {
        let follower = Follower(login: username, avatarUrl: "")
        NotesProvider.shared.createNoteIfNeeded(for: follower)
        if let existingNote = NotesProvider.shared.getNoteForUser(follower) {
            noteText = existingNote.note
            note = existingNote
        }
    }
    
    
    private func saveNote() {
        let _ = Follower(login: username, avatarUrl: "")
        if let existingNote = note {
            existingNote.note = noteText
        } else {
            let newNote = Note(context: NotesProvider.shared.viewContext)
            newNote.username = username
            newNote.note = noteText
            note = newNote
        }
        DispatchQueue.main.async {
            NotesProvider.shared.saveContext()
        }
    }
    
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
}


struct ProfileHeaderView: View {
    let user: User
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: user.avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
            } placeholder: {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
            }
            
            Text(user.name ?? user.login)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(user.bio ?? "Empty Bio")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}


struct StatsView: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 20) {
            StatItemView(title: "Repos", value: "\(user.publicRepos)")
            StatItemView(title: "Following", value: "\(user.following)")
            StatItemView(title: "Followers", value: "\(user.followers)")
        }
    }
}

struct StatItemView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.headline)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}


struct ProfileInfoView: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            InfoRowView(icon: "mappin.and.ellipse", text: user.location ?? "N/A")
            InfoRowView(icon: "person.2", text: user.company ?? "N/A")
            InfoRowView(icon: "envelope", text: user.email ?? "N/A")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}


struct InfoRowView: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 20, alignment: .center)
            Text(text)
                .multilineTextAlignment(.leading)
        }
        .padding(.leading, 20)
    }
}


struct UserSinceView: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .center) {
            Text("User since: \(user.formattedDateCreatedAt)")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}


struct NoteView: View {
    @Binding var noteText: String
    @FocusState var isTextFieldFocused: Bool
    var onSubmit: () -> Void
    
    var body: some View {
        VStack {
            TextField("Tap to add a note", text: $noteText, axis: .vertical)
                .lineLimit(5...10)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .focused($isTextFieldFocused)
                .onSubmit {
                    onSubmit()
                    isTextFieldFocused = false
                }
        }
    }
}


#Preview {
    UserProfile(username: "Example")
}
