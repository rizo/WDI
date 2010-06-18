/* [file: WDI/Source/Processor/scanner.l] */
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
#include <string.h>

#include "parser.h"

/*
 * TODO[1]: Move definitions  to separate "utils" file.
 */
#define bool  int
#define true  1
#define false 0

char buff[100];
int i=0;

extern unsigned int line_cnt;
extern char* progname;

/*
 * TODO[2]: Add complate html tag list.
 * TODO[3]: Move to separate data-type collection file.
 * TODO[4]: Modulize design to use external configuration file
 */
static char* tags[] =
{
	"html", "head", "body", "div",
	NULL
};

/*!
 * \brief	Checks if the given id is a tag.
 * \param	char* id Identifier to be tested.
 * \return	True if the `id` is a tag, otherwise false.
 */
bool istag(const char* id);
void warning(const char* msg, const char* type);

%}

%option nounput noinput noyywrap

whitespace      [ \t]+
string_literal  \"(\\.|[^\"\n])*\"
/* string_block    \"{3}([^\"{3}])*\"{3} */
identifier      [a-zA-Z_][A-Za-z0-9_]*
integer         [-+]?[0-9]+
EOL             \n

/* %Start WDI C */
%x STRING_BLOCK

%%
{identifier} {
	if (istag(yytext)) {
		yylval.strVal = strdup(yytext);
		return TAG;
	}

	yylval.strVal = strdup(yytext);
	return IDENTIFIER;
}

{integer} {
	yylval.intVal = atoi(yytext);
	return INTEGER;
}

{string_literal} {
		/* Copy quoted string text. */
		yylval.strVal = strdup(yytext+1);

		/* BUG: Useless rule - unterminated strings are not matched
		if (yylval.strVal[yyleng-2] != '"')
			warning("Unterminated string literal", (char*) 0);
		else */

		/* Remove close quote. */
		yylval.strVal[yyleng-2] = '\0';
		printf("%c[1;34m>> string literal:%c[0m %s\n",27, 27, yylval.strVal);
		return STRING_LITERAL;
	}

\"{3} { BEGIN STRING_BLOCK; }

{whitespace} {/* Ignore whitespace. */}

{EOL} { line_cnt++; }

[{}()=] {
	/* Let the parser use single character tokens. */
	return *yytext;
}

. {warning("Unknown character!", (char*) 0);}

<STRING_BLOCK>\"{3} {
		printf("%c[1;34m>> string block:%c[0m %s\n",27, 27, buff);
		BEGIN INITIAL;
	}

<STRING_BLOCK>.|\n { /* BUG! */
		buff[i++]=*yytext;
		/*
		 * TODO[5]: Register the string position to relative reference of text
		 */
	}

%%

bool istag(const char* id)
{
	char** tag_ptr = tags;

	/*
	 * TODO[6]: Use a faster searching method
	 *       (exempli gratia: hash table).
	 */
	while(*tag_ptr != NULL)
		if (strcmp(*tag_ptr, id) == 0)
			return true;
		else
			tag_ptr++;

	return false;
}

void warning(const char* msg, const char* type)
{
	fprintf(stderr, "[%s] line %d: %s\n", progname, line_cnt, msg);
	if(type)
		fprintf(stderr, ">> t: %s\n", type);
}
