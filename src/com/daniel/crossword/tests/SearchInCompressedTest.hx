package com.daniel.crossword.tests;

import com.daniel.crossword.StringSet;
import haxe.io.Bytes;
import haxe.unit.TestCase;
import sys.io.File;

class SearchInCompressedTest extends TestCase {

	public function test() {
		Sys.print("Uncompress... ");
		var uncmp = StringSet.getUncompressedBytes(File.getBytes("src/com/daniel/crossword/dict/ES.compressed"));
		Sys.println(" OK");
		var testWords = ["perro", "gato", "entropia", "astartio"];
		for (w in testWords) {
			Sys.print(w + "...");
			Sys.println(StringSet.bytesHasWord(uncmp, w));
		}
		assertTrue(true);
	}

}
