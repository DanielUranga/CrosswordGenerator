package com.daniel.crossword;

import sys.io.File;
import sys.io.FileInput;
import com.daniel.crossword.StringUtil;
import thx.Strings;
import unifill.CodePoint;
import unifill.Utf8;

/**
 * ...
 * @author Daniel Uranga
 */
class Corporae
{

	public function new(inputFilesPaths : Array<String>) {
		for (corporaPath in inputFilesPaths) {
			var fileInput = File.read(corporaPath);
			processCorpora(fileInput);
			fileInput.close();
		}
	}
	
	function processCorpora(input : FileInput) {
		for (i in 0...1000) {
			trace("Word: " + "\"" + readSingleWord(input) + "\"");
		}
	}
	
	function readSingleWord(input : FileInput) : String {
		var word = "";
		var letter = "";
		do {
			letter = readSingleLetter(input);
		} while (!isAlpha(letter) || StringTools.isSpace(letter, 0));
		do {
			word += letter;
			letter = readSingleLetter(input);
		} while (!input.eof() && isAlpha(letter));
		return word;
	}
	
	function readSingleLetter(input : FileInput) : String {
		var letter = input.readString(1);
		var currentByte = StringTools.fastCodeAt(letter, 0);
		if (!isAlpha(letter) && currentByte != 32 && currentByte != 10) {
			var nextByte = input.readByte();
			switch ([currentByte, nextByte]) {
				case [195, 161]: letter = "á";
				case [195, 169]: letter = "é";
				case [195, 173]: letter = "í";
				case [195, 179]: letter = "ó";
				case [195, 186]: letter = "ú";
				case [195, 177]: letter = "ñ";
				default: { trace("non alpha: " + letter + " = " + StringTools.fastCodeAt(letter, 0) + ", nextByte = " + nextByte); }
			}
		}
		return letter;
	}
	
	function isAlpha(input : String) : Bool {
		return Strings.isAlpha(input) ||
			input == "á" ||
			input == "é" ||
			input == "í" ||
			input == "ó" ||
			input == "ú" ||
			input == "ñ";
	}
	
}
