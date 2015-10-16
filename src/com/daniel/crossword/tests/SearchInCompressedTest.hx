package com.daniel.crossword.tests;

import com.daniel.crossword.StringSet;
import com.daniel.crossword.StringUtil;
import haxe.io.Bytes;
import haxe.unit.TestCase;
import sys.io.File;

class SearchInCompressedTest extends TestCase {

	public function test() {
		Sys.println("");
		Sys.print("Uncompress... ");
		var uncmp = StringSet.getUncompressedBytes(File.getBytes("src/com/daniel/crossword/dict/ES.compressed"));
		Sys.println(" OK, length: " + Std.int(uncmp.length/1024) + "k");
		var testWords = ["perro", "gato", "entropia", "astartio", "canción", "ñandú", "zorro", "notfound"];
		var strUtil = new StringUtil();
		for (w in testWords) {
			Sys.print(w + " ... ");
			Sys.println(StringSet.bytesHasWord(uncmp, w, strUtil));
		}
		Sys.println("");
		var testWords2 = [
			"practico",
			"antidoto",
			"asiatico",
			"monosilaba",
			"obstaculo",
			"cadaver",
			"campeon",
			"ñandu"
		];
		for (w in testWords2) {
			Sys.print(w + " ... ");
			var result = StringSet.bytesHasSimilarWord(uncmp, w, strUtil);
			if (result!=null) {
				Sys.println(result);
			} else {
				Sys.println("<not found>");
			}
		}
		assertTrue(true);
	}

}
