//
//  ContentView.swift
//  testApp001
//
//  Created by Shumpei Kotaka on R 3/12/03.
//

import SwiftUI

struct ContentView: View {
    
    @State private var players = ["奥野", "義江", "三谷", "若山"]
    @State private var service = ["S", "", "R", ""]
    @State private var points = [["0"], [""], ["0"], [""]]
    @State private var score = [0, 0]
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    VStack {
                        TextField("my name", text: $players[0])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("my name", text: $players[1])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    Text("0")
                        .font(.title)
                    VStack {
                        Text(String(score[0]) + " - " + String(score[1]))
                        Text(String(score[0]) + " - " + String(score[1]))
                    }
                    Text("0")
                        .font(.title)
                    VStack {
                        TextField("my name", text: $players[2])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("my name", text: $players[3])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                .padding()
                
                HStack(alignment: .center, spacing: 0) {
                    VStack {
                        ForEach(0..<4){ i in
                            Text(players[i])
                                .frame(width: 120, height: 30)
                                .border(Color.black, width: 1)
                        }
                    }
                    VStack {
                        ForEach(0..<4){ i in
                            Button(action: {
                                changeService()
                            }){
                                Text(service[i])
                                    .foregroundColor(Color.black)
                                    .frame(width: 30, height: 30)
                                    .border(Color.black, width: 1)
                            }
                        }
                    }
                    ScrollView(.horizontal) {
                        HStack(alignment: .center, spacing: 0) {
                            ForEach(0..<points[0].count, id: \.self){ j in
                                VStack {
                                    ForEach(0..<4){ i in
                                        Text(points[i][j])
                                            .foregroundColor(Color.black)
                                            .frame(width: 30, height: 30)
                                            .border(Color.black, width: 1)
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
                
                HStack {
                    ForEach(0..<2){ i in
                        Button(action: {
                            addPoint(p_team: i)
                        }){
                            Text(self.players[i*2] + "\n" + self.players[i*2+1])
                                .bold()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundColor(Color.white)
                                .background(Color.yellow)
                                .clipShape(Circle())
                        }
                    }
                }
                
                Spacer()
            }
            .navigationBarTitle(Text("score sheet"), displayMode: .inline)
            .navigationBarItems(
                leading: Text("save"),
                trailing: Button("back") {backScore()}
            )
        }
    }
    
    func changeService() {
        if self.points[0].count > 1 {return}
        
        if self.service == ["S", "", "R", ""] {self.service = ["", "S", "R", ""]}
        else if self.service == ["", "S", "R", ""] {self.service = ["S", "", "", "R"]}
        else if self.service == ["S", "", "", "R"] {self.service = ["", "S", "", "R"]}
        else if self.service == ["", "S", "", "R"] {self.service = ["R", "", "S", ""]}
        else if self.service == ["R", "", "S", ""] {self.service = ["", "R", "S", ""]}
        else if self.service == ["", "R", "S", ""] {self.service = ["R", "", "", "S"]}
        else if self.service == ["R", "", "", "S"] {self.service = ["", "R", "", "S"]}
        else if self.service == ["", "R", "", "S"] {self.service = ["S", "", "R", ""]}
        
        for i in 0...3 {
            if self.service[i] != "" {self.points[i][0] = "0"}
            else {self.points[i][0] = ""}
        }
    }
        
    
    func addPoint(p_team: Int) {
        let len = self.points[0].count - 1
        var s_team = 0
        var r_team = 0
        var s_player = 0
        var r_player = 100
        var isFinish = false
        
        var point_player = 0
        
        if len == 0 {
            for i in 0...3 {
                if self.service[i] == "S" {s_player = i}
                if self.service[i] == "R" {r_player = i}
            }
        } else {
            for i in 0...len {
                for j in 0...3 {
                    if self.points[j][len - i] != "" {
                        if isFinish && s_player != j {r_player = j; break}
                        if !isFinish {s_player = j; isFinish = true}
                    }
                }
                if r_player != 100 {break}
            }
        }
        
        if s_player == 0 || s_player == 1 {s_team = 0; r_team = 1}
        if s_player == 2 || s_player == 3 {s_team = 1; r_team = 0}
        
        if p_team == s_team {point_player = s_player}
        if p_team == r_team {
            if r_player % 2 == 0 {point_player = r_player + 1}
            else {point_player = r_player - 1}
        }
        
        for i in 0...3 {
            if i == point_player {
                self.score[p_team] += 1
                self.points[i].append(String(self.score[p_team]))
            } else {
                self.points[i].append("")
            }
        }
    }
    
    func backScore() {
        if self.points[0].count == 1 {return}
        
        var point_player = 0
        var point_team = 0
        for i in 0...3 {
            if self.points[i].last != "" {point_player = i}
            self.points[i].removeLast()
        }
        if point_player == 0 || point_player == 1 {point_team = 0}
        if point_player == 2 || point_player == 3 {point_team = 1}
        
        self.score[point_team] = self.score[point_team] - 1
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
