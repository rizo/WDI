/* [file: WDI/Source/Processor/parser.y] */
/*
 * WDI: Web Development Interface
 *
 * Copyright (c) 2009 - 2010, ODIS, Rizo Isrofov <irm@odisproject.com>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *   * Redistributions of source code must retain the above copyright notice,
 *     this list of conditions and the following disclaimer.
 *   * Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *   * Neither the name of the ODIS nor the names of its contributors may be
 *     used to endorse or promote products derived from this software without
 *     specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY ODIS ''AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL ODIS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

%{
	#include <stdio.h>
	#include <stdlib.h>

	#define DEFAULT_OUTFILE "wdi.out"

	void yyerror(const char* msg);
	extern int yylex(void);
	extern FILE *yyin, *yyout;
	unsigned int line_cnt=1;
	char* progname;
	char* usage = "%s: usage <infile> <outfile>\n";
%}

%union {
	int intVal;      /* Integer values used in statements. */
	char* strVal;    /* Tags, identifiers and strings. */
}

%token <intVal> INTEGER
%token <strVal> TAG IDENTIFIER STRING_LITERAL

%%

input
	: /* Empty input. */
	| input input_specifier
	;

input_specifier
	: expression  /* Returns printable content (no side effects). */
	| statement   /* Executable code only (operation, instruction). */
	| definition  /* Declaration and assignment of an identifier. */
	;

expression
	: ';'
	| primary_expression ';'
	;

primary_expression
	: STRING_LITERAL
	;

statement
	: 'b'
	;

definition
	: 'c'
	;

%%

void yyerror(msg)
	const char* msg;
{
	fprintf(stderr,">> %s\n", msg);
}

int main(argc, argv)
	int argc; char** argv;
{
	char* infile;
	char* outfile;

	progname = argv[0];

	if (argc > 3) {
		fprintf(stderr, usage, progname);
		exit(1);
	}
	if (argc > 1) {
		infile = argv[1];
		yyin = fopen(infile, "r");
		if (yyin == NULL) {
			fprintf(stderr, "%s: cannot open %s\n", progname, infile);
			exit(1);
		}
	}

	if (argc > 2)
		outfile = argv[2];
	else
		outfile = DEFAULT_OUTFILE;

	yyout = fopen(outfile, "w");
	if (yyout == NULL) {
		fprintf(stderr, "%s: cannot open %s\n", progname, outfile);
		exit(1);
	}
	printf("%c[1;31m-- Web Development Interface%c[0m\n\n",27, 27);
	yyparse();
	return 0;
}

