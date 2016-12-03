import com.daniel.crossword.tests.*;
import haxe.unit.TestRunner;

class Test {

	static function main() {
		var r = new TestRunner();
		/*
		r.add(new StringSetTest());
		r.add(new StringSetSerializationTest());
		r.add(new BitsTest());
		r.add(new CharIterTest());
		r.add(new CorporaeTest());
		*/
		r.add(new DictionaryFilterTest());
		r.run();
	}
	
}
