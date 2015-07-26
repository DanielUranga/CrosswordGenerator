package com.daniel.crossword;

import haxe.io.Bytes;
import haxe.io.BytesInput;

class BitsInput extends BytesInput {

	var bitPos : Int;
	var currByteBuffer : Int;

	public function new(b : Bytes, ?pos : Int, ?len : Int) {
		super(b, pos, len);
		this.bitPos = 0;
		this.currByteBuffer = 0;
	}

	public function readBit() : Int {
		if (bitPos==0) {
			currByteBuffer = this.readByte();
		}
		var ret = currByteBuffer & 0x1;
		currByteBuffer >>= 1;
		bitPos = (bitPos+1)%8;
		return ret;
	}

}
