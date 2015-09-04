package com.daniel.crossword;

import com.daniel.crossword.Direction;
import com.daniel.crossword.Telemetry;

using Lambda;

class CrosswordUtilRestrictedBoard {
	
	static function wordIntersections(crossword : Crossword, pos : WordPosition, wordLen : Int) : Int {
		var ret = 0;
		var itr = pos.copy();
		var delta = DirectionUtil.getDelta(itr.dir);
		var delta90 = DirectionUtil.getRotated90Delta(itr.dir);
		var delta270 = DirectionUtil.getRotated270Delta(itr.dir);
		for (i in 0...wordLen) {
			if (crossword.get(itr.x, itr.y)!=Crossword.emptyVal) {
				ret++;
			} else {
				// Count being at the side of other word as intersection
				if (crossword.get(itr.x+delta90.x, itr.y+delta90.y)!=Crossword.emptyVal) {
					ret++;
				}
				if (crossword.get(itr.x+delta270.x, itr.y+delta270.y)!=Crossword.emptyVal) {
					ret++;
				}
			}

			itr.x += delta.x;
			itr.y += delta.y;
		}
		return ret;
	}

	public static function tryAddRandomWord(crossword : Crossword, boardWidth : Int, boardHeight : Int, dict : StringSet, wordLen : Int) : Bool {
		
		var starPos : WordPosition = null;

		var possiblePos = [];
		for (y in 0...boardHeight-wordLen+1) {
			for (x in 0...boardWidth) {
				if (y>0 && crossword.get(x, y-1)!=Crossword.emptyVal) {
					continue;
				}
				possiblePos.push({pos : new WordPosition(x, y, Direction.S), intersections : 0});
			}
		}
		for (y in 0...boardHeight) {
			for (x in 0...boardWidth-wordLen+1) {
				if (x>0 && crossword.get(x-1, y)!=Crossword.emptyVal) {
					continue;
				}
				possiblePos.push({pos : new WordPosition(x, y, Direction.E), intersections : 0});
			}
		}

		var minIntersections = 999;
		for (p in possiblePos) {
			var current = wordIntersections(crossword, p.pos, wordLen);
			p.intersections = Std.int(Math.abs(1-current));
			if (Std.int(Math.abs(1-current))<minIntersections) {
				minIntersections = Std.int(Math.abs(1-current));
			}
		}

		var possibleWords = [];
		var tries = 0;
		do {
			possiblePos = possiblePos.filter(function(e) return e.intersections==minIntersections).array();
			var possible = possiblePos[Std.random(possiblePos.length)];
			possiblePos.remove(possible);
			starPos = possible.pos;

			var iter = starPos.copy();
			var delta = DirectionUtil.getDelta(iter.dir);
			dict.startFilter();
			for (i in 0...wordLen) {
				var c = crossword.get(iter.x, iter.y);
				dict.moveFilter(c!=Crossword.emptyVal ? c : "*");
				iter.x+=delta.x;
				iter.y+=delta.y;
			}
			possibleWords = dict.finishFilter();
			tries++;
		} while (possibleWords.length==0 && possiblePos.length>0);
		while (possibleWords.length>0) {
			var idx = Std.random(possibleWords.length);
			var word = possibleWords[idx];
			possibleWords[idx] = possibleWords[possibleWords.length-1];
			possibleWords.pop();
			if (crossword.putWordScore(starPos, word, dict)>0) {
				crossword.putWord(starPos, word);
				return true;
			}
		}
		return false;
	}

	public static function fillCrossword(boardWidth : Int, boardHeight : Int, dict : StringSet) : Crossword {
		DirectionUtil.init();
		var crossword = new Crossword();
		var iterationsWithouthAdding = 0;
		while (iterationsWithouthAdding<50) {

			#if telemetry
			Telemetry.getInstance().update();
			#end
			
			if (CrosswordUtilRestrictedBoard.tryAddRandomWord(crossword, boardWidth, boardHeight, dict, Std.random(10)+3)) {
				iterationsWithouthAdding = 0;
			} else {
				iterationsWithouthAdding++;
			}

		}
		return crossword;
	}

}
