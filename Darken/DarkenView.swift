import SwiftUI

struct DarkenView: View {
    var body: some View {
		Rectangle()
            .fill(Color.black.opacity(DarkenWindow.darkness))
			.frame(width: CGFloat(DarkenWindow.fullScreenWidth), height: CGFloat(DarkenWindow.fullScreenHeight))
    }
}

struct DarkenView_Previews: PreviewProvider {
    static var previews: some View {
        DarkenView()
    }
}
