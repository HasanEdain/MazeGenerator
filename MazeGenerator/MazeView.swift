//
//  MazeView.swift
//  MazeGenerator
//
//  Created by Hasan Edain on 9/30/24.
//

//Lifted directly from:
//https://github.com/WKosikowski/maze_generator_swift/

import SwiftUI

struct MazeView: View {
    let maze: Maze
    let isSolved: Bool
    let offset: Int
    let tileSize: Int
    let inset: Int = 4

    var body: some View {
        ZStack {
            mazeView(maze: maze)
                .background(.white)
                .frame(width: CGFloat(tileSize*maze.width), height: CGFloat(tileSize*maze.height))
            VStack {
                HStack {
                    Circle()
                        .offset(CGSize(width: offset + inset, height: offset + inset))
                        .fill(.gray)
                        .frame(width: CGFloat(tileSize - inset*2),height: CGFloat(tileSize - inset*2))
                    Spacer()
                }
                Spacer()
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "octagon.fill")
                        .offset(CGSize(width: -offset - inset, height: -offset - inset))
                        .foregroundStyle(.black)
                        .frame(width: CGFloat(tileSize - inset*2),height: CGFloat(tileSize - inset*2))

                }

            }
        }.frame(width: CGFloat(tileSize*maze.width + offset*2), height: CGFloat(tileSize*maze.height) + CGFloat(offset)*2.0)

    }

    @ViewBuilder func mazeView(maze: Maze) -> some View {
        let frameHeight = CGFloat(offset * 2 + maze.height * tileSize)
        let frameWidth = CGFloat(offset * 2 + maze.width * tileSize)
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: offset, y: offset))
                path.addLine(to: CGPoint(x: offset + maze.width * tileSize, y: offset))
                path.addLine(to: CGPoint(x: offset + maze.width * tileSize, y: offset + maze.height * tileSize))
                path.addLine(to: CGPoint(x: offset, y: offset + maze.height * tileSize))
                path.addLine(to: CGPoint(x: offset, y: offset))
            }
            .stroke(.black, lineWidth: 3.0)
            .frame(width: frameWidth, height: frameHeight, alignment: .center)
            Path { path in
                for y in 0 ... maze.height - 1 {
                    for x in 0 ... maze.width - 1 {
                        if maze.maze[y][x].rightNode != nil {
                        } else {
                            let wallPosX = offset + tileSize * (x + 1)
                            let wallPosY = offset + tileSize * (y + 1)

                            path.move(to: CGPoint(x: wallPosX, y: wallPosY))
                            path.addLine(to: CGPoint(x: wallPosX, y: wallPosY - tileSize))
                        }
                        if maze.maze[y][x].downNode != nil {
                        } else {
                            let wallPosX = offset + tileSize * (x + 1)
                            let wallPosY = offset + tileSize * (y + 1)

                            path.move(to: CGPoint(x: wallPosX, y: wallPosY))
                            path.addLine(to: CGPoint(x: wallPosX - tileSize, y: wallPosY))
                        }
                    }
                }
            }
            .stroke(.black, lineWidth: 2.0)
            .frame(width: frameWidth, height: frameHeight, alignment: .center)

            if isSolved {
                Path { path in
                    let startDrawPosX = CGFloat(offset + tileSize / 2)
                    let startDrawPosY = CGFloat(offset + tileSize / 2)
                    path.move(to: CGPoint(x: startDrawPosX, y: startDrawPosY))
                        //  maze.findPath(findX: maze.width - 1, findY: maze.height - 1)
                    for i in maze.path {
                        let nextDrawPosX = startDrawPosX + CGFloat(i.posX * tileSize)
                        let nextDrawPosY = startDrawPosY + CGFloat(i.posY * tileSize)
                        path.addLine(to: CGPoint(x: nextDrawPosX, y: nextDrawPosY))
                    }
                }
                .stroke(.gray, lineWidth: 2.0)
                .frame(width: frameWidth, height: frameHeight, alignment: .center)
            }
        }
    }

}

#Preview {
    let maze = Maze(height: 10, width: 10)

    VStack {
        MazeView(maze: maze, isSolved: true, offset: 25, tileSize: 30)
        MazeView(maze: maze, isSolved: false, offset: 30, tileSize: 25)
    }.padding()
}
