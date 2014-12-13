%Make a list of dynamic size. (Used by the makeDinBoard function)
makeDinList( [], 0 ).

makeDinList( [0|LT], Size ) :-
	NSize is Size-1,
	makeDinList( LT, NSize ). %, !.

%Make a board of dynamic size, and return the "tab array" or "spaces array" to be used by the printBoard functions.
%Counter should be set to 0, and NumCross and NumCircle should be calculated with numPieces(...) for the current Size.
makeDinBoard( [Board], [0], Counter, Size ) :-
	ListSize is Counter+Size,
	Counter is Size-1,
	makeDinList( Board, ListSize ).

makeDinBoard( Board, Spaces, Counter, Size ) :-
	ListSize is Counter+Size,
	NewCounter is Counter+1,
	NumSpaces is Size-NewCounter,
	makeDinList( CurrentLine, ListSize ),
	makeDinBoard( InnerBoard, InnerSpaces, NewCounter, Size ),
	%Make sure that Board is CurrentLine + InnerBoard + CurrentLine.
	append( [CurrentLine], InnerBoard, TmpBoard ),
	append( TmpBoard, [CurrentLine], Board ),
	%Make sure that the identation for each line is correct.
	append( [NumSpaces], InnerSpaces, TmpSpaces ),
	append( TmpSpaces, [NumSpaces], Spaces ).

%Makes a board of side 5.
makeBoard( Board, Spaces ) :-
	Size is 5,
	makeDinBoard( NewBoard, Spaces, 0, Size ),
	numPieces( Num, Size ),
	fillBoard( NewBoard, Board, Num, Num ).

%Makes a board of side Size.
makeBoard( Board, Spaces, Size ) :-
	makeDinBoard( NewBoard, Spaces, 0, Size ),
	numPieces( Num, Size ),
	fillBoard( NewBoard, Board, Num, Num ).

%Gets the side-size of a given Board, assuming it was created regularly.
getSize( [BH|_], Size ) :-
	length( BH, Size ).

%Gets a piece of the Board, given a Line and Column.
getPiece( Board, Line, Col, Piece ) :-
	nth1( Line, Board, LineList ),
	nth1( Col, LineList, Piece ).

getPiece( _, _, _, 3 ). %Return an impossible piece on failure. (0=_, 1=X, 2=O, 3=Not a part of the game.)
