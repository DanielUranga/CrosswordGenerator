package com.daniel.crossword;

import com.daniel.crossword.Direction;
import com.daniel.crossword.StringSet;

typedef Column = Map<Int, Char>;	// Cell id (Y) -> Cell
typedef Board = Map<Int, Column>;	// Row id (X) -> Column

class Crossword {

	public static var emptyVal : Char = "_";

	var board : Board;
	public var minX(default, null) : Int;
	public var minY(default, null) : Int;
	public var maxX(default, null) : Int;
	public var maxY(default, null) : Int;

	public function new() {

		board = new Board();
		minX = minY = maxX = maxY = 0;

	}

	public function copy() : Crossword {
		var copy = new Crossword();
		for (y in minY...maxY) {
			for (x in minX...maxX) {
				var c = get(x, y);
				if (c!=emptyVal) {
					copy.set(x, y, c);
				}
			}
		}
		return copy;
	}

	public function get(x : Int, y : Int) : Char {

		var column = board[x];
		if (column==null) {
			return emptyVal;
		}
		var cell = column[y];
		// _ = ASCII 95
		return (cell!=null && cell!=95) ? cell : emptyVal;

	}

	public function set(x : Int, y : Int, val : Char) : Void {

		// Update min-maxs
		minX = x < minX ? x : minX;
		maxX = x > maxX ? x : maxX;

		minY = y < minY ? y : minY;
		maxY = y > maxY ? y : maxY;

		var column = board[x];
		if (column==null) {
			column = new Column();
			board.set(x, column);
		}
		column.set(y, val);

	}

	// Checks if word that crosses over "wordPos" is in the set "dict"
	public function checkWordIsInSet(wordPos : WordPosition, dict : StringSet) : Bool {

		if (get(wordPos.x, wordPos.y)==emptyVal) {
			return false;
		}
		var wordPos = wordPos.copy();

		var normal = DirectionUtil.getDelta(wordPos.dir);
		var reverse = DirectionUtil.getRotated180Delta(wordPos.dir);
		while (get(wordPos.x+reverse.x, wordPos.y+reverse.y)!=emptyVal) {
			wordPos.x+=reverse.x;
			wordPos.y+=reverse.y;
		}
		// Now wordPos is at start of word
		var c : Char;
		dict.startHas();
		while ((c = get(wordPos.x, wordPos.y))!=emptyVal) {
			dict.moveHas(c);
			wordPos.x+=normal.x;
			wordPos.y+=normal.y;
		}

		// finaly check if "word" is in "dict" and return
		return dict.finishHas();
	}

	public function putWordScore(pos : WordPosition, word : String, dict : StringSet) : Int {

		var pos = pos.copy();
		var score = 100;
		var delta = DirectionUtil.getDelta(pos.dir);
		var delta180 = DirectionUtil.getRotated180Delta(pos.dir);
		if (get(pos.x+delta180.x, pos.y+delta180.y)!=emptyVal) {
			return -999;
		}
		var delta90 = DirectionUtil.getRotated90Delta(pos.dir);
		var delta270 = DirectionUtil.getRotated270Delta(pos.dir);

		for (i in 0...word.length) {
			var wordC = word.charAt(i);
			var boardC = get(pos.x, pos.y);
			if (boardC!=emptyVal) {
				if (boardC==wordC) {
					score+=10;			// Increase score for crossing words
				} else {
					return -999;
				}
			} else if (get(pos.x+delta90.x, pos.y+delta90.y)!=emptyVal || get(pos.x+delta270.x, pos.y+delta270.y)!=emptyVal) {
				pos.dir = pos.dir==S ? E : S;	// Rotate dir
				set(pos.x, pos.y, wordC);		// Set char in board
				var found = checkWordIsInSet(pos, dict);
				pos.dir = pos.dir==S ? E : S;	// Restore dir
				set(pos.x, pos.y, emptyVal);	// Unset char
				if (found) {
					score+=50;		// Greatly increase score if putting this word generates another crossed word
				} else {
					return -999;
				}
			}
			pos.x+=delta.x;
			pos.y+=delta.y;
		}
		if (get(pos.x, pos.y)!=emptyVal) {
			return -999;
		}
		return score;

	}

	public function putWord(pos : WordPosition, word : String) {
		var delta = DirectionUtil.getDelta(pos.dir);
		for (i in 0...word.length) {
			var c = word.charAt(i);
			set(pos.x, pos.y, c);
			pos.x+=delta.x;
			pos.y+=delta.y;
		}
	}

	function boardArea() : Int {
		return ((maxX+1)-minX)*((maxY+1)-minY);
	}

	public function score() : Int {
		
		var emptyCells = 0;
		for (y in minY...maxY+1) {
			for (x in minX...maxX+1) {
				if (get(x, y)==emptyVal) {
					emptyCells++;
				}
			}
		}
		return -emptyCells;
		
		//return -Std.int(Math.max(maxX-minX, maxY-minY));
	}

	public function toString() : String {

		#if !js
		var lineEnd = "\n";
		#end

		var ret = "";
		#if js
		ret+="<table>";
		#else
		ret += lineEnd;
		#end

		for (y in minY...maxY+1) {
			#if js
			ret += "<tr>";
			#end
			for (x in minX...maxX+1) {
				#if js
				ret += "<td>";
				#end
				var cell = get(x, y);
				if (cell!=emptyVal) {
					#if js
					ret+='${cell.toString()}';
					#else
					ret+='${cell.toString()}, ';
					#end
				} else {
					#if !js
					ret+='_, ';
					#end
				}
				#if js
				ret += "</td>";
				#end
			}
			#if js
			ret += "</tr>";
			#else
			ret+=lineEnd;
			#end
		}

		#if js
		ret+="</table>";
		#end
		return ret;
	}

	public function printCrossword() {
		#if js
		js.Browser.document.getElementById("haxe:trace").innerHTML = toString();
		#else
		trace('${maxX-minX+1}, ${maxY-minY+1}\n${toString()}');
		#end
	}

}
