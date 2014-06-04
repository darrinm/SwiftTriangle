//import Cocoa
import GLKit
import XCPlayground

struct Vertex3D {
	var x: GLfloat
	var y: GLfloat
	var z: GLfloat
}

struct Triangle3D {
	var v1: Vertex3D
	var v2: Vertex3D
	var v3: Vertex3D
}

let frame = CGRect(x: 0, y: 0, width: 400, height: 300)
class TriangleView: NSOpenGLView {
	override func drawRect(dirtyRect: NSRect) {
		super.drawRect(dirtyRect)
		self.openGLContext.makeCurrentContext()
		
		glClearColor(0.0, 0.0, 0.5, 1.0)
		glClear((GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT).asUnsigned())
		
		let vertex1 = Vertex3D(x: 0.0, y: 1.0, z: -3.0)
		let vertex2 = Vertex3D(x: 1.0, y: 0.0, z: -3.0)
		let vertex3 = Vertex3D(x: -1.0, y: 0.0, z: -3.0)
		let triangle = Triangle3D(v1: vertex1, v2: vertex2, v3: vertex3)

//		glUniformMatrix4fv(<#location: GLint#>, <#count: GLsizei#>, <#transpose: GLboolean#>, <#value: CConstPointer<GLfloat>#>)
		glDrawArrays(GL_TRIANGLES.asUnsigned(), 0, 3)

		glFlush()
	}
	
	func loadShader(shaderSource: String, type: GLenum) -> GLuint {
		var shader = glCreateShader(type)
		
		var shaderSourceCString: CString = (shaderSource as NSString).UTF8String
		var lengthNumber: NSNumber = (shaderSource as NSString).lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
		var shaderSourceCStringLength: GLint = lengthNumber.intValue
		glShaderSource(shader, 1, &shaderSourceCString, nil) // &shaderSourceCStringLength)
		glCompileShader(shader)
		
		return shader
	}
}

let view = TriangleView(frame: frame)
XCPShowView("Triangle View", view)
