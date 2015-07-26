package com.daniel.crossword.tests;

import com.daniel.crossword.BitsOutput;
import haxe.io.Bytes;
import haxe.unit.TestCase;

class BitsTest extends TestCase {

	public function test() {
		var output = new BitsOutput();
		var testArr = [
			0, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1,
			0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0,
			1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1
		];
		for (b in testArr) {
			output.writeBit(b);
		}
		var input = new BitsInput(output.getBytes());
		var i = 0;
		for (b in testArr) {
			assertEquals(input.readBit(), b);
		}
	}

}
