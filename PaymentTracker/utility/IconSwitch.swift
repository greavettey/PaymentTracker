import SwiftUI

struct IconSwitch: View {
    @Environment(\.dismiss) var dismiss
            
    @State var iconIndex: Int = GlobalProps.AppIcons.firstIndex{ ((UIApplication.shared.alternateIconName != nil) ? UIApplication.shared.alternateIconName! : Bundle.main.name!).starts(with: $0 ) } ?? 0
    
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
                            ForEach(0 ..< GlobalProps.AppIcons.count) { c in
                                HStack {
                                    Image(uiImage: UIImage(named: GlobalProps.AppIcons[c]) ?? UIImage())
                                        .resizable()
                                        .renderingMode(.original)
                                        .frame(width: 30, height: 30, alignment: .leading)
                                        .cornerRadius(5)
                                        .padding([.trailing])
                                    Text(GlobalProps.AppIcons[c].replacingOccurrences(of: "AppIcon", with: "Standard"))
                                        .padding(.leading)
                                }
                            }
                        }).onChange(of: iconIndex, perform: { c in
                            UIApplication.shared.setAlternateIconName(iconIndex == 0 ? nil : GlobalProps.AppIcons[iconIndex], completionHandler: {
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
