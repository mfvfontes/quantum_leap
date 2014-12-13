%Replace a piece, given a Line and Column to replace them on.
replaceInLine( [_|LT], [Piece|LT], 1, Piece ).

replaceInLine( [LH|LT], [LH|RLT], Col, Piece ) :-
	NewCol is Col-1,
	replaceInLine( LT, RLT, NewCol, Piece ).

replacePiece([BH|BT], [RBH|BT], 1, Col, Piece) :-
	replaceInLine( BH, RBH, Col, Piece ).

replacePiece([BH|BT], [BH|RBT], Line, Col, Piece) :-
	NewLine is Line-1,
	replacePiece( BT, RBT, NewLine, Col, Piece ).

%Move a Piece, given the Board, the Line and Column of the Piece and the destionation Line and Column to move the Piece to.
movePiece( Board, ResultBoard, Line, Col, LineDest, ColDest ) :-
	getPiece( Board, Line, Col, Piece ), %Get the piece we're trying to move.
	replacePiece( Board, TmpBoard, LineDest, ColDest, Piece ), %Set the piece in the destination correctly.
	replacePiece( TmpBoard, ResultBoard, Line, Col, 0 ). %Erase the place where the piece moved from.
