%Prints M numbers, to help identify the position of each piece in the board.
printNums( 0 ).
printNums( M ) :-
	MM is M-1,
	printNums( MM ),
	write( M ),
	write( ' ' ).

%Prints a Line of the Board's elements.
printLine( [], 0 ).
printLine( [E|List], M ) :-
	translate( E, C ),
	write( C ),
	write( ' ' ),
	printLine( List, MM ),
	M is MM+1.

%Translates one of the Board's numerical elements into a human-readable character: Empty, Cross or Circle.
translate( 0, '_' ).
translate( 1, 'X' ).
translate( 2, 'O' ).

%Prints N spaces. In use since the tab function has been deprecated.
tab( 0 ).
tab( N ) :-
	N > 0,
	write( ' ' ),
	NN is N-1,
	tab( NN ).

%Given a Board and an array of spaces (for the identation of each line of the board), prints the board and numbers to help identify the position of each piece in the board.
printBoard( [], [], _ ).
printBoard( [Head|Tail], [SpaceNum|SpaceList], N ) :-
	write( N ),
	tab( SpaceNum ),
	write( ' [ ' ),
	printLine( Head, M ),
	write( ']' ),
	nl,
	tab( SpaceNum ),
	write( '    ' ),
	printNums( M ),
	nl,
	NN is N+1,
	printBoard( Tail , SpaceList, NN ).

printBoard( Board, Spaces ) :-
	printBoard( Board, Spaces, 1 ).

%Similar to printNums, but only prints a single selector.
printSelector( 1, 1 ) :- %We reached the collumn we want to point to, print an arrow under it then.
	write( '^' ).
printSelector( 1, Col ) :- %We're in the line we want to print the selector, so now we get to the collumn.
	NCol is Col-1,
	write( '  ' ),
	printSelector( 1, NCol ).
printSelector( _, _ ). %All other cases do nothing.

%Prints the Board, without any numbers but with a single arrow underneath the selected piece.
printSel( [], [], _, _, _ ).
printSel( [Head|Tail], [SpaceNum|SpaceList], Line, Col, N ) :-
	write( N ),
	tab( SpaceNum ),
	write( ' [ ' ),
	printLine( Head, _ ),
	write( ']' ),
	nl,
	tab( SpaceNum ),
	write( '    ' ),
	printSelector( Line, Col ),
	nl,
	NLine is Line-1,
	NN is N+1,
	printSel( Tail , SpaceList, NLine, Col, NN ).

printSel( Board, Spaces, Line, Col ) :-
	printSel( Board, Spaces, Line, Col, 1 ).

%Prints an array of possible moves.
printMoves( [] ) :-
	nl,
	write( 'That piece has no moves!' ).
printMoves( [[L|C]|[]] ) :-
	nl,
	write( '  [' ),
	write( C ),
	write( ', ' ),
	write( L ),
	write( ']' ).
printMoves( [[L|C]|MT] ) :-
	nl,
	write( '  [' ),
	write( C ),
	write( ', ' ),
	write( L ),
	write( ']' ),
	printMoves( MT ).
