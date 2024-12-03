//
//  GameDetailView.swift
//  LevelUp
//
//  Created by Ilenia Munfuletto on 29/11/24.
//

import SwiftUI

struct ChosenSectionView : View {
   
    var selectedSection: Section
    
    @Binding var game: Game
    
    var body: some View {
        switch selectedSection {
        case .overview:
            GameDetailOverview(selectedSection: selectedSection, game: $game)
        case .story:
            GameDetailStory()
        case .characters:
            CharactersView(characters: $game.characters)
        case .guides:
            let _ = print("guides")
        }
    }
}


struct GameMainView : View {
    @State  var selectedSection: Section = .overview
    @Binding var game: Game
    
    let img_logo = ImageResource(name: "ACLogo", bundle: .main)
    
    var body: some View {
        VStack() {
            PickerSegmentedControl(selectedSection: $selectedSection)
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Image(img_logo)
                    .resizable()
                    .frame(width: 64, height: 64)
            }
        }
        .padding(.top, 48)
        .preferredColorScheme(.dark)
        Spacer()
        
        ChosenSectionView(selectedSection: selectedSection, game: $game)
    }
}



struct GameDetailOverview: View {
    var selectedSection: Section
    
    @Binding var game: Game
    
    @State var userPreferences: UserPreferences = loadPreferences()!
    
    var body: some View {
        Rectangle()
            .cornerRadius(32)
            .foregroundColor(Color(hex: 0x2b2b2b))
            .position(x:160, y:300)
            .frame(width: 320, height: 600)
            .overlay(
                VStack {
                    Image(ImageResource(name: game.cover, bundle: .main))
                        .resizable()
                        .frame(width: 240, height: 320)
                        .shadow(color: .purple, radius: 12, x: 0, y: 0)
                    Text(game.title)
                        .font(.system(size: 28, weight: .bold))
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    Button (action: {
                        game.favourite = !game.favourite
                        updateUserPreferences(game: game, isFavorite: game.favourite)
                    }) {
                        Image(systemName: game.favourite ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding()
                            .foregroundColor(.black)
                            .background(.gray)
                            .cornerRadius(50)
                    }
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
                        VStack (spacing: 10) {
                            Text("Piattaforme")
                                .font(.headline)
                            
                            HStack(spacing: 10) {
                                ForEach(game.platform, id:\.self) {
                                    platform in
                                    
                                    switch platform {
                                    case "PC":
                                        Image(systemName: "desktopcomputer")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    case "PS3", "Playstation 3", "PlayStation 3":
                                        Image(systemName: "playstation.logo")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    case "PS4", "Playstation 4", "PlayStation 4":
                                        Image(systemName: "playstation.logo")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.blue.opacity(0.8))
                                    case "PS5", "Playstation 5", "PlayStation 5":
                                        Image(systemName: "playstation.logo")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.blue)
                                    case "XBOX 360", "Xbox 360", "XBox 360":
                                        Image(systemName: "xbox.logo")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(Color(red: 158, green: 197, blue: 67))
                                    case "XBOX One", "Xbox One", "XBox One":
                                        Image(systemName: "xbox.logo")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.black)
                                    case "XBOX X/S", "Xbox Series X/S", "XBox Series X/S":
                                        Image(systemName: "xbox.logo")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(Color(red: 56, green: 121, blue: 38))
                                    default:
                                        Image(systemName: "gamecontroller")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.accent)
                                    }

                                }
                            }
                            
                        }
                        VStack(spacing: 10) {
                            Text("Rating")
                                .font(.headline)
                            
                            Text("\(game.recAge)+")
                                .font(.subheadline)
                        }
                        
                    }
                        
                })
            .onAppear {
                userPreferences = loadPreferences()!
                if userPreferences.favouriteGames.contains(game.id) {
                    game.favourite = true
                }
            }
    }
       
}




struct GameDetailStory: View {
    var body: some View {
        Text("Story")
        Spacer()
    }
    
}


enum Section : String, CaseIterable {
    case overview = "Overview"
    case story = "Story"
    case characters = "Characters"
    case guides = "Guides"
}


enum Platforms : String, CaseIterable {
    case pc = "PC"
    case xbox360 = "XBOX 360"
    case ps3 = "PS3"
    case xboxOne = "XBOX One"
    case ps4 = "PS4"
    case xboxSeriesXS = "XBOX Series X/S"
}


extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}

    

#Preview {
    GameMainView(selectedSection: .overview, game: .constant(Game(id: 0, title: "Assassin's Creed", cover: "Assassins_Creed_1", releaseYear: 2007, platform: ["PC", "XBOX 360", "PS3"], recAge: 18, favourite: false, characters: [])))
}

