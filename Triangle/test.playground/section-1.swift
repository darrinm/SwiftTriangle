import GLKit
import XCPlayground

class TriangleView: NSOpenGLView {
	override func drawRect(dirtyRect: NSRect) {
		println("drawRect")
		super.drawRect(dirtyRect)
		self.openGLContext.makeCurrentContext()
		
		glClearColor(0.0, 0.0, 0.5, 1.0)
		glClear((GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT).asUnsigned())
		glFlush()
	}
}

let frame = CGRect(x: 0, y: 0, width: 400, height: 300)
let view = TriangleView(frame: frame)
XCPShowView("Triangle View", view)