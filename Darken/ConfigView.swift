import SwiftUI

struct ConfigView: View {
	
    @State private var darkness = 30.0
	@State private var isEditing = false
	
	@State private var movable = DarkenWindow.allowMoving
	@State private var allSpaces = DarkenWindow.showOnAllSpaces
	@State private var hideDock = !DarkenWindow.showInDock
	
	var body: some View {
		VStack {
            Text(String(format: "%d%%", Int(darkness)))
                .font(.system(size: 24))
                .bold()
			// For adjusting the overall scale
			Slider(
				value: $darkness,
				in: 15...80,
				step: 5,
				onEditingChanged: { editing in
                    DarkenWindow.darkness = (darkness / 100.0)
					DarkenWindow.singleton?.refreshDimensions()
				}
			).frame(width: 140)
		}
		
		.scaledToFit()
	}
}

struct ConfigView_Previews: PreviewProvider {
	static var previews: some View {
		ConfigView()
	}
}
