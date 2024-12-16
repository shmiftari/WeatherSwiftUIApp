//
//  WeatherView.swift
//  WeatherSwiftUIApp
//
//  Created by Gjakova on 16.12.24.
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel: WeatherViewModel
    @State private var isCompactView = false
    
    init(viewModel: WeatherViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color(UIColor.systemGray5))
                        .frame(height: 44)
                    
                    HStack {
                        TextField("Search Location", text: $viewModel.cityName)
                            .padding(.leading, 12)
                            .onSubmit {
                                Task {
                                    await viewModel.fetchWeather()
                                    isCompactView = true
                                }
                            }
                        
                        Spacer()
                        
                        Button(action: {
                            Task {
                                await viewModel.fetchWeather()
                                isCompactView = true
                                hideKeyboard()
                            }
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.trailing, 12)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.title2)
                        .foregroundColor(.red)
                        .padding()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                        .cornerRadius(12)
                } else if let weather = viewModel.weather {
                    if isCompactView {
                        Button(action: { isCompactView = false }) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(weather.location.name)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                    
                                    Text("\(weather.current.temp_c)°")
                                        .font(.system(size: 64, weight: .bold))
                                        .foregroundColor(.black)
                                }
                                Spacer()
                                Image(systemName: "cloud.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.blue)
                            }
                            .padding()
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .padding(.top, 32)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        VStack {
                            Image(systemName: "cloud.sun.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .foregroundColor(.orange)
                            
                            Text(weather.location.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Text("\(weather.current.temp_c)°")
                                .font(.system(size: 80, weight: .bold))
                                .foregroundColor(.black)
                            
                            HStack {
                                VStack {
                                    Text("Humidity")
                                        .font(.caption)
                                    Text("\(weather.current.humidity)%")
                                        .fontWeight(.bold)
                                }
                                Spacer()
                                VStack {
                                    Text("UV")
                                        .font(.caption)
                                    Text("\(weather.current.uv)")
                                        .fontWeight(.bold)
                                }
                                Spacer()
                                VStack {
                                    Text("Feels Like")
                                        .font(.caption)
                                    Text("\(weather.current.feelslike_c)°")
                                        .fontWeight(.bold)
                                       
                                }
                            }
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(12)
                            .padding(.leading, 48)
                            .padding(.trailing, 48)
                            .padding(.horizontal)
                        }
                    }
                } else {
                    Text(viewModel.cityName.isEmpty ? "No city selected\nPlease search for a city" : "Loading weather...")
                        .font(.title2)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .cornerRadius(12)
                }
                
                Spacer()
            }
            .onAppear {
                if !viewModel.cityName.isEmpty {
                    Task {
                        await viewModel.fetchWeather()
                    }
                }
            }
        }
    }

}


extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
