//
//  GenerateView.swift
//  MazeGenerator
//
//  Created by Hasan Edain on 9/30/24.
//

import SwiftUI

struct GenerateView: View {
    @State var mazeWidthString: String = "10"
    @State var mazeHeightString: String = "10"
    @State var maze: Maze = Maze(height: 10, width: 10)
    @State var offsetString: String = "30"
    @State var tileSizeString: String = "25"
    @State var offset: Int = 30
    @State var tileSize: Int = 25

    var body: some View {
        VStack {
            HStack {
                MazeView(maze: maze, isSolved: true, offset: offset, tileSize: tileSize)
                MazeView(maze: maze, isSolved: false, offset: offset, tileSize: tileSize)
            }
            Form {
                TextField(text: $mazeWidthString) {
                    Label("Width", systemImage: "arrow.left.and.line.vertical.and.arrow.right")
                }.padding()
                TextField(text: $mazeHeightString) {
                    Label("Height", systemImage: "arrow.up.and.line.horizontal.and.arrow.down")
                }.padding()
                TextField(text: $offsetString) {
                    Label("Offset", systemImage: "arrow.right")
                }.padding()
                TextField(text: $tileSizeString) {
                    Label("Tile Size", systemImage: "arrow.left.and.right.square")
                }.padding()
                Button("Generate") {
                    gen()
                }
            }.frame(width: 300)
        }
    }

    func gen() {
        guard let mazeWidth = Int(mazeWidthString) else {
            print("Width not an integer")
            return
        }
        guard let mazeHeight = Int(mazeHeightString) else {
            print("Height not an integer")
            return
        }

        guard let tempOffset = Int(offsetString) else {
            print("Offset not an integer")
            return
        }

        guard let tileSize = Int(tileSizeString) else {
            print("Tile Size nont an integer")
            return
        }

        self.offset = tempOffset
        self.tileSize = tileSize

        let aMaze = Maze(height: mazeHeight, width: mazeWidth)
        
        self.maze = aMaze
    }
}

#Preview {
    GenerateView()
}
