package com.daniel.crossword;

#if telemetry
import hxtelemetry.HxTelemetry;
#end

class Telemetry {

	static var instance : Telemetry = null;
	#if telemetry
	var hxt : HxTelemetry;
	#end

	public static function getInstance() {
		if (instance==null) {
			instance = new Telemetry();
		}
		return instance;
	}

	function new() {
		#if telemetry
		hxt = new HxTelemetry();
		#end
	}

	public function update() {
		#if telemetry
		hxt.advance_frame();
		#end
	}

}
