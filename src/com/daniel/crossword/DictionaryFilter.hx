package com.daniel.crossword;

import sys.io.File;

class DictionaryFilter {

	public static function filter(inputPath : String, outputPath : String, corpora : Corporae) {
		
		var strUtil = new StringUtil();
		var input = File.read(inputPath);
		var output = File.write(outputPath);
		
		while (!input.eof()) {
			
			var word = "";
			try {
				word = input.readLine();
			} catch (d : Dynamic) {
				while (!input.eof()) {
					word += input.readString(1);
				}
			}
			
			if (word.length > 0 && corpora.contains(strUtil.encode(word))) {
				output.writeString(word + "\n");
			}
		}
		
		input.close();
		output.close();
		
	}
	
}
