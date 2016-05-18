// ui.js
// © 2016 David J Goehrig
//

Renderer = function() {
	var commands = Array.prototype.slice.apply(arguments,[0])
	while(commands.length) {
		var args = commands.slice(1)
		var fun =  Renderer[commands[0]]
		commands = fun.apply(Renderer, args)
	}
}

// lineTo
Renderer.l = function () {
	this.x = arguments[0]
	this.y = arguments[1]
	this.context.lineTo(this.x,this.y)
	this.context.stroke()
	return Array.prototype.slice.apply(arguments,[2])
}

// moveTo
Renderer.m = function () {
	this.x = arguments[0]
	this.y = arguments[1]
	this.context.moveTo(this.x,this.y)
	return Array.prototype.slice.apply(arguments,[2])
}

// fillRect
Renderer.f = function () {
	this.w = arguments[0]
	this.h = arguments[1]
	this.context.fillRect(this.x,this.y,this.w,this.h,this.foreground)
	return Array.prototype.slice.apply(arguments,[2])
}

// clearRect
Renderer.c = function () {
	this.w = arguments[0]
	this.h = arguments[1]
	this.context.clearRect(this.x,this.y,this.w,this.h)
	return Array.prototype.slice.apply(arguments,[2])
}

// foreground
Renderer.fg = function () {
	this.r = arguments[0]
	this.g = arguments[1]
	this.b = arguments[2]
	this.a = arguments[3]
	this.context.fillStyle = this.context.strokeStyle = 
		'rgba(' + this.r + ',' + this.g + ',' + 
		this.b + ',' + this.a + ')'
	return Array.prototype.slice.apply(arguments,[4])
}

Renderer.bg = function () {
	this.r = arguments[0]
	this.g = arguments[1]
	this.b = arguments[2]
	this.a = arguments[3]
	this.canvas.style.background = 
		'rgba(' + this.r + ',' + this.g + ',' + 
		this.b + ',' + this.a + ')'
	return Array.prototype.slice.apply(arguments,[4])
}

Renderer.canvas = document.getElementById('canvas')
Renderer.context = Renderer.canvas.getContext('2d')
Renderer.canvas.width = window.innerWidth
Renderer.canvas.height = window.innerHeight

Renderer.ws = new WebSocket('ws://localhost:8880/ui')
Renderer.ws.onMessage = function(message) {
	var widget = JSON.parse(message.data)
	Renderer.apply(Renderer,widget)	
}
