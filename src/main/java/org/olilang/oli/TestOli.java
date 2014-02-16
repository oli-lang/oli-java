package org.olilang.oli;

import java.io.FileInputStream;
import java.io.InputStream;

import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTree;

public class TestOli {

	public static void main(String[] args) throws Exception {
		String inputFile = null;
		if (args.length > 0)
			inputFile = args[0];
		InputStream is = System.in;
		if (inputFile != null) {
			is = new FileInputStream(inputFile);
		}
		ANTLRInputStream input = new ANTLRInputStream(is);
		OliLexer lexer = new OliLexer(input);
		CommonTokenStream tokens = new CommonTokenStream(lexer);

		OliParser parser = new OliParser(tokens);
		ParseTree tree = parser.literal(); // begin parsing at init rule
		System.out.println(tree.toStringTree(parser));
		
	}
}
