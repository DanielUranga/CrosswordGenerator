package com.daniel.crossword;

import haxe.io.Bytes;
import haxe.io.BytesOutput;

class BitsOutput extends BytesOutput {

	var bitPos : Int;
	var currByteBuffer : Int;

	public function new() {
		super();
		this.bitPos = 0;
		this.currByteBuffer = 0;
	}

	function flushBits() {
		writeByte(currByteBuffer);
		currByteBuffer = 0;
		bitPos = 0;
	}

	public function writeBit(bit : Int) : Void {
		if (bitPos==8) {
			flushBits();
		}
		currByteBuffer |= (bit&0x1)<<bitPos;
		bitPos++;
	}

	override public function getBytes() {
		flushBits();
		return super.getBytes();
	}

	override public function close() {
		flushBits();
		return super.close();
	}

}
