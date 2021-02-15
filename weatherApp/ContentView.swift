//
//  ContentView.swift
//  weatherApp
//
//  Created by Albert Estevan on 13/02/21.
//

import SwiftUI

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}

struct ContentView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    
//    @State private var isNight = false
    
    private let iconMap = [
        "Thunderstorm": "cloud.bolt.fill",
        "Drizzle": "cloud.drizzle.fill",
        "Rain": "cloud.rain.fill",
        "Snow": "cloud.snow.fill",
        "Atmosphere": "cloud.fog.fill",
        "Clear": "sun.max.fill",
        "Clouds": "smoke.fill",
        "": "cloud.fill"
    ]
    
    var body: some View {
        ZStack {
                        
//            Print("cond", ((viewModel.daily.first?.dt ?? 0) > (viewModel.daily.first?.sunset ?? 0)))

            BackgroundView(isNight: ((viewModel.daily.first?.dt ?? 0) > (viewModel.daily.first?.sunset ?? 0)))

            ScrollView(.vertical, showsIndicators: false) {
                                
                VStack {
                    CityTextView(cityName: "\(viewModel.cityName)")
                    
                    MainWeatherStatusView(imageName: "\(viewModel.weatherIcon)",
                                          temperature: viewModel.temperature,
                                          weatherDesc: viewModel.weatherDescription,
                                          maxTemp: viewModel.daily.first?.temp.max ?? 0.0,
                                          minTemp: viewModel.daily.first?.temp.min ?? 0.0)
                     
                    ScrollView(.horizontal, showsIndicators: false) {

                        HStack {
                            let firstElement = viewModel.hourly.first
                            
                            WeatherDayView(hour: "Now",
                                           imageName: iconMap[firstElement?.weather.first?.iconName ?? ""] ?? "",
                                           temperature: Int(firstElement?.temp ?? 0))
                            
                            ForEach(viewModel.hourly.dropFirst(), id: \.dt) { hourly in

                                WeatherDayView(hour: "\(GetHourfromEpoch(epoch: hourly.dt))",
                                               imageName: iconMap[hourly.weather.first?.iconName ?? ""] ?? "",
                                               temperature: Int(hourly.temp))
                            }
                            
                        }

                    }
                    .padding(.top, 5)
                    .overlay(Rectangle().frame(width: nil, height: 0.25, alignment: .top).foregroundColor(Color.white), alignment: .top)
                
                
            
                    VStack(spacing: 10) {

//                        FutureDaysWeatherView(dayName: "Wednesday",
//                                              imageName: "cloud.sun.fill",
//                                              maxTemp: 16.0,
//                                              minTemp: 13.0)

                        
                        ForEach(viewModel.daily.dropFirst(), id: \.dt) { daily in
                            
                            FutureDaysWeatherView(dayName: GetDayfromEpoch(epoch: daily.dt),
                                                  imageName: iconMap[daily.weather.first?.iconName ?? ""] ?? "",
                                                  maxTemp: daily.temp.max,
                                                  minTemp: daily.temp.min)
                        }

                    }
                    .padding([.leading, .trailing], 15)
                    .padding([.top, .bottom], /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .overlay(Rectangle().frame(width: nil, height: 0.5, alignment: .top).foregroundColor(Color.white), alignment: .top)

                }

//                Button {
//                    isNight.toggle()
//                } label: {
//                    WeatherButton(title: "Change Day Time",
//                                  textColor:.blue,
//                                  backgroundColor: .white)
//                }
                
                Spacer()
            }
            
        
        }.onAppear(perform: viewModel.refresh)
      
    }
}

func GetHourfromEpoch(epoch: Int) -> Int {
    let epocTime = TimeInterval(epoch)
    
    let resDate = Date(timeIntervalSince1970: epocTime)
    
    let hour = Calendar.current.component(.hour, from: resDate)

    return hour
}

func GetDayfromEpoch(epoch: Int) -> String {
    let epocTime = TimeInterval(epoch)
    
    let resDate = Date(timeIntervalSince1970: epocTime)
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    let dayInWeek = dateFormatter.string(from: resDate)

    return dayInWeek
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WeatherViewModel(weatherService: WeatherService()))
    }
}

struct WeatherDayView: View {
    
    var hour: String
    var imageName: String
    var temperature: Int
    
    var body: some View {
        VStack {
            Text(hour)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
            
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
            
            Text("\(temperature)°")
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.white)
            
        }
        .padding(.leading, 15)
    }
}

struct BackgroundView: View {
    
//    @Binding var isNight: Bool
    var isNight: Bool

    
    var body: some View {
        
        LinearGradient(gradient: Gradient(colors: [isNight ? .black : .blue, isNight ? .gray: Color("lightBlue")]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
    }
}

struct CityTextView: View {
    
    var cityName: String
    
    var body: some View {
        Text(cityName)
            .padding(.top, 40)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundColor(.white)
        
    }
}

struct MainWeatherStatusView: View {
    
    var imageName: String
    var temperature: String
    var weatherDesc: String
    var maxTemp: Double
    var minTemp: Double

    var body: some View {
        VStack(spacing: 10) {
            Text(weatherDesc)
                .font(.system(size: 20))
                .foregroundColor(.white)
            
            Text(temperature)
                .font(.system(size: 90, weight: .light))
                .foregroundColor(.white)
            
            HStack {
                Text("H:\(Int(maxTemp))")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                Text("L:\(Int(minTemp))")
                    .font(.system(size: 20))
                    .foregroundColor(.white)

            }
            
        }
        .padding(.bottom, 80)
    }
}

struct FutureDaysWeatherView: View {
    
    var dayName: String
    var imageName: String
    var maxTemp: Double
    var minTemp: Double
        
    var body: some View {
            HStack {
                Text(dayName)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                
                HStack {
                    
                    Image(systemName: "\(imageName)")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)

                }.frame(maxWidth: .infinity, alignment: .center)
                
                HStack() {
                    Text("\(Int(maxTemp))")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .frame(width: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Text("\(Int(minTemp))")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .frame(width: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)


                }.frame(maxWidth: 100, alignment: .center)
                
            }.frame(minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: 40,
                    alignment: .center)
        
    }
}

