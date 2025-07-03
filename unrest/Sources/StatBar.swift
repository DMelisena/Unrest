//
//  StatBar.swift
//  unrest
//
//  Created by Arya Hanif on 29/06/25.
//
import SwiftUI

// MARK: - Stat Bar Component
struct StatBar: View {
    let label: String
    let value: Int
    let color: Color
    let icon: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.caption)
                .frame(width: 12)
            
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
                .frame(width: 30, alignment: .leading)
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(value) / 20, height: 6)
                        .cornerRadius(3)
                        .animation(.easeInOut(duration: 0.3), value: value)
                }
            }
            .frame(height: 6)
            
            Text("\(value)")
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(color)
                .frame(width: 25, alignment: .trailing)
        }
    }
}
