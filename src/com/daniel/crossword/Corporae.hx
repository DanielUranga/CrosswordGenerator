package com.daniel.crossword;

import tink.Json;
import sys.io.File;
import sys.io.FileInput;
import com.daniel.crossword.StringUtil;

/**
 * ...
 * @author Daniel Uranga
 */
class Corporae
{

	var strUtil : StringUtil;
	var wordsCount : Map<String, Int>;

	public function new()
	{
		strUtil = new StringUtil();
		wordsCount = new Map<String, Int>();
	}

	public function load(inputFilesPaths : Array<String>) {
		for (corporaPath in inputFilesPaths)
		{
			var fileInput = File.read(corporaPath);
			processCorpora(fileInput);
			fileInput.close();
			trace("loaded: " + corporaPath);
		}
		filterWordsCount();
	}
	
	public function toJson() : String {
		return Json.stringify(wordsCount);
	}
	
	public function fromJson(json : String) : Void {
		wordsCount = Json.parse(json);
		if (wordsCount == null) trace("NULL");
		trace("asdads: " + wordsCount);
	}
	
	public function toString() {
		return wordsCount.toString();
	}
	
	public function contains(word : String) : Bool {
		return wordsCount.exists(word);
	}
	
	function processCorpora(input : FileInput)
	{
		while (!input.eof())
		{
			var word = "";
			try {
				word = readSingleWord(input);
			} catch (d : Dynamic) {
				break;
			}
			if (word.length > 1)
			{
				if (wordsCount.exists(word))
				{
					wordsCount.set(word, min(wordsCount.get(word) + 1, 5000));
				}
				else
				{
					wordsCount.set(word, 1);
				}
			}
		}
	}
	
	function filterWordsCount() {
		var toRemove = [];
		for (w in wordsCount.keys()) {
			if (wordsCount.get(w) == 1) {
				toRemove.push(w);
			}
		}
		for (w in toRemove) {
			wordsCount.remove(w);
		}
	}

	function min(a : Int, b : Int) : Int
	{
		return a < b ? a : b;
	}

	function readSingleWord(input : FileInput) : String
	{
		var word = "";
		var letter = "";
		do {
			letter = readSingleLetter(input);
		} while (!isAlpha(letter) || StringTools.isSpace(letter, 0));
		do {
			word += letter;
			letter = readSingleLetter(input);
		} while (!input.eof() && isAlpha(letter));
		var currentByte = StringTools.fastCodeAt(letter, 0);
		if (currentByte == 32 || currentByte == 10)
		{
			return strUtil.encode(word);
			//return word.toLowerCase();
		}
		else {
			return "";
		}
	}

	function readSingleLetter(input : FileInput) : String
	{
		var letter = input.readString(1);
		var currentByte = StringTools.fastCodeAt(letter, 0);
		if (!isAlpha(letter) && currentByte != 32 && currentByte != 10)
		{
			var nextByte = input.readByte();
			if (currentByte != 195)
			{
				return "<";
			}
			switch ([currentByte, nextByte])
			{
				case [195, 161]: letter = "á";
				case [195, 129]: letter = "á";
				case [195, 169]: letter = "é";
				case [195, 137]: letter = "é";
				case [195, 173]: letter = "í";
				case [195, 141]: letter = "í";
				case [195, 179]: letter = "ó";
				case [195, 143]: letter = "ó";
				case [195, 186]: letter = "ú";
				case [195, 154]: letter = "ú";
				case [195, 177]: letter = "ñ";
				case [195, 188]: letter = "ü";
				default: letter = "<";
			}
		}
		return letter;
	}

	function isAlpha(input : String) : Bool
	{
		var asInt = StringTools.fastCodeAt(input, 0);
		return (
			(asInt >= "a".code && asInt <= "z".code) ||
			(asInt >= "A".code && asInt <= "Z".code) ||
			input == "á" || input == "Á" ||
			input == "é" || input == "É" ||
			input == "í" || input == "Í" ||
			input == "ó" || input == "Ó" ||
			input == "ú" || input == "Ú" ||
			input == "ü" || input == "Ü" ||
			input == "ñ" || input == "Ñ"
		);
	}

}
