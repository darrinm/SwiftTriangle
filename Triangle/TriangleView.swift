//
//  TriangleView.swift
//  Triangle
//
//  Created by Darrin Massena on 6/3/14.
//  Copyright (c) 2014 Darrin Massena. All rights reserved.
//

//import Foundation
//import Cocoa
//import OpenGL
import GLKit	// Needed for glClear, etc.

struct Vertex3D {
	var x: GLfloat = 0
	var y: GLfloat = 0
	var z: GLfloat = 0
}

struct Triangle3D {
	var v1: Vertex3D = Vertex3D()
	var v2: Vertex3D = Vertex3D()
	var v3: Vertex3D = Vertex3D()
}

class TriangleView: NSOpenGLView {
	var triangle: Triangle3D = Triangle3D()
	var vertexShader: GLuint = 0
	var fragmentShader: GLuint = 0
	var program: GLuint = 0
	var vertexBufferHandle: GLuint = 0
	var vertexArrayHandle: GLuint = 0
	var mpvUniformLocation: GLint = 0
	var vertexPositionAttributeLocation: GLuint = 0

    init(coder: NSCoder!) {
		super.init(coder: coder)
		initCommon()
	}
	
    init(frame: NSRect) {
        super.init(frame: frame)
		initCommon()
    }

	func initCommon() {
        openGLContext.makeCurrentContext()
		checkError()

        var fragmentShaderSource = String.stringWithContentsOfFile(NSBundle.mainBundle().pathForResource("triangle120", ofType: "frag"), encoding: NSUTF8StringEncoding, error: nil)!
        var vertexShaderSource = String.stringWithContentsOfFile(NSBundle.mainBundle().pathForResource("triangle120", ofType: "vert"), encoding: NSUTF8StringEncoding, error: nil)!

		fragmentShader = createShader(fragmentShaderSource, type: GLenum(GL_FRAGMENT_SHADER))
		checkError()
		vertexShader = createShader(vertexShaderSource, type: GLenum(GL_VERTEX_SHADER))
		checkError()
		program = glCreateProgram()
		checkError()
		glAttachShader(program, fragmentShader)
		checkError()
		glAttachShader(program, vertexShader)
		checkError()
		glLinkProgram(program)
		checkError()

		var status: GLint = 9999
		glGetProgramiv(program, GLenum(GL_LINK_STATUS), &status)
		if (status == GL_FALSE) {
			var value: GLint = 0
			glGetProgramiv(program, GLenum(GL_INFO_LOG_LENGTH), &value)
			var infoLog: GLchar[] = GLchar[](count: Int(value), repeatedValue: 0)
			var infoLogLength: GLsizei = value
			glGetProgramInfoLog(program, value, &infoLogLength, &infoLog)
			println(NSString(bytes: infoLog, length: Int(infoLogLength), encoding: NSASCIIStringEncoding))
			assert(false, "program link failed")
		}
		checkError()

		glUseProgram(program)
		checkError()

		let vertexBufferSize = 36
		
		vertexPositionAttributeLocation = GLuint(glGetAttribLocation(program, "vertexPosition_modelspace"))
		checkError()
		
		// TODO: better initialization
		let vertex1 = Vertex3D(x: 0.0, y: 1.0, z: 0.0)
		let vertex2 = Vertex3D(x: 1.0, y: -1.0, z: 0.0)
		let vertex3 = Vertex3D(x: -1.0, y: -1.0, z: 0.0)
		triangle = Triangle3D(v1: vertex1, v2: vertex2, v3: vertex3)

		/*
		var bufferHandles: GLuint[] = [ 0 ]
		glGenBuffers(1, &bufferHandles)
		vertexBufferHandle = bufferHandles[0]
		checkError()
		glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBufferHandle)
		checkError()
		glBufferData(GLenum(GL_ARRAY_BUFFER), vertexBufferSize, &triangle, GLenum(GL_STATIC_DRAW))
		checkError()
*/

		/*
		var vertexArrayHandles: GLuint[] = [ 0 ]
		glGenVertexArrays(1, &vertexArrayHandles)
		checkError()
		vertexArrayHandle = vertexArrayHandles[0]
		glBindVertexArray(vertexArrayHandle)
		checkError()
		*/

		/*
		mpvUniformLocation = glGetUniformLocation(program, "MVP")
		checkError()
		*/
	}

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

		openGLContext.makeCurrentContext()
		checkError()

		// TODO: addvertexbinding?
		
		glClearColor(0.0, 0.0, 0.5, 1.0)
		checkError()
		glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
		checkError()

		glUseProgram(program)
		checkError()
		/*
		glEnableVertexAttribArray(0)
		checkError()
		glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBufferHandle)
		checkError()
		var vertexBufferOffset: GLuint = 0
		glVertexAttribPointer(vertexPositionAttributeLocation, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, &vertexBufferOffset)
		checkError()
		*/
		glVertexAttribPointer(vertexPositionAttributeLocation, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, &triangle)
		checkError()
		glEnableVertexAttribArray(vertexPositionAttributeLocation)

//		glUniformMatrix4fv(mpvUniformLocation, 1, 0, &matrix)

		glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
		checkError()

//		glDisableVertexAttribArray(0)

		glFlush()
		checkError()
    }
	
	func createShader(shaderSource: String, type: GLenum) -> GLuint {
		var shader = glCreateShader(type)
		checkError()

		var shaderSourceCString: CString = (shaderSource as NSString).UTF8String
		glShaderSource(shader, 1, &shaderSourceCString, nil) // &shaderSourceCStringLength)
		checkError()
		glCompileShader(shader)
		checkError()
		
		var value: GLint = 0
		glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &value)
		if (value == GL_FALSE) {
			glGetShaderiv(shader, GLenum(GL_INFO_LOG_LENGTH), &value)
			var infoLog: GLchar[] = GLchar[](count: Int(value), repeatedValue: 0)
			var infoLogLength: GLsizei = 0
			glGetShaderInfoLog(shader, value, &infoLogLength, &infoLog)
			println(NSString(bytes: infoLog, length: Int(infoLogLength), encoding: NSASCIIStringEncoding))
			assert(false, "shader compilation failed")
		}

		return shader
	}
	
	func checkError() {
		var error = GLint(glGetError())
		if error != GL_NO_ERROR {
			var errors: Dictionary<CInt, String> = [
				GL_NO_ERROR: "GL_NO_ERROR", GL_INVALID_ENUM: "GL_INVALID_ENUM", GL_INVALID_VALUE: "GL_INVALID_VALUE",
				GL_INVALID_OPERATION: "GL_INVALID_OPERATION", 0x503: "GL_STACK_OVERFLOW", 0x504: "GL_STACK_UNDERFLOW",
				GL_OUT_OF_MEMORY: "GL_OUT_OF_MEMORY" ]
			println(errors[error])
			assert(false, "oops")
		}
	}
}
