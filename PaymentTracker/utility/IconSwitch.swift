import SwiftUI

struct IconSwitch: View {
    @Environment(\.dismiss) var dismiss
    
    var iconList: [String] = ["AppIcon", "Royalty", "Periwinkle", "Eyebite", "Subdued"]
        
    @State var iconIndex: Int = ["AppIcon", "Royalty", "Periwinkle", "Eyebite", "Subdued"].firstIndex{ ((UIApplication.shared.alternateIconName != nil) ? UIApplication.shared.alternateIconName! : Bundle.main.name!).starts(with: $0 ) } ?? 0
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack{
                HStack{
                    Text("Set App Icon")
                        .font(.title)
                        .multilineTextAlignment(.leading)
                        .padding()
                    Spacer()
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "x.square.fill")
                            .padding()
                            .font(.title)
                    })
                }
                Form {
                    Section(footer: Text("Changes are applied instantly, but take a few minutes to show up in-app.")) {
                        Picker(selection: $iconIndex, label: Text("Choose an app icon"), content: {
                            ForEach(0 ..< iconList.count) { c in
                                HStack {
                                    Image(uiImage: UIImage(named: iconList[c]) ?? UIImage())
                                        .resizable()
                                        .renderingMode(.original)
                                        .frame(width: 30, height: 30, alignment: .leading)
                                        .cornerRadius(5)
                                        .padding([.trailing])
                                    Text(iconList[c].replacingOccurrences(of: "AppIcon", with: "Standard"))
                                        .padding(.leading)
                                }
                            }
                        }).onChange(of: iconIndex, perform: { c in
                            print(iconList[iconIndex])
                            UIApplication.shared.setAlternateIconName(iconIndex == 0 ? nil : iconList[iconIndex], completionHandler: {
                                error in
                                if let error = error {
                                    print(error.localizedDescription)
                                    dismiss()
                                } else {
                                    print("Success!")
                                    dismiss()
                                }
                            })
                        })
                            .pickerStyle(.inline)
                            .labelsHidden()
                            .padding()
                    }
                }
            }
        }
    }
}
