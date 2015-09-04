package com.daniel.crossword;

import hxtelemetry.HxTelemetry;

class Telemetry {

	static var instance : Telemetry = null;
	var hxt : HxTelemetry;

	public static function getInstance() {
		if (instance==null) {
			instance = new Telemetry();
		}
		return instance;
	}

	function new() {
		hxt = new HxTelemetry();
	}

	public function update() {
		hxt.advance_frame();
	}

}
