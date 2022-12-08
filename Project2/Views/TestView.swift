import SwiftUI

struct TestView: View {
    @ObservedObject var vm = PCViewModel.shared
    
    var body: some View {
        VStack {
            if vm.healthKitManager.isAuthorized {
                VStack {
                    Text("Today's Step Count")
                        .font(.title3)
                    
                    Text("\(vm.userStepCount)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
            } else {
                VStack {
                    Text("Please Authorize Health!")
                        .font(.title3)
                    
                    Button {
                        vm.healthKitManager.setUpHealthRequest()
//                        vm.readStepsTakenToday()
                    } label: {
                        Text("Authorize HealthKit")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .frame(width: 320, height: 55)
                    .background(Color(.orange))
                    .cornerRadius(10)
                }
            }
            
        }
        .padding()
//        .onAppear {
//            vm.readStepsTakenToday()
//        }
    }
}
