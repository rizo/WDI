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

	#define MAX_STR_SIZE 100

	extern unsigned int line_cnt;
	extern char* progname;

	/*
	* TODO[2]: Add complate html tag list.
	* TODO[3]: Move to separate data-type collection file.
	* TODO[4]: Modulize design to use external configuration file
	*/
	static char* tags[] =
	{
		"html", "head", "body", "div", /* ... */
		NULL
	};

	/*!
	* \brief	Checks if the given id is a tag.
	* \param	char* id Identifier to be tested.
	* \return	True if the `id` is a tag, otherwise false.
	*/
	bool istag(const char* id);

	void echo();
	void warning(const char* msg, const char* type);

	/* String */
	char string_buffer[MAX_STR_SIZE];
	char *string_buffer_ptr = string_buffer;
	void save_string();
	void set_string_value();
%}

/* string_literal  \"(\\.|[^\"\n])*\" */
/* string_block    \"{3}([^\"{3}])*\"{3} */

identifier      [a-zA-Z_][A-Za-z0-9_]*
integer         [-+]?[0-9]+
whitespace      [ \t]+
EOL             \n

%option nounput noinput noyywrap
%x STRING_LITERAL STRING_BLOCK

%%

{identifier} {
	yylval.strVal = strdup(yytext);
	echo(yytext, IDENTIFIER);
	return (istag(yytext))
		? TAG
		: IDENTIFIER;
}

{integer} {
	yylval.intVal = atoi(yytext);
	echo(yytext, INTEGER);
	return INTEGER;
}

\" {/* Start saving string literal. */
	BEGIN STRING_LITERAL;
}

<STRING_LITERAL>
{
	\" {
		BEGIN(0);
		set_string_value();
		echo(string_buffer, STRING);
		return STRING;
	}

	[^"\n]+ {
		save_string();
	}
}

\"{3} {/* Start saving string block. */
	BEGIN STRING_BLOCK;
}

<STRING_BLOCK>
{
	\"{3} {
		BEGIN(0);
		set_string_value();
		echo(string_buffer, STRING);
		return STRING;
	}

	.|\n { /* BUG?: Set the negation of triple quote. */
		save_string();
	}
}

{whitespace} { /* Ignore whitespace. */ }

{EOL} { line_cnt++; }

[{}()=;] { /* TODO: Add all single-character symbols. */
	return *yytext;
}

. { warning(">> Unknown character!", (char*) 0); }

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

void echo(char *str, int tokid)
{
	printf(">> %c[1;34m token[%d]:%c[0m %s\n", 27, tokid, 27, str);
}

void warning(const char* msg, const char* type)
{
	fprintf(stderr, "[%s] line %d: %s\n", progname, line_cnt, msg);
	if(type)
		fprintf(stderr, ">> t: %s\n", type);
}

inline void save_string()
{
	char *y_ptr = yytext;
	while(*y_ptr)
		*string_buffer_ptr++ = *y_ptr++;
}

inline void set_string_value()
{
	*string_buffer_ptr = '\0';
	yylval.strVal = strdup(string_buffer);
	string_buffer_ptr = string_buffer;
}
