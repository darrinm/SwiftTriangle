#version 120
// Input vertex data, different for all executions of this shader.
attribute vec3 vertexPosition_modelspace;
//uniform mat4 MVP;

void main(){
	// Output position of the vertex, in clip space : MVP * position.
	vec4 v = vec4(vertexPosition_modelspace, 1);
//	gl_Position = MVP * v;
	gl_Position = v;
}
