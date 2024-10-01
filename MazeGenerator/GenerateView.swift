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

    @State var filename: String = "puzzle"
    @State var saveCountString: String = "0"


    var body: some View {
        VStack {
            HStack {
                MazeView(maze: maze, isSolved: true, offset: offset, tileSize: tileSize)
                MazeView(maze: maze, isSolved: false, offset: offset, tileSize: tileSize)
            }
            Form {
                TextField(text: $mazeWidthString) {
                    Label("Width", systemImage: "arrow.left.and.line.vertical.and.arrow.right")
                }
                TextField(text: $mazeHeightString) {
                    Label("Height", systemImage: "arrow.up.and.line.horizontal.and.arrow.down")
                }
                TextField(text: $offsetString) {
                    Label("Offset", systemImage: "arrow.right")
                }
                TextField(text: $tileSizeString) {
                    Label("Tile Size", systemImage: "arrow.left.and.right.square")
                }
                Button("Generate") {
                    gen()
                }.padding(.bottom)
                TextField(text: $filename) {
                    Label("Filename", systemImage: "richtext.page.fill")
                }
                TextField(text: $saveCountString) {
                    Label("Save Count", systemImage: "richtext.page.fill")
                }
                Button("Save") {
                    save()
                }.padding(.bottom)
            }
            .padding()
            .frame(width: 300)
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

    @MainActor func save() {
        let rendererSolved = ImageRenderer(content: MazeView(maze: maze, isSolved: true, offset: 0, tileSize: self.tileSize))
        let redererPuzzle = ImageRenderer(content: MazeView(maze: maze, isSolved: false, offset: 0, tileSize: self.tileSize))

        guard let saveCount = Int(self.saveCountString) else {
            return
        }

        let homeURL = FileManager.default.homeDirectoryForCurrentUser
        let solvedUrl = homeURL.appending(path: "\(filename)_\(saveCount)_solved.pdf")
        print("\(solvedUrl.absoluteString)")
        let unsolvedUrl = homeURL.appending(path: "\(filename)_\(saveCount)_puzzle.pdf")
        guard let width = Float(mazeWidthString) else  {
            return
        }
        guard let height = Float(mazeHeightString) else {
            return
        }

        rendererSolved.render { size, renderInContext in
            var box = CGRect(
                origin: .zero,
                size: .init(width: CGFloat(width)*CGFloat(tileSize), height: CGFloat(height)*CGFloat(tileSize))
            )

            guard let context = CGContext(solvedUrl as CFURL, mediaBox: &box, nil) else {
                return
            }

            context.beginPDFPage(nil)
            renderInContext(context)
            context.endPage()
            context.closePDF()
        }

        redererPuzzle.render { size, renderInContext in
            var box = CGRect(
                origin: .zero,
                size: .init(width: CGFloat(width)*CGFloat(tileSize), height: CGFloat(height)*CGFloat(tileSize))
            )

            guard let context = CGContext(unsolvedUrl as CFURL, mediaBox: &box, nil) else {
                return
            }

            context.beginPDFPage(nil)
            renderInContext(context)
            context.endPage()
            context.closePDF()
        }

        self.saveCountString = String(saveCount + 1)
    }
}

#Preview {
    GenerateView()
}
